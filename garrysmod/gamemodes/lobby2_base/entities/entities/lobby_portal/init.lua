--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, 2015
	
-----------------------------------------------------------]]--

AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')

util.AddNetworkString( "lobby_portal_request_info" )

function ENT:Initialize()
	
	self:SetModel( "models/props_lab/blastdoor001b.mdl" )
	self:DrawShadow( false )
	
	if ( self.Target ) then
	
		local Ents = ents.FindByName( self.Target )
		
		self:SetNWEntity( "eTarget", Ents[1] )
		
		self.TargetPortal = Ents[1]
	
	end
	
end

function ENT:GetTarget( )

	return self.TargetPortal
	
end
 
function ENT:KeyValue( key, value )

	if ( string.lower( key ) == "target" ) then
		self.Target = value
	end

end

net.Receive( "lobby_portal_request_info", function( len, ply )

	local Ent = net.ReadEntity( )

	net.Start( "lobby_portal_request_info" )
		net.WriteEntity( Ent )
		net.WriteEntity( Ent.TargetPortal )
	net.Send( ply )

end)
