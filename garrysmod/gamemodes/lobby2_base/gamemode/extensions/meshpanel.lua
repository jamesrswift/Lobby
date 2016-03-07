--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, 2015
	
-----------------------------------------------------------]]--

MeshPanel = MeshPanel or { }
MeshPanel.Panels = MeshPanel.Panels or { }
MeshPanel.Meta = MeshPanel.Meta or { }

function MeshPanel.New( Pos, Angle, Scale, name )
	
	local UniqueName = "_MESHPANEL_" .. name
	
	local obj = { }
	setmetatable( obj, {__index = MeshPanel.Meta} )
	
	obj:SetPos( Pos )
	obj:SetAngles( Angle )
	obj:SetScale( Scale )
	
	obj:SetWidth( 0 )
	obj:SetHeight( 0 )
	
	obj:SetName( UniqueName )
	obj:SetNormal( obj:CalculateNormal( ) )
	obj:SetMaxDistance( 300 )
	
	obj:SetAutomaticRender( true )
	obj:SetEnableCursor( false )
	obj:SetUpdate(function() end)

	-- For rendering automatically
	MeshPanel.Panels[ UniqueName ] = obj
	
	return obj
	
end

function MeshPanel.RenderPanels( )
	
	for name, obj in pairs( MeshPanel.Panels ) do
		
		if ( obj:GetAutomaticRender() ) then
			
			obj:Draw( )
			
		end
	end
	
end

hook.Add( "PostDrawOpaqueRenderables", "meshpanel:draw", MeshPanel.RenderPanels )

-- Meta

AccessorFunc( MeshPanel.Meta, "m_Position", "Pos" )
AccessorFunc( MeshPanel.Meta, "m_Angle", "Angles" )
AccessorFunc( MeshPanel.Meta, "m_Scale", "Scale", FORCE_NUMBER )
AccessorFunc( MeshPanel.Meta, "m_Normal", "Normal" ) -- Dealt with internally

AccessorFunc( MeshPanel.Meta, "m_Width", "Width", FORCE_NUMBER )
AccessorFunc( MeshPanel.Meta, "m_Height", "Height", FORCE_NUMBER )
AccessorFunc( MeshPanel.Meta, "m_Distance", "MaxDistance", FORCE_NUMBER )

AccessorFunc( MeshPanel.Meta, "m_Unique", "Name", FORCE_STRING )
AccessorFunc( MeshPanel.Meta, "m_Render", "AutomaticRender", FORCE_BOOL )
AccessorFunc( MeshPanel.Meta, "m_Cursor", "EnableCursor", FORCE_BOOL )

AccessorFunc( MeshPanel.Meta, "m_Update", "Update" )

function MeshPanel.Meta:CalculateNormal( )

	local ang = self:GetAngles( )
	local normal = Angle( ang.p, ang.y, ang.r )
	normal:RotateAroundAxis( ang:Forward(), -90 )
	normal:RotateAroundAxis( ang:Right(), 90 )
	
	return normal:Forward()

end

function MeshPanel.Meta:CalculateCursor( Pl )

	local p = util.IntersectRayWithPlane(LocalPlayer():EyePos(), LocalPlayer():GetAimVector(), self:GetPos( ), self:GetNormal( ) )

	-- if there wasn't an intersection, don't calculate anything.
	if not p then return end
	
	if ( p:Distance( LocalPlayer():EyePos() ) > self:GetMaxDistance() ) then return end

	local offset = self:GetPos( ) - p
	--offset:Rotate( self:GetNormal( ):Angle( ) )
	offset:Rotate( Angle( 0, -self:GetAngles().y, 0 ) )
	
	-- Calculate this stuff
	
	local x, y = -offset.x / self:GetScale( ), offset.z / self:GetScale( )
	
	--if ( offset:Angle( self:GetAngles():Up() ).y < 91 ) then
	--	x = math.sqrt( offset:LengthSqr() - offset.z^2 ) / self:GetScale( )
	--end
	
	if ( x >= self:GetWidth() or y >= self:GetHeight( ) or x <= 0 or y <= 0 ) then return end
	
	return x, y

end

function MeshPanel.Meta:Draw( )

	local m_Update = self:GetUpdate( )
	if ( not m_Update ) then return end

	local x, y = nil, nil
	if ( self:GetEnableCursor() ) then
		x, y = self:CalculateCursor( LocalPlayer() )
	end

	cam.Start3D2D( self:GetPos( ), self:GetAngles( ), self:GetScale( ) )
		
		m_Update( self, x, y )
		
	cam.End3D2D( )
	
end

function MeshPanel.Meta:DrawButton( cx, cy, r, x, y, w, h, text, font, color1, textcolor1, color2, textcolor2 )

	
	if ( cx and cy and cx >= x and cx <= x + w and cy >= y and cy <= y + h ) then
	
		draw.RoundedBox( r, x, y, w, h, color2 )
		draw.SimpleText( text, font, x + w/2, y + h/2, textcolor2, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	
	else
	
		draw.RoundedBox( r, x, y, w, h, color1 )
		draw.SimpleText( text, font, x + w/2, y + h/2, textcolor1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	
	end
	

end

function MeshPanel.Meta:Destroy( )
	
	MeshPanel.Panels[ self:GetName() ] = nil
	
end


-- TEST

local MyMeshPanel = MeshPanel.New( Vector( 0, 0, 0 ), Angle( 0, 0, 90 ), 0.1, "MyMeshPanel" )
MyMeshPanel:SetEnableCursor( true )
MyMeshPanel:SetWidth( 1000 )
MyMeshPanel:SetHeight( 1000 )

MyMeshPanel:SetUpdate( function( self, cursorx, cursory )

	draw.RoundedBox( 8, 10, 10, 980, 980, Color( 128, 128, 255 ) )
	
	surface.SetFont("Trebuchet24")
	surface.SetTextColor(255, 255, 255, 255)
	surface.SetTextPos(20, 20)
	surface.DrawText("Test!")

	if ( cursorx and cursory ) then

		draw.RoundedBox( 2, cursorx-10, cursory-10, 20, 20, Color( 255, 255, 255 ) )

	end
	
	self:DrawButton( cursorx, cursory, 2, 30, 30, 60, 30, "Test", "Trebuchet24", Color( 0 , 255, 0 ) , Color( 255, 255, 255 ), Color( 0, 0, 255 ), Color( 255, 255, 255 ) )
	
end)
