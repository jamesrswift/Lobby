--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, 2015
	
-----------------------------------------------------------]]--

include( "shared.lua" )

function GM:GetMotionBlurValues( x, y, fwd, spin )

	local EyeAngles = LocalPlayer():EyeAngles()
	
	local Velocity = LocalPlayer():GetVelocity()
	fwd = ( Velocity:Dot( EyeAngles:Forward() ) - 100 ) / 20000
	
	fwd = math.Clamp( fwd, 0, 1 )
	
	y = ( Velocity:Dot( EyeAngles:Up() ) ) / 20000
	
	return x, y, fwd, spin
	
end

function GM:CalcView( ply, origin, angles, fov )
	
	if ( !ply:Alive() ) then return end
	
	local DistanceAngle = angles:Forward() * - 0.8 + angles:Up() * 0.2
	
	local ret = {}
	ret.origin = origin + DistanceAngle * 75
	
	if ( ply:KeyDown( IN_JUMP ) ) then
		local factor = 1
		ret.angles = angles + Angle( math.random( factor * -1, factor ), math.random( factor * -1, factor ), math.random( factor * -1, factor ) ) 
	end
	--ret.angles 		= angles
	--ret.fov 		= fov
	return ret

end

function GM:ShouldDrawLocalPlayer( pl )

	--return false
	
end

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