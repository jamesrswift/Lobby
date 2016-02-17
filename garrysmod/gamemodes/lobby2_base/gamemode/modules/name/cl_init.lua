--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, 2015
	
-----------------------------------------------------------]]--

Module.HUDTargets = {}
Module.fadeTime = 2

function Module:DrawName( Pl, opacityScale )

	if ( not IsValid( Pl ) or not Pl:Alive() ) then return end

	local ang = LocalPlayer():EyeAngles()
	ang:RotateAroundAxis( ang:Forward(), 90 )
	ang:RotateAroundAxis( ang:Right(), 90 )

	local dist = LocalPlayer():GetPos():Distance( Pl:GetPos() )
	if ( dist >= 800 ) then return end
	
	local opacity = math.Clamp( 310.526 - ( 0.394737 * dist ), 0, 150 )
	opacityScale = opacityScale and opacityScale or 1
	opacity = opacity * opacityScale
	
	local pos = Pl:GetPos() + Vector (0, 0, 75 )
	
	local PlayerNameColor = Color( 255, 255, 255 )
	if ( Pl:GetUserGroup() ~= "user" ) then
		PlayerNameColor = Pl:GetDisplayTextColor( )
	end

	cam.Start3D2D( pos, Angle( 0, ang.y, 90 ), 0.075 )

		render.OverrideDepthEnable(false, true)
		
			draw.TextShadow( {
				text = string.upper( Pl:GetName() ),
				font = "LobbySkyText",
				pos = {
					0,
					0
				},
				xalign = TEXT_ALIGN_CENTER,
				yalign = TEXT_ALIGN_CENTER,
				color = Color( PlayerNameColor.r, PlayerNameColor.g, PlayerNameColor.b, opacity )
			}, 2, opacity )
		
			draw.Text( {
				text = string.upper( Pl:GetName() ),
				font = "LobbySkyText",
				pos = {
					0,
					0
				},
				xalign = TEXT_ALIGN_CENTER,
				yalign = TEXT_ALIGN_CENTER,
				color = Color( PlayerNameColor.r, PlayerNameColor.g, PlayerNameColor.b, opacity )
			} )
		
		render.OverrideDepthEnable(false, false)

	cam.End3D2D()

end

function Module:PostDrawTranslucentRenderables( )

	if IsValid( LocalPlayer():GetVehicle() ) then return end

	for Pl, time in pairs( self.HUDTargets ) do

		if time < RealTime() then
			self.HUDTargets[ Pl ] = nil
			continue
		end

		-- Fade over time
		self:DrawName( Pl, 1 * ((time - RealTime()) / self.fadeTime) )

	end

	local tr = util.GetPlayerTrace( LocalPlayer() )
	local trace = util.TraceLine( tr )
	
	if ( not trace.Hit ) then return end
	if ( not trace.HitNonWorld ) then return end
	if ( not ( trace.Entity and IsValid( trace.Entity ) ) ) then return end
	
	if ( trace.Entity:IsPlayer() ) then
	
		self.HUDTargets[trace.Entity] = RealTime() + self.fadeTime
		
	elseif trace.Entity:IsVehicle() and IsValid(trace.Entity:GetOwner()) and trace.Entity:GetOwner():IsPlayer() then
	
		self.HUDTargets[trace.Entity:GetOwner()] = RealTime() + self.fadeTime
		
	end

	
end

function Module:HUDDrawTargetID( )

	-- Disable the default in the gamemode, looks silly having it display twice
	return false

end
