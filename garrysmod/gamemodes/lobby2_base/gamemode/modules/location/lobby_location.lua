--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, 2015
	
-----------------------------------------------------------]]--

local ENT = { }

ENT.Type = "brush"
ENT.Base = "base_brush"

AccessorFunc( ENT, "m_LocationName", "Location", FORCE_STRING )

function ENT:Initialize( )

	self:SetTrigger( true )
	self:SetLocation( "Unknown" )

end

function ENT:KeyValue( key, value )
	
	if ( string.lower( key ) == "location" ) then
		self:SetLocation( value )
	end
	
end

function ENT:PassesTriggerFilters( ent )
	
	return IsValid( ent ) and ent:IsPlayer( )
	
end

function ENT:StartTouch( ent )

	if ( IsValid( ent ) and ent:IsPlayer( ) ) then
		
		ent:SetNWString( "sLocation", self:GetLocation() )
		hook.Run( "OnPlayerLocationChange", ent, self:GetLocation(), self )
		
	end

end

scripted_ents.Register( ENT, "lobby_location" )