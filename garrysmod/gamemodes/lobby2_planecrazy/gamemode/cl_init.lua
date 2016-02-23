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
include( "sh_move.lua")

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
