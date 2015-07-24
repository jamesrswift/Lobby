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

AccessorFunc( PANEL, "m_Color", "Color" )
AccessorFunc( PANEL, "m_LighterColor", "LighterColor" )
AccessorFunc( PANEL, "m_DarkerColor", "DarkerColor" )
AccessorFunc( PANEL, "m_StartTime", "StartTime", FORCE_NUMBER )
AccessorFunc( PANEL, "m_Duration", "Duration", FORCE_NUMBER )
AccessorFunc( PANEL, "m_Badge", "Badge", FORCE_STRING )

function PANEL:Init( )

	self:SetStartTime( CurTime( ) )
	self:SetDuration( 10 )
	self:DockPadding( 2, 2, 2, 6 )

	self.icon = vgui.Create( "DImage", self )
	self.icon:Dock( LEFT )
	--self.icon:SetPaintedManually( true )
	
	self.text = vgui.Create( "DLabel", self )
	self.text:DockMargin( 6, 0, 6, 0 )
	self.text:Dock( FILL )
	self.text:SetText( "You haven't set the text!" )
	self.text:SetFont( "LobbyNotification" )
	self.text:SetColor( color_white )
	--self.text:SetPaintedManually( true )
	
	self:SetColor( Color( 100, 100, 100 ) )
	self:SetLighterColor( Color( 120, 120, 120 ) )
	self:SetDarkerColor( Color( 70, 70, 70 ) )
	
	self.Closing = false
	self.Alpha = 0

end

function PANEL:PerformLayout( )

	local w, h = self:GetSize()
	
	self.icon:SetSize( h - 6 , h - 6 )
	self.icon:Dock( LEFT )
	self.text:Dock( FILL )

end

function PANEL:SetText( str )

	self.text:SetText( string.upper( str ) )
	self.text:SizeToContents( )
	
	local tx, ty = self.text:GetSize( )
	local ix, iy = self.icon:GetSize( )
	
	self:SetSize( tx + ty + 40, iy + 4 )
	self:PerformLayout( )
	
end

function PANEL:CalculateXSize( )

	local x = 4
	
	for _, panel in pairs( self:GetChildren() ) do
	
		x = x + panel:GetSize() + 6

	end
	
	return x

end

function PANEL:SetIcon( Image )

	self.icon.ImageName = "sorry"

	self.icon:SetMaterial( Image )
	self.icon:FixVertexLitMaterial()
	self:PerformLayout( )

end

function PANEL:PaintBackground( w, h )

	local color = self:GetColor( )
	
	surface.SetDrawColor( color.r, color.g, color.b, self.Alpha * 255 )
	surface.DrawRect( 0, 0, w, h )

end

function PANEL:PaintBadge( w, h )

end

function PANEL:PaintBar( w, h )

	local color = self:GetColor( )
	local hue, saturation, value = ColorToHSV( color )
	
	local lighter = self:GetLighterColor( )
	surface.SetDrawColor( lighter.r, lighter.g, lighter.b, self.Alpha * 255 )
	surface.DrawRect( 0, h-4, w, 4 )
	
	local darker = self:GetDarkerColor( )
	surface.SetDrawColor( darker.r, darker.g, darker.b, self.Alpha * 255 )
	surface.DrawRect( 0, h-4, math.Clamp((self:GetStartTime() + self:GetDuration() - CurTime())/self:GetDuration(), 0, math.huge )*w, 4 )

end

function PANEL:Paint( w, h )

	if ( self.Closing ) then
		self.Alpha = Lerp( FrameTime() * 5, self.Alpha, 0 )
	else
		self.Alpha = Lerp( FrameTime() * 5, self.Alpha, 1 )
	end
	
	self.text:SetColor( Color( 255, 255, 255, self.Alpha * 255 ) )
	self.icon:SetImageColor( Color( 255, 255, 255, self.Alpha * 255 ) )
	
	self:PaintBackground( w, h )
	self:PaintBadge( w, h )
	self:PaintBar( w, h )

end

function PANEL:Think( )

	if ( self:GetStartTime() + self:GetDuration() - 0.5 < CurTime() and not self.Closing ) then
		self.Closing = true
	end

	if ( self:GetStartTime() + self:GetDuration() < CurTime() and not self.CalledCallback ) then
	
		self:OnTimeOver( )
		self.CalledCallback = true
		
	end

end

function PANEL:OnTimeOver( )


end

vgui.Register( "lobby_notification", PANEL, "Panel" )