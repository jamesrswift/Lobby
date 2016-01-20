--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, 2015
	
-----------------------------------------------------------]]--

GM.Inventory = GM.Inventory or { }
GM.Inventory.Ghost = GM.Inventory.Ghost or { }
GM.Inventory.Ghost.Offset = GM.Inventory.Ghost.Offset or Angle( 0, 0, 90 )

function GM.Inventory.Ghost:Move( )

	if ( input.WasMousePressed( MOUSE_WHEEL_UP ) ) then
		self.Offset = self.Offset + Angle( 0, 15, 0 )
	elseif ( input.WasMousePressed( MOUSE_WHEEL_DOWN ) ) then
		self.Offset = self.Offset - Angle( 0, 15, 0 )
	end

end

function GM.Inventory.Ghost:MakeGhostEntity( model )

	util.PrecacheModel( model )
	self:ReleaseGhostEntity()

	--if ( not util.IsValidProp( model ) ) then return end
	
	self.GhostEntity = ents.CreateClientProp( model )
	
	-- If there's too many entities we might not spawn..
	if (!self.GhostEntity:IsValid()) then
		self.GhostEntity = nil
		print( "not valid entity" )
		return
	end
	
	self.GhostEntity:SetModel( model )
	self.GhostEntity:SetPos( Vector(0,0,0) )
	self.GhostEntity:SetAngles( Angle(0,0,0) )
	self.GhostEntity:Spawn()
	
	self.GhostEntity:SetSolid( SOLID_VPHYSICS );
	self.GhostEntity:SetMoveType( MOVETYPE_NONE )
	self.GhostEntity:SetNotSolid( true );
	self.GhostEntity:SetRenderMode( RENDERMODE_TRANSALPHA )
	self.GhostEntity:PhysicsInit( SOLID_VPHYSICS )
	self.GhostEntity:SetColor( Color( 255, 255, 255, 150 ) )
	
end

function GM.Inventory.Ghost:ReleaseGhostEntity()
	
	if ( self.GhostEntity ) then
		--if ( not self.GhostEntity:IsValid() ) then self.GhostEntity = nil return end
		self.GhostEntity:Remove()
		self.GhostEntity = nil
	end
	
end

function GM.Inventory.Ghost:UpdateGhostEntity()

	if ( self.GhostEntity == nil ) then return end
	if ( not self.GhostEntity:IsValid() ) then self:ReleaseGhostEntity() return end
	
	local vStart = LocalPlayer():GetShootPos()
	local vForward = LocalPlayer():GetAimVector()

	local trace = {}
	trace.start = vStart
	trace.endpos = vStart + (vForward * 2048)
	trace.filter = LocalPlayer()

	local tr = util.TraceLine( trace )

	local ang = tr.HitNormal:Angle()
	ang:RotateAroundAxis( tr.HitNormal, self.Offset.y )
	
	self.GhostEntity:SetAngles( ang )
	self.GhostEntity:SetPos( tr.HitPos )
	
	local vFlushPoint = tr.HitPos - ( tr.HitNormal * 512 )
	vFlushPoint = self.GhostEntity:NearestPoint( vFlushPoint )
	vFlushPoint = self.GhostEntity:GetPos() - vFlushPoint
	vFlushPoint = tr.HitPos + vFlushPoint
	
	self.GhostEntity:SetPos( vFlushPoint )
	
	if ( self:CheckPenetration() ) then
		self.GhostEntity:SetColor( Color( 255, 100, 100, 255 ) )
	else
		self.GhostEntity:SetColor( Color( 200, 255, 100, 255 ) )
	end
	
end

function GM.Inventory.Ghost:CheckPenetration( )

	if ( not self.GhostEntity ) then return end
	if ( not self.GhostEntity:IsValid() ) then self.GhostEntity = nil return end
	
	local mins, maxs = self.GhostEntity:OBBMins(), self.GhostEntity:OBBMaxs()
	
	local checks = {
		{ Vector( mins.x, mins.y, mins.z ) , Vector( maxs.x, mins.y, mins.z) },
		{ Vector( mins.x, mins.y, mins.z ) , Vector( mins.x, maxs.y, mins.z) },
		{ Vector( mins.x, mins.y, mins.z ) , Vector( mins.x, mins.y, maxs.z) },
	
		{ Vector( maxs.x, maxs.y, maxs.z ) , Vector( mins.x, maxs.y, maxs.z) },
		{ Vector( maxs.x, maxs.y, maxs.z ) , Vector( maxs.x, mins.y, maxs.z) },
		{ Vector( maxs.x, maxs.y, maxs.z ) , Vector( maxs.x, maxs.y, mins.z) },
		
		{ Vector( maxs.x, mins.y, mins.z ) , Vector( maxs.x, maxs.y, mins.z) },
		{ Vector( mins.x, mins.y, maxs.z ) , Vector( mins.x, maxs.y, maxs.z) },
		
		{ Vector( mins.x, maxs.y, mins.z ) , Vector( mins.x, maxs.y, maxs.z) },
		{ Vector( mins.x, maxs.y, mins.z ) , Vector( maxs.x, maxs.y, mins.z) },
		
		{ Vector( mins.x, mins.y, maxs.z ) , Vector( maxs.x, mins.y, maxs.z) },
		{ Vector( maxs.x, mins.y, mins.z ) , Vector( maxs.x, mins.y, maxs.z) },
	}
	
	for k, v in pairs( checks ) do
	
		v[1]:Rotate( self.GhostEntity:GetAngles() )
		v[2]:Rotate( self.GhostEntity:GetAngles() )
		
		if ( bit.band( util.PointContents( v[1] ), CONTENTS_SOLID ) == CONTENTS_SOLID ) then return true end
		
		local trace = {}
		trace.start = self.GhostEntity:GetPos() + v[1]
		trace.endpos = self.GhostEntity:GetPos() + v[2]
		--trace.filter = {"worldspawn"}

		local tr = util.TraceLine( trace )
		
		debugoverlay.Line( self.GhostEntity:GetPos() + v[1], self.GhostEntity:GetPos() + v[2], 0.05, Color(255, 0, 0), true )
		
		if ( tr.Hit ) then
			return true
		end
	
	end
	
	return false
	
end
