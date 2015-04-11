-- vgui/user.lua

local PANEL = {}
AccessorFunc( PANEL, "_Team", "Team" )

function PANEL:Init()
	self.Color = false;
	self.UpColor = false;
	self.Column = {}
	self._Team = 1

	
	self.TeamName = vgui.Create( "DLabel", self )
	--self.PlayerName:SetText( self:GetPlayer():Nick() )
	self.TeamName:Dock( FILL )
	self.TeamName:DockMargin(10,10,10,10)
	self.TeamName:SetFont( "Lobbymidbold" )
	
	self:Dock(TOP)
	self:DockMargin(2,1,2,1);
	local xparent = self:GetParent():GetSize()
	self:SetSize(xparent - 4, 36)
end

function PANEL:Paint( w, h )
	draw.GradientBox(0,0, w, h, 1, self.Color, self.UpColor)
end

function PANEL:Update()

	self.Color = Color ( 150,150,150,255 )
	self.UpColor = Color( self.Color.r + 25, self.Color.g + 25, self.Color.b + 25 )
	self.TeamName:SetText( team.GetName( self:GetTeam() ) )

end

function PANEL:AddColumn( Order, Name, pixels, _func )
	
	local xparent = self:GetParent():GetSize()
	
	self.Column[Order] = vgui.Create( "DLabel", self )
	self.Column[Order]:SetPos(xparent - pixels - 4, 12/2 - 5 );
	self.Column[Order]:SetFont( "Lobbymidbold" )
	self.Column[Order]:SetText( Name )
end

vgui.Register( "scoreboard.teamheader", PANEL, "DPanel" )