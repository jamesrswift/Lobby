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

	Ply:DrawWorldModel(false)
	
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

function GM:Think( )

	for k, Pl in pairs( player.GetAll() ) do
	
		local ball = Pl:GetBall( )
		
		if ( ball ) then
		
			--Pl:SetPos( ball:GetPos() )
			
			if ( IsValid( ball.Player ) ) then
			
				ball.Player:SetPos( ball:GetPos() )
				ball.Player:SetAngles( Angle( 0, 0, 0 ) )
			
			end
		end
		
	end
	
	self.BaseClass:Think( )

end