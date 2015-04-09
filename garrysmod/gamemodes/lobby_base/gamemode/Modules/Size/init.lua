
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )
 
local filter = RecipientFilter()
filter:AddAllPlayers()
 
local function SendOffset(ply,size)
	umsg.Start("size",filter)
		umsg.Entity(ply)
		umsg.Float(size)
	umsg.End();
end

function AdjustSc(v)
	local scale, adjust
	local md = v:GetModel()
	
	psc = 1.0
	if (EyeAdjustments[md]) then
		psc=EyeAdjustments[md]
	end
	
	local eyeheight = v:GetInfo("resize_eyeoffset");

	if eyeheight and tonumber(eyeheight) then
		local eyescale = tonumber(eyeheight)
		if(eyescale < 0) then
			eyescale = 0
		end;
		psc = psc * eyescale;
	end
	
	adjust = false
	
		
	if v.Progress!=-1  then
		if (!v.Progress) then SetOrgScale(v, 1 ) end
		adjust = true 
		local add = FrameTime()*100;
		v.Progress = v.Progress + add; 
		if (v.Progress >= v.EndProgress) then 
			v.Scale = v.TargetScale           
			v.Progress = -1;				  
		else
			if v.ExponentialScaling then
				v.Scale = v.SourceScale * (1/2)^(v.Progress*v.ScaleSpeed)
			else
				v.Scale = v.SourceScale + v.Progress * v.ScaleSpeed
			end
		end
		SendOffset(v,v.Scale)
	end
	
	if not v.OldPsc then
		adjust=true
	elseif psc!=v.OldPsc then
		adjust=true
	end
	
	v.OldPsc=psc
	
	scale = v.Scale
	
	if adjust then
		local vsc=psc*scale
		
		jumpscale = scale/math.sqrt(psc)
		if(jumpscale<1) then  
			jumpscale=1
		end
		v:SetJumpPower( math.sqrt(jumpscale)*Sizing.Default.JumpPower )
		
		--step size
		local ss=scale*Sizing.Default.StepSize
		if ss>Sizing.Default.MaxStepSize then 
			ss=Sizing.Default.MaxStepSize
		end
		v:SetStepSize( ss )
	
		v:SetViewOffset( 	vsc*Sizing.Default.ViewOffset 		)
		v:SetViewOffsetDucked( 	vsc*Sizing.Default.ViewOffsetDuck 	)
		v:SetNetworkedFloat("PlViewOffset",vsc)
	
		local hsc=vsc
		if(hsc>Sizing.Default.MaxHullScale) then
			hsc=Sizing.Default.MaxHullScale
		end
		v:SetNetworkedFloat("PlHullScale",hsc) 
		v:SetHull( 	hsc*Sizing.Default.StandingHull.Minimum	, hsc*Sizing.Default.StandingHull.Maximum 	)
		v:SetHullDuck( 	hsc*Sizing.Default.DuckingHull.Minimum	, hsc*Sizing.Default.DuckingHull.Maximum 	)		
	end
	
	local ws=math.sqrt(scale)*Sizing.Default.WalkSpeed		
	local rs=math.sqrt(scale)*Sizing.Default.RunSpeed
	
	gamemode.Call( "SetPlayerSpeed", v, ws, rs)	

end


local function Tick( )		
	local k, v
	
	for k, v in pairs( player.GetAll( ) ) do
		if v:Alive() then --only modify living players
			AdjustSc(v)
		end
	end
			
end

hook.Add( "Tick", "Resizer.Tick", Tick )

--does the player allow being rescaled by others
function GetAllow(pl)
	local allow=tonumber(pl:GetInfo("resize_allow"))
	
	if allow then
		if allow<=0 then
			return false
		else
			return true
		end
	else
		return true
	end;
end

--store the target player size into the database
function StoreSize(pl, scale)
	local name,lscale,allow,aallow;

	lscale = pl.TargetScale
	name = pl:UniqueID()

	if lscale>100 then
		lscale=100
	end

	aallow = 1
	
	local entry_exists = sql.Query( "SELECT * FROM player_scales WHERE uniqueid = "..pl:UniqueID()..";" )

	if ( !entry_exists ) then 
		sql.Query( "INSERT INTO player_scales VALUES ("..pl:UniqueID()..","..lscale..","..aallow..");");
	else
		sql.Query( "UPDATE player_scales SET scale="..lscale..",allowothers="..aallow.." WHERE uniqueid = "..pl:UniqueID()..";");
	end

