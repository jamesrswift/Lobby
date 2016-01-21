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

function PANEL:Init()

	self.Offset = 0
	self.Scroll = 0
	self.CanvasSize = 1
	self.BarSize = 1	
	
	self.btnUp = vgui.Create( "DButton", self )
	self.btnUp:SetText( "" )
	self.btnUp.DoClick = function ( self ) self:GetParent():AddScroll( -1 ) end
	--self.btnUp.Paint = function( panel, w, h ) end
	
	--self.btnDown = vgui.Create( "DButton", self )
	self.btnDown:SetText( "" )
	self.btnDown.DoClick = function ( self ) self:GetParent():AddScroll( 1 ) end
	--self.btnDown.Paint = function( panel, w, h ) end
	
	self.btnGrip = vgui.Create( "DScrollBarGrip", self )
	--self.btnGrip.Paint = function( panel, w, h ) end
	
	self:SetSize( 15, 15 )

end

function PANEL:AtBottom( )

	return self.Scroll == self.CanvasSize 

end

function PANEL:ScrollToBottom( )

	self:SetScroll( self.CanvasSize )

end

function PANEL:GetRealWidth( )

	return self:GetWide( )

end

vgui.Register( "Chat_RichText_ScrollBar", PANEL, "DVScrollBar" )