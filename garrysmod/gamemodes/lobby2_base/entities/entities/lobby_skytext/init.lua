--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, 2015
	
-----------------------------------------------------------]]--

AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include('shared.lua')

function ENT:Initialize()
	
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetColor(255, 255, 255, 255)
	self:SetNotSolid(true)
	
	if ( self.DisplayText ) then
		
		self:SetNWString( "DisplayText", tostring( self.DisplayText ) )
	
	end
	
	if ( self.DisplaySize ) then
		
		self:SetNWFloat( "DisplaySize", tonumber( self.DisplaySize ) )
	
	end
	
	if ( self.DisplayStatic ) then
		
		self:SetNWBool( "DisplayStatic", tonumber( self.DisplayStatic ) )
	
	end
	
end

function ENT:KeyValue( key, value )

	if ( string.lower( key ) == "displaytext" ) then
		self.DisplayText = value
	elseif ( string.lower( key ) == "displaysize" ) then
		self.DisplaySize = tonumber( value )
	elseif ( string.lower( key ) == "displaystatic" ) then
		self.DisplayStatic = tobool( value )
	end
	
end