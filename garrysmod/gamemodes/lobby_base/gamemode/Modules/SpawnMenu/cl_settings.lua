
local PANEL = { }

local bCursorEnter = function( b )
	if b.m_colTextHovered then DLabel.ApplySchemeSettings( self ) end
end

local bCursorExit = function( b )
	if b.m_colTextHovered then DLabel.ApplySchemeSettings( self ) end
end

function PANEL:Init( )
	self.Label = vgui.Create( "DLabel", self )
	self.Label:SetText( "Player Settings." )
	self.Label:SetTextColor( Color( 255, 255, 255, 255 ) )
	self.Label:SizeToContents( )
	self.Checks = {}
	
	self.Checks[1] = vgui.Create( "DLabel", self )
	self.Checks[1]:SetText("Options:")
	self.Checks[1]:SetTextColor( Color( 255, 255, 255, 255 ) )
	self.Checks[1]:SizeToContents()
	self.Checks[1]:Dock(TOP)
	self.Checks[1]:DockMargin(5,5,5,5)
	
	self.Checks[2] = vgui.Create('DNumSlider', self)
	self.Checks[2]:Dock(TOP)
	self.Checks[2]:DockMargin(5,5,5,5)
	self.Checks[2]:SetText('Third Person Camera Distance')
	self.Checks[2]:SetMin( 75 );
	self.Checks[2]:SetMax( 250 );
	self.Checks[2]:SetDecimals( 0 );
	self.Checks[2]:SetConVar( "cam_idealdist" )
	self.Checks[2]:SetValue( 1 )
	self.Checks[2]:SetWide(550)

	
end

function PANEL:Paint()
end

function PANEL:PerformLayout( )
	self:StretchToParent( 2, 24, 2, 2 )
	self.Label:SetPos( 2, 2 )
	for k,v in pairs(self.Checks) do
		v:SetPos(10,(k * 20) + 18)
	end
end

vgui.Register( "lobby_settings", PANEL, "DPanel" )