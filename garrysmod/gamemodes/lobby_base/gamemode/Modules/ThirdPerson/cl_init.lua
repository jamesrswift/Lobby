local cam_collision		= GetConVar("cam_collision")
local cam_idealdist		= GetConVar("cam_idealdist")
local cam_ideallag		= GetConVar("cam_ideallag")
local cam_idealpitch	= GetConVar("cam_idealpitch")
local cam_idealyaw		= GetConVar("cam_idealyaw")
local sensitivity		= GetConVar("sensitivity")

local deathcam_dist					= CreateConVar("deathcam_dist"					, 100)
local deathcam_zoomout_delay		= CreateConVar("deathcam_zoomout_delay"			, 1.5)
local deathcam_lag					= CreateConVar("deathcam_lag"					, 2)
local deathcam_rot_approach_speed	= CreateConVar("deathcam_rot_approach_speed"	, 6)

ThirdpersonEndDelay			= 0.3
SensitivityMultiplier		= 0.0022
LagMultiplier				= 2

function SetDesiredCenteredView(pl, origin, ang, tbl)
	tbl = tbl or {}
	local newang = ang + Angle(cam_idealpitch:GetFloat(), cam_idealyaw:GetFloat(), 0)
	newang.r = 0
	local newdist = tbl.dist or cam_idealdist:GetFloat()
	
	if not pl.CurrentView then
		pl.CurrentView = {
			angles = tbl.defaultang or ang,
			distance = tbl.defaultdist or 0
		}
	end
	
	pl.TargetView = {
		angles = newang,
	}
	
	local lag = LagMultiplier/(LagMultiplier+(tbl.lag or cam_ideallag:GetFloat()))
	
	pl.CurrentView.angles = LerpAngle(lag, pl.CurrentView.angles, pl.TargetView.angles)
	
	if tbl.collision or cam_collision:GetBool() then
		local tr = util.TraceHull{
			start = origin,
			endpos = origin - newdist * pl.CurrentView.angles:Forward(),
			filter = pl,
			mins = Vector(-3,-3,-3),
			maxs = Vector( 3, 3, 3)
		}
		newdist = newdist * tr.Fraction
	end
	pl.TargetView.distance = newdist
	
	if pl.CurrentView.distance>pl.TargetView.distance then
		pl.CurrentView.distance = pl.TargetView.distance
	else
		pl.CurrentView.distance = Lerp(lag, pl.CurrentView.distance, pl.TargetView.distance)
	end
	
	return {angles = pl.CurrentView.angles, origin = origin - pl.CurrentView.distance * pl.CurrentView.angles:Forward()}
end


hook.Add("CalcView", "LCalcView", function(pl, pos, ang, fov)
	if not pl.IsThirdperson then
		return
	end
	
	if pl.SimulatedCamera and pl.CameraAngles then
		ang = pl.CameraAngles
	end
	
	if pl.NextEndThirdperson then
		if CurTime()>pl.NextEndThirdperson then
			pl.NextEndThirdperson = nil
			pl.IsThirdperson = false
			if not IsValid(GetViewEntity()) or GetViewEntity()==LocalPlayer() then
				gamemode.Call("OnViewModeChanged", false)
			end
			return
		else
			pl.CurrentView.angles = ang
			pl.CurrentView.distance = Lerp((pl.NextEndThirdperson - CurTime())/ThirdpersonEndDelay, 0, pl.TargetView.distance)
			return {angles = pl.CurrentView.angles, origin = pos - pl.CurrentView.distance * pl.CurrentView.angles:Forward()}
		end
	end
	
	return SetDesiredCenteredView(pl, pos, ang)
end)

function StartThirdperson()
	LocalPlayer().IsThirdperson = true
	LocalPlayer().CurrentView = nil
	
	if not IsValid(GetViewEntity()) or GetViewEntity()==LocalPlayer() then
		gamemode.Call("OnViewModeChanged", true)
	end
end

function EndThirdperson(immediate)
	if immediate then
		LocalPlayer().NextEndThirdperson = nil
		LocalPlayer().IsThirdperson = false
	else
		LocalPlayer().NextEndThirdperson = CurTime() + ThirdpersonEndDelay
	end
end

hook.Add("Think", "ViewEntityCheck", function()
	local viewent = GetViewEntity()
	local lastviewent = LocalPlayer().LastViewEntity
	
	if lastviewent then
		if viewent ~= lastviewent then
			if (ValidEntity(viewent) and viewent~=LocalPlayer()) and not (ValidEntity(lastviewent) and lastviewent~=LocalPlayer()) then
				gamemode.Call("OnViewModeChanged", true)
			elseif not (ValidEntity(viewent) and viewent~=LocalPlayer()) and (ValidEntity(lastviewent) and lastviewent~=LocalPlayer()) then
				gamemode.Call("OnViewModeChanged", false)
			end
		end
	end
	LocalPlayer().LastViewEntity = viewent
end)

concommand.Add("lobby_thirdperson", function(pl)
	pl.IsThirdperson = !pl.IsThirdperson
	if pl.IsThirdperson then
		StartThirdperson()
	else
		EndThirdperson()
	end
end)

hook.Add("ShouldDrawLocalPlayer", "thirdperson" , function() 
	return LocalPlayer().IsThirdperson
end)
