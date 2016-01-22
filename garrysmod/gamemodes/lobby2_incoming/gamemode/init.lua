--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, 2015
	
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

local Delay = GM.Maps[ game.GetMap() ].PropSpawnDelay
local Props = GM.Maps[ game.GetMap() ].FallingProps

function GM:Tick()

	if ( self.HasWon )then return end
	
	if ( #player.GetAll() >= 1 ) then
	
		if ( self.PropSpawnTimer < CurTime() ) then
		
			for k, v in pairs( ents.FindByClass( "inc_prop_spawner" ) ) do
			
				self.PropSpawnTimer = CurTime() + Delay
				local Ent = ents.Create( "prop_physics" )
				Ent:SetModel( Props[ math.random( 1, #Props ) ] )
				Ent:SetPos( v:GetPos() )
				Ent:Spawn()
				Ent:GetPhysicsObject():SetMass( 40000 )
				
			end
			
		end
		
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
		ply:SetMoveType( MOVETYPE_NOCLIP )
		
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