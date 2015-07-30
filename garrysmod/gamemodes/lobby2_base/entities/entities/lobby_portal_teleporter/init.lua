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
		
		local NewAngles = self.Portal:GetAngles( ) + ply:EyeAngles() - TargetPortal:GetAngles()
		ply:SetEyeAngles( NewAngles )
		
		TargetPortal.Teleporter.InBoundTravelers[ ply ] = true
		
		local offset = Vector( self.Portal:GetPos( ).x - ply:GetPos( ).x, self.Portal:GetPos( ).y - ply:GetPos( ).y, 0 )
		offset:Rotate( TargetPortal:GetAngles() - self.Portal:GetAngles( ) )
		ply:SetPos( TargetPortal:GetPos( ) + offset + Vector( 0, 0, ply:GetPos( ).z- self.Portal:GetPos( ).z ) )
		
		local velocity = ply:GetVelocity( )
		ply:SetVelocity( NewAngles:Forward() * velocity:Length() -velocity ) -- Cancel stuff out
	
	end
	
end

function ENT:EndTouch( ply )

	if ( IsValid( ply ) and ply:IsPlayer( ) and self.Portal and IsValid( self.Portal ) ) then
	
		self.InBoundTravelers[ ply ] = false
	
	end
	
end
