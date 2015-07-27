include('shared.lua')

function ENT:Initialize( )

	self.RenderTarget = GetRenderTarget( "vgui/white", ScrW(), ScrH(), true )
	self.TextureID = surface.GetTextureID( self:EntIndex() .. "rendertarget" )
	self.RenderMaterial = CreateMaterial( "vgui/white", "unlitgeneric", {
		["$basetexture"] = self.RenderTarget:GetName( )
	})
	
	hook.Add( "PreDrawOpaqueRenderables", self, self.PostDrawOpaqueRenderables )

end
 
function ENT:Draw()

	if ( self.drawingrenderables ) then
		self:DrawModel()
	end

end

function ENT:PostDrawOpaqueRenderables( bDrawingDepth, bDrawingSkybox )

	if ( not self.drawingrenderables ) then
		self.drawingrenderables = true
		render.ClearStencil() --Clear stencil
		render.SetStencilEnable( true ) --Enable stencil
		
			render.SetStencilReferenceValue( 15 )
			render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_ALWAYS ) --We don't actually draw the weapon, we just want it on our stencil
			render.SetStencilFailOperation( STENCILOPERATION_KEEP ) --If we fail, do nothing
			render.SetStencilPassOperation( STENCILOPERATION_REPLACE ) --If we pass (we see it) increase the pixels value by 1
			render.SetStencilZFailOperation( STENCILOPERATION_KEEP ) --If it's behind something, dont do anything
					
			self:Draw( )

			render.SetStencilReferenceValue( 15 ) --Reference value 1
			render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL ) --Only draw if pixel value == reference value
				
			self:DrawPortal( )
		
		render.SetStencilEnable( false )
		self.drawingrenderables = false
	end
	
end

function ENT:DrawPortal( )

	if ( self.drawingrenderables ) then

	cam.Start2D()
	
		local oldw, oldh = ScrW(), ScrH()
	
		local oldrt = render.GetRenderTarget( )
		render.SetRenderTarget( self.RenderTarget )
		render.SetViewPort( 0, 0, ScrW(), ScrH() )
		render.Clear( 255, 255, 255, 0 )
		
		render.RenderView({
			origin = LocalPlayer( ):EyePos( ),
			angles = LocalPlayer( ):EyeAngles( ),
			x = 0,
			y = 0,
			w = ScrW( ),
			h = ScrH( )
		})
		
		render.SetRenderTarget( oldrt )
		render.SetViewPort( 0, 0, oldw, oldh )
		
		self:DrawToScreen( )
		
	cam.End2D()
	
	end

end

function ENT:DrawToScreen( )

	--render.DrawTextureToScreen( self.RenderTarget )

	render.SetMaterial( self.RenderMaterial )
	render.DrawScreenQuad()
	
end