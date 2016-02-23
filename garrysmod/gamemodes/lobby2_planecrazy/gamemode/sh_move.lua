--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, 2015
	
-----------------------------------------------------------]]--

function GM:DoExplosion( pl )

	if ( !IsValid( pl ) ) then return end
	
	util.BlastDamage( pl, pl, pl:GetPos(), 300, 200 )
		
	local effectdata = EffectData()
		effectdata:SetOrigin( pl:GetPos() )
 	util.Effect( "Explosion", effectdata, true, true )

end

function GM:Move( pl, mv )

	if ( !pl:Alive() ) then return end
	if ( pl:Team() == TEAM_SPECTATOR ) then return end
	--if ( !pl:GetNWFloat( "Speed", false ) ) then return end
	
	local vel = pl:GetNWFloat( "Speed", 100 )
	local accel = 30.0
	
	local Dot = pl:GetAimVector():Dot( Vector( 0, 0, -1 ) )
	
	-- Boost, todo, make temporary
	if ( pl:KeyDown( IN_JUMP ) ) then
		Dot = Dot + 5.0
	end
	
	vel = math.Clamp( vel + Dot * FrameTime() * accel, 0, 1000 )
	
	if ( vel > 200 && !pl:KeyDown( IN_JUMP ) ) then
		vel = vel - ( FrameTime() * 120 )
	end
	
	pl:SetNWFloat( "Speed", vel )

	local Velocity = pl:GetAimVector() * vel * 5
	
	local Target = pl:GetPos() + Velocity * FrameTime()

	
	--debugoverlay.Line( pl:GetPos(), Target, 10 )
	
	local trace = { start = pl:GetPos(), endpos = Target, filter = pl }	  
	local tr = util.TraceLine( trace )
	
	if ( tr.Hit ) then
		
		pl:SetPos( tr.HitPos + tr.HitNormal * 50 )
		mv:SetVelocity( Vector(0,0,0) )
		
		if ( SERVER ) then
			timer.Simple( 0, function() GAMEMODE:DoExplosion( pl ) end )
			pl:Kill()
		end
	
	else
	
		mv:SetVelocity( Velocity )
		mv:SetOrigin( Target )
	
	end	
	
	return true

end

if CLIENT then

	function GM:InputMouseApply( cmd, x, y, angle )

		local ply = LocalPlayer( )
		
		angle.roll = math.Approach( angle.roll, 0, angle.roll / 400 )
		angle.yaw = angle.yaw + angle.roll * -0.0025
		
		local Ang = Matrix({
			{1, 1, 1, 0},
			{1, 1, 1, 0},
			{1, 1, 1, 0},
			{0, 0, 0, 0}
		})
		
		Ang:SetAngles( angle )
		
		local speed = ply:GetNWFloat( "Speed", 0 )

		local pitchchange = y * 0.02
		local yawchange = x * -0.005
		local rollchange = x * 0.022
		
		local stalling = 50 - speed
		if ( speed < 50 ) then 
			local rate = 1 - (speed / 50)
			pitchchange = pitchchange + (rate ^ 10.0) * 20
		end
		
		Ang:Rotate( Angle( pitchchange, yawchange, rollchange ) )
		
		local Ang = Ang:GetAngles()
		Ang.roll = math.Clamp( Ang.roll, -90, 90 )
		
		cmd:SetViewAngles( Ang )
		return true

	end

end