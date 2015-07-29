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
 
function ENT:Initialize()
	
	self:SetModel( "models/props_lab/blastdoor001b.mdl" )
	self:SetTrigger( true )
	self:DrawShadow( false )
	
	self:SetSolid( SOLID_OBB )
	
	if ( self.Target ) then
	
		local Ents = ents.FindByName( self.Target )
		self:SetNWEntity( "eTarget", Ents[1] )
		
		self.TargetPortal = Ents[1]
	
	end
	
	self.InboundTravelers = { }
	
end
 
function ENT:KeyValue( key, value )

	if ( string.lower( key ) == "target" ) then
		self.Target = value
	end

end

function ENT:PlayerArriving( ply )

	self.InboundTravelers[ ply ] = true
	constraint.NoCollide( ply, self )

end

function ENT:StartTouch( ply )

	if ( not IsValid( self.TargetPortal ) ) then return end
	if ( not IsValid( ply ) or not ply:IsPlayer() ) then return end
	
	if ( self.InboundTravelers[ ply ] ) then return end
	
	local vel = ply:GetVelocity()
	vel:Rotate( self.TargetPortal:GetAngles() - self:GetAngles( ) )
	ply:SetLocalVelocity( vel )
	
	ply:SetEyeAngles( ply:EyeAngles() + self:GetAngles( ) + self.TargetPortal:GetAngles() )
	
	self.TargetPortal:PlayerArriving( ply )
	
	local offset = ply:GetPos() - self:GetPos( )
	offset:Rotate( self.TargetPortal:GetAngles() - self:GetAngles( ) )
	ply:SetPos( self.TargetPortal:GetPos( ) + offset )
	
end

function ENT:EndTouch( ply )

	self.InboundTravelers[ ply ] = false

end
