local PANEL = {}
AccessorFunc( PANEL, "HatEntity",			"HatEntity" )
AccessorFunc( PANEL, "OffsetVector",			"OffsetVector" )
AccessorFunc( PANEL, "OffsetAngle",			"OffsetAngle" )
AccessorFunc( PANEL, "BoneID",			"BoneID" )

function PANEL:Init()
	self:SetOffsetAngle( Angle(0,0,0))
	self:SetOffsetVector( Vector(0,0,0) )
	self:SetBoneID( 6 )
	self:SetHatScale( 1 )
	
	self.Entity = nil
	self.HatEntity = nil
	self.LastPaint = 0
	self.DirectionalLight = {}
	self.FarZ = 4096

	self:SetCamPos( Vector( 50, 50, 50 ) )
	self:SetLookAt( Vector( 0, 0, 40 ) )
	self:SetFOV( 70 )

	self:SetText( "" )
	self:SetAnimSpeed( 0.5 )
	self:SetAnimated( false )

	self:SetAmbientLight( Color( 50, 50, 50 ) )

	self:SetDirectionalLight( BOX_TOP, Color( 255, 255, 255 ) )
	self:SetDirectionalLight( BOX_FRONT, Color( 255, 255, 255 ) )

	self:SetColor( Color( 255, 255, 255, 255 ) )

	self.mx = 0
	self.my = 0
end

function PANEL:SetHatModel( strModelName )

	-- Note - there's no real need to delete the old 
	-- entity, it will get garbage collected, but this is nicer.
	if ( IsValid( self.HatEntity ) ) then
		self.HatEntity:Remove()
		self.HatEntity = nil
	end

	-- Note: Not in menu dll
	if ( !ClientsideModel ) then return end

	self.HatEntity = ClientsideModel( strModelName, RENDER_GROUP_OPAQUE_ENTITY )
	if ( !IsValid( self.HatEntity ) ) then return end

	self.HatEntity:SetNoDraw( true )

end

function PANEL:SetModel( strModelName )

	-- Note - there's no real need to delete the old 
	-- entity, it will get garbage collected, but this is nicer.
	if ( IsValid( self.Entity ) ) then
		self.Entity:Remove()
		self.Entity = nil
	end

	-- Note: Not in menu dll
	if ( !ClientsideModel ) then return end

	self.Entity = ClientsideModel( strModelName, RENDER_GROUP_OPAQUE_ENTITY )
	if ( !IsValid( self.Entity ) ) then return end

	self.Entity:SetNoDraw( true )

	-- Try to find a nice sequence to play
	local iSeq = self.Entity:LookupSequence( "walk_all" )
	if ( iSeq <= 0 ) then iSeq = self.Entity:LookupSequence( "WalkUnarmed_all" ) end
	if ( iSeq <= 0 ) then iSeq = self.Entity:LookupSequence( "walk_all_moderate" ) end

	if ( iSeq > 0 ) then self.Entity:ResetSequence( iSeq ) end
	
	local bone = self.Entity:LookupBone("ValveBiped.Bip01_Head1")
	self.Entity:SetEyeTarget(Vector(20, 00, 65)) -- otherwise the model will have its eyes pointing down
	if bone then
		self:SetLookAt(self.Entity:GetBonePosition(bone)) -- look at the head of the model
		self:SetCamPos(Vector(30, 10, 75))
	else
		local PrevMins, PrevMaxs = self.Entity:GetRenderBounds()
		self:SetCamPos(PrevMins:Distance(PrevMaxs) * Vector(0.5, 0.5, 1))
		self:SetLookAt((PrevMaxs + PrevMins) / 2)
	end

end

