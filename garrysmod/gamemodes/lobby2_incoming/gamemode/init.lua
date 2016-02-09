--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, Chewgum, 2015
	
-----------------------------------------------------------]]--

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("sh_config.lua")
AddCSLuaFile("cl_hud.lua")
--AddCSLuaFile("cl_deathnotice.lua")

include("shared.lua")
include("sh_round.lua")
include("sh_config.lua")
include("sv_player.lua")


GM.HasWon = false
GM.PropSpawnTimer = 0

function GM:Tick()

	if ( self.HasWon )then return end
	
	if ( #player.GetAll() >= 1 ) then
	
		if ( self.PropSpawnTimer < CurTime() ) then
		
			for k, v in pairs( ents.FindByClass( "inc_prop_spawner" ) ) do
			
				self:SpawnProp( self.Maps[ game.GetMap() ].FallingProps, v:GetPos() )
				
			end
			
			self.PropSpawnTimer = CurTime() + self.Maps[ game.GetMap() ].PropSpawnDelay
			
		end
		
	end
	
	for k,ply in pairs( team.GetPlayers( 2 ) ) do
	
		if ( ply.Spectating and IsValid( ply.Spectating ) and not ply.Spectating:Alive( ) ) then
		
			ply.Spectating = team.GetPlayers( 1 )[ math.random( 1, #team.GetPlayers(1) ) ];
			ply:SpectateEntity( ply.Spectating )
		
		end
	
	end
	
end

function GM:SpawnProp( Props, Pos )

	local Ent = ents.Create( "prop_physics" )
	Ent:SetModel( Props[ math.random( 1, #Props ) ] )
	Ent:SetPos( Pos )
	Ent:Spawn()
	
	local phys = Ent:GetPhysicsObject( )
	if ( phys and IsValid( phys ) ) then
		phys:SetMass( 40000 )
		phys:AddAngleVelocity( Vector( math.random( -100, 100 ), math.random( -100, 100 ), math.random( -100, 100 ) ):GetNormalized() * math.random( 0, 25 ) )
	end

end

function GM:Think()

	self:RoundThink()
	
end


function GM:PlayerInitialSpawn( ply )

	self.BaseClass:PlayerInitialSpawn( ply )
	ply:SetTeam( 2 )
	
end

function GM:PlayerSpawn( ply )

	self.BaseClass:PlayerSpawn( ply )
	
	if ( ply:Team() == 2 ) then
	
		ply:CrosshairDisable()
		ply:Spectate( OBS_MODE_CHASE )
		--ply:SetMoveType( MOVETYPE_NOCLIP )
		
		-- Player spectate, TODO
		
		local AlivePlayers = team.GetPlayers(1)
		
		if ( #AlivePlayers >= 1 ) then
		
			ply.Spectating = AlivePlayers[ math.random( 1, #AlivePlayers ) ];
			ply:SpectateEntity( ply.Spectating )
			
		end
		
		
	elseif ( ply:Team() == 1 ) then
	
		ply:CrosshairEnable()
		ply:SetMoveType( MOVETYPE_WALK )
		ply:SetCollisionGroup( COLLISION_GROUP_WEAPON )
		ply:UnSpectate()
		
	end
	
	if ( ply.DeathDoll and ply.DeathDoll != NULL ) then
		ply.DeathDoll:Remove()
	end
	
end