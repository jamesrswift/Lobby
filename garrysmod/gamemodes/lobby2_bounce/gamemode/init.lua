--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, 2015
	
-----------------------------------------------------------]]--

include( "shared.lua")
include( "sv_player.lua" )

AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )

function GM:PlayerSpawn( Ply )

	Ply:DrawWorldModel(true)
	
	if ( not Ply:HasBall() ) then
	
		local SpawnPoint = self:PlayerSelectSpawn(Ply)
		local BallPos = SpawnPoint:GetPos()
		BallPos.z = BallPos.z + 25
		
		-- Spawn the Ball at our new pos
		local Ball = Ply:SpawnBall( BallPos )
		
		--if (not self.GameStarted) then
		--	Ball:GetPhysicsObject():EnableMotion(false)
		--end
		
	end
	
	self.BaseClass:PlayerSpawn( Ply )
	
end
