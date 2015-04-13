local PANEL = {}
AccessorFunc( PANEL, "iSlotID", "SlotID", FORCE_NUMBER )

AccessorFunc( PANEL, "m_fAnimSpeed",	"AnimSpeed" )
AccessorFunc( PANEL, "Entity",			"Entity" )
AccessorFunc( PANEL, "vCamPos",			"CamPos" )
AccessorFunc( PANEL, "fFOV",			"FOV" )
AccessorFunc( PANEL, "vLookatPos",		"LookAt" )
AccessorFunc( PANEL, "aLookAngle",		"LookAng" )
AccessorFunc( PANEL, "colAmbientLight",	"AmbientLight" )
AccessorFunc( PANEL, "colColor",		"Color" )
AccessorFunc( PANEL, "bAnimated",		"Animated" )

AccessorFunc( PANEL, "m_Dragging", "Dragging", FORCE_BOOL )
AccessorFunc( PANEL, "m_DragOffset", "DragOffset" )

function PANEL:Init()
	self.Entity = nil
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
end

function PANEL:SetDirectionalLight( iDirection, color )
	self.DirectionalLight[ iDirection ] = color
end

function PANEL:Paint( w, h )
	surface.SetDrawColor(Color(0,0,0,100))
	surface.DrawRect( 0, 0, w, h)
	
	surface.DrawRect( 1, 2, 1, h-2)
	surface.DrawRect( 1, 1, w, 1)
	surface.DrawRect( w-2, 1, 1, h-2)
	surface.DrawRect( 1, h-2, w-2, 1)
	
	if self.Item then
		if (self.Entity) then
			if !IsValid(self.Entity) then return end
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

			render.SuppressEngineLighting( false )
			cam.IgnoreZ( false )
			cam.End3D()

			self.LastPaint = RealTime()
		elseif self.Material then
		
		
		
		elseif self.GetColor then
		
		
		
		elseif self.Color then
			
		end
	
		self:DrawTag( )
	end
end

function PANEL:Remove()
	if ( IsValid( self.Entity ) ) then
		self.Entity:Remove()
	end
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

function PANEL:GetModel()

	if ( !IsValid( self.Entity ) ) then return end

	return self.Entity:GetModel()

end

function PANEL:DrawModel()
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
	render.SetScissorRect( leftx+2, topy+2, rightx-2, bottomy-2, true )
	self.Entity:DrawModel()
	render.SetScissorRect( 0, 0, 0, 0, false )
end

function PANEL:RunAnimation()
	self.Entity:FrameAdvance( ( RealTime() - self.LastPaint ) * self.m_fAnimSpeed )
end

function PANEL:StartScene( name )

	if ( IsValid( self.Scene ) ) then
		self.Scene:Remove()
	end

	self.Scene = ClientsideScene( name, self.Entity )

end

function PANEL:LayoutEntity( Entity )

	if ( self.bAnimated ) then
		self:RunAnimation()
	end

	Entity:SetAngles( Angle( 0, RealTime() * 10, 0 ) )

end


function PANEL:OnRemove()
	if ( IsValid( self.Entity ) ) then
		self.Entity:Remove()
	end
end

function PANEL:UpdateContents()

	-- remove previous settings

	self.PrintName = false
	if (IsValid( self.Entity) ) then self.Entity:Remove() end
	self.Material = false
	self.GetColor = false
	self.Color = false
	
	-- set new settings
	
	local item = LocalPlayer():GetItem( self:GetSlotID() )
	
	if item then
		self.Item = item
		local itemmeta = item[3]
		
		self.PrintName = itemmeta.Name
		
		if (itemmeta.Model) then self:SetModel(itemmeta.Model)
		elseif (itemmeta.Material) then self.Material = itemmeta.Material
		elseif (itemmeta.GetColor) then self.GetColor = itemmeta.GetColor
		elseif (itemmeta.Color) then self.Color = itemmeta.Color end
	end
end

function PANEL:DrawTag( )
	surface.SetDrawColor(Color(0,0,0,100))
	surface.DrawRect(2, self:GetTall() - 30, self:GetWide()-4, 20)
	draw.SimpleText(self.PrintName, "DefaultSmall", self:GetWide() / 2, self:GetTall() - 20, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	
end

function PANEL:OnMousePressed(mc)
	self.m_DragOffset = {0,0}
	if (mc == MOUSE_LEFT) then
		self:StartDragging()
	end
end

function PANEL:OnMouseReleased()
	local ox,oy = self:GetDragOffset()[1] or 0, self:GetDragOffset()[2] or 0
	local mx,my = self:GetParent():ScreenToLocal(gui.MousePos())
	self:SetPos(mx-ox,my-oy)       
	self:StopDragging(mx-ox,my-oy)
end
 
function PANEL:Think()
	if self.m_Dragging then
		local ox,oy = self:GetDragOffset()[1], self:GetDragOffset()[2]
		local mx,my =  self:GetParent():ScreenToLocal(gui.MousePos())
		self:SetPos(mx-ox,my-oy)
	end
end
 
function PANEL:StartDragging(t)
	self.m_Dragging = true
	self:MouseCapture(true)
	self:MoveToFront()
	local mx,my = self:ScreenToLocal(gui.MousePos())
	self:SetDragOffset({mx,my})
end

local function WithinBounds( x , y, a , b , w , t )
	return (x>a) and (y>b) and (x<a+w) and (y<b+t)
end
 
function PANEL:StopDragging(x,y) -- global X,Y
    self.m_Dragging = false
    self:MouseCapture(false)
	
	local parent = self:GetParent():GetParent()
	
	x,y = self:LocalToScreen( self:GetPos() )
	local centerx = x + self:GetWide() / 2
	local centery = y + self:GetTall() / 2
	
	--find closest planel
	for slot,v in pairs( parent.Grid.Items ) do -- All other iventory_items
		if v == self then continue end
		local globalposx, globalposy =v:LocalToScreen( v:GetPos() )
		local wide, tall = v:GetWide(), v:GetTall()
		if WithinBounds( centerx, centery, globalposx, globalposy, wide, tall ) then
			parent:SwitchItemSlots( self:GetSlotID(), slot )
			return
		end
	end

end

vgui.Register( "lobby.InventoryItem", PANEL, "Panel" )