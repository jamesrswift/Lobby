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
include( "sv_plane.lua")
include( "sh_move.lua")

AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "sh_move.lua")

function GM:PlayerLoadout( pl )

	pl:Give( "weapon_planegun" )
	pl:DrawViewModel( false )
	
	
end

function GM:PlayerSpawn( pl )

	self.BaseClass:PlayerSpawn( pl )
	
	pl.m_entTrail = util.SpriteTrail( pl, 0, Color( 180, 180, 190, 255 ), true, 0, 16, 10, 0.01, "trails/smoke.vmt" )
	pl.m_entTrail:SetParent( pl )
	
	pl:SetHull( Vector( -16, -16, -16 ), Vector( 16, 16, 16 ) )
	pl:SetViewOffset( Vector( 0, 0, 0 ) )
	pl:SetMoveType( MOVETYPE_NOCLIP )
	pl:SetNWFloat( "Speed", 100 )
	
	pl:SetPos( pl:GetPos() + Vector( 0, 0, 100 ) )
	pl:SetModel( "models/props_c17/doll01.mdl" )
	
	-- Add Plane Parts
	self:BuildPlane( pl )

end

function GM:PlayerDeath( pl, inflictor, attacker )

	if ( IsValid( pl.m_entTrail ) ) then
		pl.m_entTrail:SetAttachment( nil )
		local trail = pl.m_entTrail
		timer.Simple( 30, function() if ( IsValid( trail ) ) then trail:Remove() end end )
	end
	
	self:ExplodePlaneParts( pl )

	if ( attacker and IsValid( attacker ) and attacker:IsPlayer() and attacker ~= pl ) then
	
		attacker:GiveMoney( 50 )
	
	end
	
end