end

--read the player scale from the database if existing
--otherwise set default scales and default vars
function SetOrgScale( pl )
	local name,scale,sztab,allow,result
	name=pl:UniqueID()

	--CreateTable();
	
	if DisableScaleLoading then
		result = false
	else
		result = sql.Query("SELECT * FROM player_scales WHERE uniqueid="..name..";");
	end

	if not result then
		scale = 1
		allow = 1
	else
		for k,row in pairs(result) do
			scale = tonumber(row['scale']);
			if row['allowothers']=="1" then
				allow = 1
			else
				allow = 0
			end
		end
	end
	
	--set variables
	SendOffset(pl,scale)
	pl:SetNetworkedFloat("PlViewOffset",1);
	pl:SetNetworkedFloat("PlHullScale",1);
	pl:ConCommand("resize_allow "..allow);
	pl.Scale = scale
	pl.TargetScale = scale
	pl.ScaleSpeed = 0
	pl.EndProgress = 0;
	pl.Progress = 0
	pl.ExponentialScaling = true
	AdjustSc(pl)
end
hook.Add( "PlayerInitialSpawn", "Resizer.InitScale", SetOrgScale ); 


local SUCCESS = 1
local ERROR = 2

local function HudMSG( ply, message, type, print )    
	if( !type ) then type = SUCCESS end

	if (type == SUCCESS) then
		notify_type  = "NOTIFY_GENERIC"
		notify_sound = "ambient/water/drip" .. math.random(1, 4) .. ".wav"

	elseif (type == ERROR) then
		notify_type  = "NOTIFY_ERROR"
		notify_sound = "buttons/button10.wav"
	end

	ply:SendLua( "GAMEMODE:AddNotify( \"" .. message .. "\", " .. notify_type .. ", 5 ); surface.PlaySound( \"" .. notify_sound .. "\" )" )

	if ( print ) then
		ply:PrintMessage( HUD_PRINTCONSOLE, message )
	end
end




local divider = math.log(1.0/2.0); --for exponential scaling


function ScalePlayer(pl, scale, endprogress, exponential, sendingplayer)
	
	if !sendingplayer then
		print("console is scaling a player.")
	else
		if ( pl:EntIndex()!=sendingplayer:EntIndex() and not GetAllow(pl) ) then
			HudMSG(sendingplayer,"This player disallows external resizing",ERROR,false)
			return
		end
	end

	if scale <= 0 then
		scale = 0.00001
	end
	if not pl.Scale then pl.Scale = scale end
	pl.SourceScale = pl.Scale
	pl.TargetScale = scale
	pl.Progress = 0
	pl.EndProgress = endprogress
	pl.ExponentialScaling = exponential
	if exponential then
		pl.ScaleSpeed = math.log(pl.TargetScale / pl.Scale) / endprogress / divider;
	else
		pl.ScaleSpeed = (pl.TargetScale - pl.Scale) / endprogress;
	end
	
	SendOffset(pl,pl.SourceScale)
	
	StoreSize(pl,pl.TargetScale)
end

sql.Query("CREATE TABLE IF NOT EXISTS player_scales ( 'uniqueid' INT NOT NULL PRIMARY KEY, 'scale' DOUBLE NOT NULL, 'allowothers' BOOL NOT NULL);");

function FindPlayer(name)
	local playersFound = {}
	for k,v in pairs(player.GetAll()) do
		if v:Nick():match(name) then
 			playersFound[k] = v
		end
   	 end

	if #playersFound > 1 then
		print("Multiple players found!")
		return
	elseif #playersFound == 0 then
		print("No players found!")
		return
	else
		return playersFound[1]
	end
	
end


LobbyCommand.AddCommand("scale" , function(pl, cmd, args)
	if SERVER then
		if pl:IsPrivAdmin() == false then return end
		local size = tonumber(args[1])
		local ply = FindPlayer( args[2] )
		if size then
			ScalePlayer(ply, size, math.exp(1.1002*(10-6)), true, pl)
		end
	end
end)