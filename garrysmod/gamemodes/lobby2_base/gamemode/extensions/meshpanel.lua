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

function MeshPanel.New( Top, Bottom, Res, name, additive )
	
	local UniqueName = "_MESHPANEL_" .. name
	
	local obj = { }
	setmetatable( obj, {__index = MeshPanel.Meta} )
	
	obj:SetTopVector( Top )
	obj:SetBottomVector( Bottom )
	obj:SetResolution( Res )
	obj:SetName( UniqueName )
	obj:SetAutomaticRender( true )
	obj:SetEnableCursor( false )
	
	obj:SetRenderTarget( GetRenderTarget( UniqueName, Res, Res, additive and additive or false ) )
	obj:SetMaterial( CreateMaterial( UniqueName, "UnlitGeneric", {
		["$basetexture"] = obj:GetRenderTarget(),
		["$translucent"] = "1",
		["$vertexalpha"] = "1",
		["$vertexcolor"] = "1"
	} ) )
	
	obj:GetMaterial( ):SetTexture( "$basetexture", obj:GetRenderTarget() )
	
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

AccessorFunc( MeshPanel.Meta, "m_TopVector", "TopVector" )
AccessorFunc( MeshPanel.Meta, "m_BottomVector", "BottomVector" )
AccessorFunc( MeshPanel.Meta, "m_Resolution", "Resolution", FORCE_NUMBER )
AccessorFunc( MeshPanel.Meta, "Material", "Material" )
AccessorFunc( MeshPanel.Meta, "RenderTarget", "RenderTarget" )
AccessorFunc( MeshPanel.Meta, "m_Unique", "Name", FORCE_STRING )
AccessorFunc( MeshPanel.Meta, "m_Render", "AutomaticRender", FORCE_BOOL )
AccessorFunc( MeshPanel.Meta, "m_Cursor", "EnableCursor", FORCE_BOOL )

MeshPanel.Meta.RenderTarget = false
MeshPanel.Meta.Material = false

function MeshPanel.Meta:CalculateNormal( )

	local P1, P2 = self:GetTopVector( ), self:GetBottomVector( )
	local P3 = Vector( P2.x, P2.y, P1.z )
	local V, W = P2 - P1, P3 - P1

	return Vector(
		( V.y * W.z ) - ( V.z * W.y ),
		( V.z * W.x ) - ( V.x * W.z ),
		( V.x * W.y ) - ( V.y * W.x )
	):GetNormalized( )

end

function MeshPanel.Meta:CalculateCursor( Pl )

	local P1, P2 = self:GetTopVector( ), self:GetBottomVector( )
	local normal = self:CalculateNormal( )
	local Pos3D = util.IntersectRayWithPlane( Pl:EyePos(), Pl:GetAimVector(), self:GetTopVector( ), normal )

	if ( not Pos3D ) then return 0, 0 end

	local offset = P1 - Pos3D

	local angle2 = Vector( P2.x - P1.x, P2.y - P1.y, 0 ):Angle()
	angle2:RotateAroundAxis( normal, 90 )
	angle2 = angle2:Forward()
	
	local offsetp = Vector(offset.x, offset.y, offset.z)
	offsetp:Rotate(-normal:Angle())

	local mulx = self:GetResolution() / self:GetTopVector( ):Distance( Vector( P2.x - P1.x, P2.y - P1.y, 0 ) )
	local muly = self:GetResolution() / self:GetBottomVector( ):Distance( Vector( P2.x - P1.x, P2.y - P1.y, 0 ) )

	return offsetp.y * mulx, -offsetp.z * muly

end

function MeshPanel.Meta:Update( callback )
	
	if ( not callback ) then return end

	local x, y = nil, nil

	if ( self:GetEnableCursor() ) then
		x, y = self:CalculateCursor( LocalPlayer() )
	end
	
	render.PushRenderTarget( self:GetRenderTarget( ), 0, 0, self:GetResolution( ), self:GetResolution( ) )
		render.OverrideAlphaWriteEnable( true, true )
		
			render.ClearDepth()
			render.Clear( 0, 0, 0, 0 )
			
			cam.Start2D()
				callback( self:GetResolution( ), self:GetResolution( ), x, y )
			cam.End2D()
			
		render.OverrideAlphaWriteEnable( false )
	render.PopRenderTarget()
	
end

function MeshPanel.Meta:AddVertex( pos, u, v)
	
	mesh.Position( pos )
	mesh.TexCoord( 0, u, v )
	mesh.Color( 255, 255, 255, 255 )
	mesh.AdvanceVertex()
	
end

function MeshPanel.Meta:Draw( )
	
	-- Don't bother rendering if there isn't a material to draw
	local mat = self:GetMaterial()
	if ( not mat ) then return end
	
	-- Don't bother rendering if we can't calculate things
	local top, bottom = self:GetTopVector(), self:GetBottomVector( )
	if ( not top or not bottom ) then return end
	
	render.SetMaterial( mat )
	
	mesh.Begin( MATERIAL_TRIANGLES, 4 )
		
		-- Front Top
		self:AddVertex( top, 0, 0 )
		self:AddVertex( Vector( top.x, top.y, bottom.x ) , 0, 1)
		self:AddVertex( Vector( bottom.x, bottom.y, top.z ), 1, 0)
		
		-- Back Top
		self:AddVertex( Vector( top.x, top.y, bottom.x ) , 0, 1)
		self:AddVertex( top, 0, 0 )
		self:AddVertex( Vector( bottom.x, bottom.y, top.z ), 1, 0)
		
		-- Front Bottom
		self:AddVertex( bottom, 1, 1)
		self:AddVertex( Vector( top.x, top.y, bottom.x ) , 0, 1)
		self:AddVertex( Vector( bottom.x, bottom.y, top.z ), 1, 0)
		
		-- Back bottom
		self:AddVertex( Vector( top.x, top.y, bottom.x ) , 0, 1)
		self:AddVertex( bottom, 1, 1)
		self:AddVertex( Vector( bottom.x, bottom.y, top.z ), 1, 0)

	mesh.End()
	
end

function MeshPanel.Meta:Destroy( )
	
	MeshPanel.Panels[ self:GetName() ] = nil
	
end


-- TEST

local MyMeshPanel = MeshPanel.New( Vector( 0, 0, 0 ), Vector( 100, 0, 100 ), 2048, "MyMeshPanel", false )
MyMeshPanel:SetEnableCursor( true )

hook.Add( "PreDrawOpaqueRenderables", "TestMeshPanel", function()

	MyMeshPanel:Update( function( width, height, cursorx, cursory )

		draw.RoundedBox( 8, 10, 10, width - 20, height - 20, Color( 128, 128, 255 ) )

		if ( cursorx and cursory ) then

			draw.RoundedBox( 2, cursorx-10, cursory-10, 20, 20, Color( 255, 255, 255 ) )

		end

	end)

end )