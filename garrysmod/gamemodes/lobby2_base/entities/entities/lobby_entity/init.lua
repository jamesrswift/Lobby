--[[-----------------------------------------------------------
	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝
	
	Copyright (c) James Swift, 2015
	
-----------------------------------------------------------]]--

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
 
include('shared.lua')

function ENT:Initialize()
	
	
	

end

function ENT:SetOwner( Pl )

	if ( IsValid(Pl) and Pl:IsPlayer() ) then
	
		self:SetNWEntity( "owner", Pl )
		
	end
	
end

function ENT:Pickup( Pl )

	if ( self:CanPickup( Pl ) ) then

		Pl:GiveItem( self.Item )
		self:Remove( )
		
	end

end