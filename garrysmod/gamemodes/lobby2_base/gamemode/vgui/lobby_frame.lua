--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, 2015
	
-----------------------------------------------------------]]--

local PANEL = {}

AccessorFunc( PANEL, "m_bIsMenuComponent", 		"IsMenu", 			FORCE_BOOL )
AccessorFunc( PANEL, "m_bDraggable", 			"Draggable", 		FORCE_BOOL )
AccessorFunc( PANEL, "m_bSizable", 				"Sizable", 			FORCE_BOOL )
AccessorFunc( PANEL, "m_bScreenLock", 			"ScreenLock", 		FORCE_BOOL )
AccessorFunc( PANEL, "m_bDeleteOnClose", 		"DeleteOnClose", 	FORCE_BOOL )
AccessorFunc( PANEL, "m_bPaintShadow", 			"PaintShadow", 		FORCE_BOOL )

AccessorFunc( PANEL, "m_iMinWidth", 			"MinWidth" )
AccessorFunc( PANEL, "m_iMinHeight", 			"MinHeight" )

AccessorFunc( PANEL, "m_bBackgroundBlur", 		"BackgroundBlur", 	FORCE_BOOL )

local X = Material( "icon16/cross.png" )

function PANEL:Init()

	self:SetFocusTopLevel( true )
	self:SetPaintShadow( true )

	self.btnClose = vgui.Create( "DButton", self )
	self.btnClose:SetText( "" )
	self.btnClose.DoClick = function ( button ) self:Close() end
	self.btnClose.Paint = function( panel, w, h )
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( X )
		surface.DrawTexturedRect( 0, 0, w, h )
	end

	self.lblTitle = vgui.Create( "DLabel", self )
	self.lblTitle:SetFont( "LobbyTitle" )
	self.lblTitle.UpdateColours = function( label, skin )

		if ( self:IsActive() ) then return label:SetTextStyleColor( skin.Colours.Window.TitleActive ) end

		return label:SetTextStyleColor( skin.Colours.Window.TitleInactive )

	end

	self:SetDraggable( true )
	self:SetSizable( false )
	self:SetScreenLock( false )
	self:SetDeleteOnClose( true )
	self:SetTitle( "Window" )

	self:SetMinWidth( 50 )
	self:SetMinHeight( 50 )

	-- This turns off the engine drawing
	self:SetPaintBackgroundEnabled( false )
	self:SetPaintBorderEnabled( false )

	self.m_fCreateTime = SysTime()

	self:DockPadding( 5, 24 + 5, 5, 5 )

end

function PANEL:ShowCloseButton( bShow )

	self.btnClose:SetVisible( bShow )

end

function PANEL:SetTitle( strTitle )

	self.lblTitle:SetText( strTitle )
	self.lblTitle:SizeToContents( )

end

function PANEL:Close()

	self:SetVisible( false )

	if ( self:GetDeleteOnClose() ) then
		self:Remove()
	end

	self:OnClose()

end

function PANEL:OnClose()

end

function PANEL:Center()

	self:InvalidateLayout( true )
	self:SetPos( ScrW()/2 - self:GetWide()/2, ScrH()/2 - self:GetTall()/2 )

end

function PANEL:IsActive()

	if ( self:HasFocus() ) then return true end
	if ( vgui.FocusedHasParent( self ) ) then return true end

	return false

end

function PANEL:SetIcon( str )

	if ( !str && IsValid( self.imgIcon ) ) then
		return self.imgIcon:Remove() -- We are instructed to get rid of the icon, do it and bail.
	end

	if ( !IsValid( self.imgIcon ) ) then
		self.imgIcon = vgui.Create( "DImage", self )
	end

	if ( IsValid( self.imgIcon ) ) then
		self.imgIcon:SetMaterial( Material( str ) )
	end

end

function PANEL:Think()

	local mousex = math.Clamp( gui.MouseX(), 1, ScrW()-1 )
	local mousey = math.Clamp( gui.MouseY(), 1, ScrH()-1 )

	if ( self.Dragging ) then

		local x = mousex - self.Dragging[1]
		local y = mousey - self.Dragging[2]

		-- Lock to screen bounds if screenlock is enabled
		if ( self:GetScreenLock() ) then

			x = math.Clamp( x, 0, ScrW() - self:GetWide() )
			y = math.Clamp( y, 0, ScrH() - self:GetTall() )

		end

		self:SetPos( x, y )

	end

	if ( self.Sizing ) then

		local x = mousex - self.Sizing[1]
		local y = mousey - self.Sizing[2]
		local px, py = self:GetPos()

		if ( x < self.m_iMinWidth ) then x = self.m_iMinWidth elseif ( x > ScrW() - px and self:GetScreenLock() ) then x = ScrW() - px end
		if ( y < self.m_iMinHeight ) then y = self.m_iMinHeight elseif ( y > ScrH() - py and self:GetScreenLock() ) then y = ScrH() - py end

		self:SetSize( x, y )
		self:SetCursor( "sizenwse" )
		return

	end

	if ( self.Hovered && self.m_bSizable &&
		 mousex > ( self.x + self:GetWide() - 20 ) &&
		 mousey > ( self.y + self:GetTall() - 20 ) ) then

		self:SetCursor( "sizenwse" )
		return

	end

	if ( self.Hovered && self:GetDraggable() && mousey < ( self.y + 24 ) ) then
		self:SetCursor( "sizeall" )
		return
	end

	self:SetCursor( "arrow" )

	-- Don't allow the frame to go higher than 0
	if ( self.y < 0 ) then
		self:SetPos( self.x, 0 )
	end

end

function PANEL:Paint( w, h )

	if ( self.m_bBackgroundBlur ) then
		Derma_DrawBackgroundBlur( self, self.m_fCreateTime )
	end
	
	surface.SetDrawColor( 0, 0, 0, 150 )
	surface.DrawRect( 0, 0, w, h )
	
	surface.SetDrawColor( 50, 50, 50, 150 )
	surface.DrawRect( 0, 0, w, 1 )
	surface.DrawRect( 0, h-1, w, 1 )
	surface.DrawRect( 0, 1, 1, h-2 )
	surface.DrawRect( w - 1, 1, 1, h-2 )
	
	return true

end

function PANEL:OnMousePressed()

	if ( self.m_bSizable ) then

		if ( gui.MouseX() > ( self.x + self:GetWide() - 20 ) &&
			gui.MouseY() > ( self.y + self:GetTall() - 20 ) ) then

			self.Sizing = { gui.MouseX() - self:GetWide(), gui.MouseY() - self:GetTall() }
			self:MouseCapture( true )
			return
		end

	end

	if ( self:GetDraggable() && gui.MouseY() < (self.y + 24) ) then
		self.Dragging = { gui.MouseX() - self.x, gui.MouseY() - self.y }
		self:MouseCapture( true )
		return
	end

end

function PANEL:OnMouseReleased()

	self.Dragging = nil
	self.Sizing = nil
	self:MouseCapture( false )

end

function PANEL:PerformLayout()

	local titlePush = 0

	if ( IsValid( self.imgIcon ) ) then

		self.imgIcon:SetPos( 5, 5 )
		self.imgIcon:SetSize( 16, 16 )
		titlePush = 16

	end

	self.btnClose:SetPos( self:GetWide() - 24, 6 )
	self.btnClose:SetSize( 16, 16 )

	self.lblTitle:SetPos( 8 + titlePush, 2 )
	self.lblTitle:SetSize( self:GetWide() - 25 - titlePush, 20 )

end

vgui.Register( "lobby_frame", PANEL, "EditablePanel" )