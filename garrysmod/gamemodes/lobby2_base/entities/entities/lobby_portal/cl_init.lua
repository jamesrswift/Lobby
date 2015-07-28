--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, 2015
	
-----------------------------------------------------------]]--

include('shared.lua')

PortalRecursion = 0
MaxRecursion = 2

function ENT:Initialize( )

	self.RenderName = self:EntIndex() .. "RenderTarget"
	self.RenderTarget = GetRenderTarget( self.RenderName, ScrW(), ScrH(), true )
	self.RenderMaterial = CreateMaterial( self.RenderName, "unlitgeneric", {
		["$basetexture"] = self.RenderName,
		[ '$texturealpha' ] = "0",
		[ '$vertexalpha' ] = "1"
	})

	
	self:DrawShadow( false )
end

local function IsInFront( posA, posB, normal )

        local Vec1 = ( posB - posA ):GetNormalized()

        return ( normal:Dot( Vec1 ) < 0 )

end
 
function ENT:Draw()

	local viewent = GetViewEntity()
	local pos = ( IsValid( viewent ) and viewent != LocalPlayer() ) and GetViewEntity():GetPos() or EyePos()
	
	if IsInFront( pos, self:GetPos(), self:GetForward() ) then
	
		/*self:SetNoDraw( true )
			self:RenderPortal( )
		self:SetNoDraw( false )*/

		render.ClearStencil() --Clear stencil
		render.SetStencilEnable( true ) --Enable stencil
		
			render.SetStencilReferenceValue( 15 )
			render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_ALWAYS ) --We don't actually draw the weapon, we just want it on our stencil
			render.SetStencilFailOperation( STENCILOPERATION_KEEP ) --If we fail, do nothing
			render.SetStencilPassOperation( STENCILOPERATION_REPLACE ) --If we pass (we see it) increase the pixels value by 1
			render.SetStencilZFailOperation( STENCILOPERATION_KEEP ) --If it's behind something, dont do anything
					
			self:DrawModel()

			render.SetStencilReferenceValue( 15 ) --Reference value 1
			render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL ) --Only draw if pixel value == reference value
			render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
				
			--self:RenderPortal( )
			self:DrawToScreen( )
		
		render.SetStencilEnable( false )
		
	end

end

function ENT:RenderPortal( )

	if ( not LocalPlayer() ) then return end

	if ( PortalRecursion >= MaxRecursion ) then return end

	PortalRecursion = PortalRecursion + 1

	local oldrt = render.GetRenderTarget( )
	render.SetRenderTarget( self.RenderTarget )
		render.Clear( 0, 0, 0, 255 )
		render.ClearDepth()
		render.ClearStencil()
		
		local v = self:GetPos() - LocalPlayer():EyePos()
		v:Rotate( Angle( 0, 90, 0 ) )
		render.RenderView({
			origin = Vector( 0,0,0 ) - v,
			angles = Angle( 0, 90, 0) + LocalPlayer():EyeAngles(),
			x = 0,
			y = 0,
			w = ScrW( ),
			h = ScrH( ),
			dopostprocess = false,
			drawhud = false,
			drawmonitors = false,
			drawviewmodel = false,
			ortho = false
		})
		
		render.UpdateScreenEffectTexture()

	render.SetRenderTarget( oldrt )
	
	PortalRecursion = PortalRecursion - 1

end

function ENT:DrawToScreen( )

	render.DrawTextureToScreen( self.RenderTarget )

	--self.RenderMaterial:SetString( "$basetexture", self.RenderName )
	--render.SetMaterial( self.RenderMaterial )
	--render.DrawScreenQuad()
	
end

hook.Add( "RenderScene", "Portal.RenderScene", function( Origin, Angles )
        // render each portal
        for k, v in pairs( ents.FindByClass( "lobby_portal" ) ) do
                local viewent = GetViewEntity()
                local pos = ( IsValid( viewent ) and viewent != LocalPlayer() ) and GetViewEntity():GetPos() or Origin
                if IsInFront( pos, v:GetPos(), v:GetForward() ) /*and v:Visible( LocalPlayer() )*/ then
                        v:RenderPortal( Origin, Angles )
                end
       
        end
end )