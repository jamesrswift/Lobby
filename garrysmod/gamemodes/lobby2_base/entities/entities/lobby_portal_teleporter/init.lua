--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, 2015
	
-----------------------------------------------------------]]--

ENT.Type = "brush"
ENT.Base = "base_brush"

AccessorFunc( ENT, "m_LocationName", "Location", FORCE_STRING )

function ENT:Initialize( )

	self:SetTrigger( true )
	
	if ( self.PortalName ) then
	
		local Ents = ents.FindByName( self.PortalName )
		if ( Ents[1] and IsValid( Ents[1] ) ) then
			self.Portal = Ents[1]
			self.Portal.Teleporter = self
		end
	
	end
	
	self.InBoundTravelers = { }

end

function ENT:KeyValue( key, value )
	
	if ( string.lower( key ) == "portal" ) then
		self.PortalName = value
	end
	
end

function ENT:PassesTriggerFilters( ent )
	
	return IsValid( ent ) and ent:IsPlayer( )
	
end

function ENT:StartTouch( ply )

	if ( IsValid( ply ) and ply:IsPlayer( ) and self.Portal and IsValid( self.Portal ) ) then
	
		if ( self.InBoundTravelers[ ply ] ) then return end
		
		local TargetPortal = self.Portal:GetTarget( )
		
		ply:SetEyeAngles( self.Portal:GetAngles( ) + ply:EyeAngles() - TargetPortal:GetAngles() )
		
		TargetPortal.Teleporter.InBoundTravelers[ ply ] = true
		
		local offset = self.Portal:GetPos( ) - ply:GetPos( )
		offset:Rotate( TargetPortal:GetAngles() - self.Portal:GetAngles( ) )
		ply:SetPos( TargetPortal:GetPos( ) + offset )
		
		local vel = ply:GetVelocity( )
		vel:Rotate( self.Portal:GetAngles( ) - TargetPortal:GetAngles() )
		
		local phys = ply:GetPhysicsObject( )
		if ( IsValid( phys ) ) then
			phys:SetVelocityInstantaneous( vel )
		end
	
	end
	
end

function ENT:EndTouch( ply )

	if ( IsValid( ply ) and ply:IsPlayer( ) and self.Portal and IsValid( self.Portal ) ) then
	
		self.InBoundTravelers[ ply ] = false
	
	end
	
end
