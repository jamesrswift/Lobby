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
	self.LastRender = 0
end

local function IsInFront( posA, posB, normal )
	
        local Vec1 = ( posB - posA ):GetNormalized()
	
        return ( normal:Dot( Vec1 ) < 0 )
	
end
 
function ENT:Draw()

	local viewent = GetViewEntity()
	local pos = ( IsValid( viewent ) and viewent != LocalPlayer() ) and GetViewEntity():GetPos() or EyePos()
	
	if IsInFront( pos, self:GetPos(), self:GetForward() ) then
	
		render.ClearStencil() --Clear stencil
		render.SetStencilEnable( true ) --Enable stencil
			
			render.SetStencilReferenceValue( 15 )
			render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_ALWAYS )
			render.SetStencilFailOperation( STENCILOPERATION_KEEP )
			render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
			render.SetStencilZFailOperation( STENCILOPERATION_KEEP )
			
			self:DrawModel()
			
			render.SetStencilReferenceValue( 15 ) --Reference value 1
			render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
			render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
			
			self:DrawToScreen( )
			
		render.SetStencilEnable( false )
		
		self.LastRender = CurTime( )
		
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
	
end

hook.Add( "RenderScene", "Portal.RenderScene", function( Origin, Angles )

	for k, v in pairs( ents.FindByClass( "lobby_portal" ) ) do
		
		local viewent = GetViewEntity()
		local pos = ( IsValid( viewent ) and viewent != LocalPlayer() ) and GetViewEntity():GetPos() or Origin
		
		if IsInFront( pos, v:GetPos(), v:GetForward() ) and ( v.LastRender + 0.5 > CurTime( ) ) then
			v:RenderPortal( Origin, Angles )
		end
		
	end
end )

hook.Add( "GetMotionBlurValues", "Portal.GetMotionBlurValues", function( x, y, fwd, spin )

	if ( PortalRecursion > 0 ) then
		return 0, 0, 0, 0
	end
	
end )

hook.Add( "PostProcessPermitted", "Portal.PostProcessPermitted", function( element )

	if ( element == "bloom" and PortalRecursion > 0 ) then
		return false
	end
	
end )

