--[[-----------------------------------------------------------
	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝
	
	Copyright (c) James Swift, 2015
	
-----------------------------------------------------------]]--

ENT.Type 			= "anim"
ENT.Base 			= "base_gmodentity"
 
ENT.PrintName		= "lobby_entity"
ENT.Author			= "James Swift"
ENT.Contact			= "Don't"
ENT.Purpose			= "Exemplar material"
ENT.Instructions	= "Use with care. Always handle with gloves."

ENT.Item 			= "none"

DEFINE_BASECLASS( ENT.Base )


function ENT:GetOwner( )

	return self:GetNWEntity( "owner", NULL )
	
end

function ENT:CanPickup( Pl )

	return self:GetOwner() == Pl or Pl:IsAdmin()

end

function ENT:CanMove( Pl )

	return self:CanPickup( Pl )

end