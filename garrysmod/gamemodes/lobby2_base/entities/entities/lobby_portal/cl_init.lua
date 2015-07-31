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
MaxRecursion = 3

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
	
	self:RequestInformation( )
	
	self.TargetPortal = NULL
	self.TargetPos = Vector( 0, 0, 0 )
	self.TargetAngles = Angle( 0, 0, 0 )
	
end

function ENT:GetTarget( )

	return self.TargetPortal
	
end

function ENT:GetInterimInformation( )

	return self.TargetPos, self.TargetAngles
	
end

function ENT:RequestInformation( )

	net.Start( "lobby_portal_request_info" )
		net.WriteEntity( self )
	net.SendToServer( )

end

local function IsInFront( posA, posB, normal )
	
	local Vec1 = ( posB - posA ):GetNormalized()
	
	return ( normal:Dot( Vec1 ) < 0 )
	
end

function ENT:Think( )

	if ( not IsValid( self.Target ) ) then
		
		--self:RequestInformation( )
		
	end

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
	
	local pos, ang = self:GetInterimInformation( )

	PortalRecursion = PortalRecursion + 1

	local oldrt = render.GetRenderTarget( )
	render.SetRenderTarget( self.RenderTarget )
		
		render.Clear( 0, 0, 0, 255 )
		render.ClearDepth()
		render.ClearStencil()
		
		local v = self:GetPos() - LocalPlayer():EyePos()
		v:Rotate( -ang + self:GetAngles() )
		render.RenderView({
			origin = pos - v,
			angles = -ang + self:GetAngles() + LocalPlayer():EyeAngles() + LocalPlayer():GetViewPunchAngles(),
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

net.Receive( "lobby_portal_request_info", function( len, ply )

	local Ent = net.ReadEntity( )
	local Target = net.ReadEntity( )
	
	local pos = net.ReadVector( )
	local ang = net.ReadAngle( )
	
	if ( IsValid( Ent ) and IsValid( Target ) ) then
		Ent.TargetPortal = Target
		Ent.TargetPos = Target:GetPos( )
		Ent.TargetAngles = Target:GetAngles( )
		
	else
	
		Ent.TargetPortal = NULL
		Ent.TargetPos = pos
		Ent.TargetAngles = ang
	
	end

end)
