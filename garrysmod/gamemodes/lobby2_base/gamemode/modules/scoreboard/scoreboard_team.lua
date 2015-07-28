--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, 2015
	
-----------------------------------------------------------]]--

local PANEL = { }
local mat_header = Material( "lobby2/stripes.png" )

function PANEL:Init( )

	self.mat_w = mat_header:Width( )
	self.mat_h = mat_header:Height( )
	
	self.lblTitle = vgui.Create( "DLabel", self )
	self.lblTitle:SetFont( "LobbyTitle" )
	self.lblTitle:SetText( "Team Winner" )
	self.lblTitle:SetTextColor( Color( 255, 255, 255, 255 ) )
	
	self:DockPadding( 5, 25 + 5, 5, 5 )

end

function PANEL:PerformLayout()

	self.lblTitle:SetPos( 8, 2 )
	self.lblTitle:SetSize( self:GetWide() - 25, 20 )

end

function PANEL:SetTeam( nTeamIndex )

	self.lblTitle:SetText( team.GetName( nTeamIndex ) )
	self.lblTitle:SizeToContents( )

end

function PANEL:DrawHeader( w, h )

	render.ClearStencil() --Clear stencil
	render.SetStencilEnable( true ) --Enable stencil
	
		render.SetStencilReferenceValue( 15 )
		render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_ALWAYS )
		render.SetStencilFailOperation( STENCILOPERATION_KEEP )
		render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
		render.SetStencilZFailOperation( STENCILOPERATION_KEEP )
				
			local header_poly = {
				{ x = 0,	y = 0 },
				{ x = w - 25,	y = 0 },
				{ x = w, 	y = 25},
				{ x = 0,	y = 25}
			}
	
			surface.SetDrawColor( 255,255,255,255 )
			draw.NoTexture()
			surface.DrawPoly( header_poly )

		render.SetStencilReferenceValue( 15 )
		render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
		render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
			
			surface.SetDrawColor( 255,255,255,255 )
			surface.SetMaterial( mat_header )
			for i=0, math.huge do
				if ( ( i + 1 ) * 25 > w ) then break end
				surface.DrawTexturedRect( i * 25, 0, 25, 25 )
			end
	
	render.SetStencilEnable( false )

	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial( mat_header )

end

function PANEL:DrawBackground( w, h )

	surface.SetDrawColor( 0, 0, 0, 150 )
	draw.NoTexture()
	surface.DrawRect( 0, 25, w, h - 25 )
	
	surface.SetDrawColor( 50, 50, 50, 150 )
	draw.NoTexture()
	surface.DrawRect( 1, 0, w - 25, 1 ) -- Top
	surface.DrawRect( 0, h - 1, w, 1 ) -- Bottom
	surface.DrawRect( 0, 0, 1, h - 1 ) -- Left
	surface.DrawRect( w - 1, 25, 1, h - 25 ) -- Right
	surface.DrawLine( w - 25, 0, w, 25 ) -- Corner

end

function PANEL:Paint( w, h )

	-- Header
	self:DrawHeader( w, h )
	self:DrawBackground( w, h )

end

vgui.Register( "lobby_scoreboard", PANEL, "Panel" )