function PANEL:Paint()

	if ( !IsValid( self.Entity ) ) then return end
	if ( !IsValid( self.HatEntity ) ) then return end

	local x, y = self:LocalToScreen( 0, 0 )

	self:LayoutEntity( self.Entity )

	local ang = self.aLookAngle
	if ( !ang ) then
		ang = (self.vLookatPos-self.vCamPos):Angle()
	end

	local w, h = self:GetSize()
	cam.Start3D( self.vCamPos, ang, self.fFOV, x, y, w, h, 5, self.FarZ )
	cam.IgnoreZ( true )

	render.SuppressEngineLighting( true )
	render.SetLightingOrigin( self.Entity:GetPos() )
	render.ResetModelLighting( self.colAmbientLight.r/255, self.colAmbientLight.g/255, self.colAmbientLight.b/255 )
	render.SetColorModulation( self.colColor.r/255, self.colColor.g/255, self.colColor.b/255 )
	render.SetBlend( self.colColor.a/255 )

	for i=0, 6 do
		local col = self.DirectionalLight[ i ]
		if ( col ) then
			render.SetModelLighting( i, col.r/255, col.g/255, col.b/255 )
		end
	end

	self:DrawModel()
	self:DrawHat()

	render.SuppressEngineLighting( false )
	cam.IgnoreZ( false )
	cam.End3D()

	self.LastPaint = RealTime()

end

function PANEL:LayoutEntity( Entity )

	if ( self.bAnimated ) then
		self:RunAnimation()
	end

	Entity:SetAngles( Angle( 0, RealTime() * 10, 0 ) )
	
	local pos, ang = self:CalculateOffset( self.Entity:GetBonePosition( self.BoneID ) )
	self.HatEntity:SetPos( pos )
	self.HatEntity:SetAngles( ang )
	self.HatEntity:SetModelScale( self:GetHatScale(), 0 )

end

function PANEL:GetHatModel()

	if ( !IsValid( self.HatEntity ) ) then return end

	return self.HatEntity:GetModel()

end

function PANEL:DrawHat()
	local curparent = self
	local rightx = self:GetWide()
	local leftx = 0
	local topy = 0
	local bottomy = self:GetTall()
	local previous = curparent
	while( curparent:GetParent() != nil ) do
		curparent = curparent:GetParent()
		local x, y = previous:GetPos()
		topy = math.Max( y, topy + y )
		leftx = math.Max( x, leftx + x )
		bottomy = math.Min( y + previous:GetTall(), bottomy + y )
		rightx = math.Min( x + previous:GetWide(), rightx + x )
		previous = curparent
	end
	render.SetScissorRect( leftx, topy, rightx, bottomy, true )
	self.HatEntity:DrawModel()
	render.SetScissorRect( 0, 0, 0, 0, false )
end

function PANEL:CalculateOffset( pos, ang )

	local Voffset = Vector( self.OffsetVector.x, self.OffsetVector.y, self.OffsetVector.z) * self.Entity:GetModelScale();
	
	Voffset:Rotate( ang )
	
	ang:RotateAroundAxis(ang:Right(), 	self.OffsetAngle.r); --Rotate around the axis (to the right) -90 degree's
	ang:RotateAroundAxis(ang:Up(), 		self.OffsetAngle.p); --Rotate around the axis (upwards) 90
	ang:RotateAroundAxis(ang:Forward(), self.OffsetAngle.y);
	pos = pos + Voffset

	return pos, ang
end

function PANEL:OnRemove()
	if ( IsValid( self.Entity ) ) then
		self.Entity:Remove()
	end
	if ( IsValid( self.HatEntity ) ) then
		self.HatEntity:Remove()
	end
end

function PANEL:SetHatScale( fScale )
	self.HatScale = fScale
end

function PANEL:GetHatScale() return self.HatScale end

function PANEL:Output( )
	local ret = "[\"".. self:GetModel() .."\"] = {"
	ret = ret .. "Vector = Vector("..self.OffsetVector.x..","..self.OffsetVector.y ..",".. self.OffsetVector.z.."),"
	ret = ret .. "Angle = Angle("..self.OffsetAngle.p..","..self.OffsetAngle.y ..",".. self.OffsetAngle.r .."),"
	ret = ret .. "Scale = " .. self:GetHatScale() .. "}"
	return ret
end

vgui.Register( "lobby.HatEditor.ModelViewer", PANEL, "DAdjustableModelPanel" )