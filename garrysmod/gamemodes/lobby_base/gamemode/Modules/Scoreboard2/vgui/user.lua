-- vgui/user.lua

local PANEL = {}
AccessorFunc( PANEL, "_Player", "Player" )

function PANEL:Init()
	self.Color = false;
	self.UpColor = false;
	self.ColumnUpdates = {}
	
	self.Avatar = vgui.Create( "AvatarImage", self )
	self.Avatar:SetSize( 32,32 )
	self.Avatar:SetPlayer( self:GetPlayer() , 32 )
	self.Avatar:Dock( LEFT )
	self.Avatar:DockMargin(2,2,2,2)
	
	self.PlayerName = vgui.Create( "DLabel", self )
	--self.PlayerName:SetText( self:GetPlayer():Nick() )
	self.PlayerName:Dock( LEFT )
	self.PlayerName:DockMargin(10,10,10,10)
	self.PlayerName:SetFont( "Lobbymidbold" )
	
	self.Column = {};
	
	self:Dock(TOP)
	self:DockMargin(2,1,2,1);
	local xparent = self:GetParent():GetSize()
	self:SetSize(xparent - 4, 36)
end

function PANEL:Paint( w, h )
	--draw.RoundedBox( 4, 0, 0, w, h, self.Color or Color(125,125,125,255))
	draw.GradientBox(0,0, w, h, 1, self.Color or Color(125,125,125,255), self.UpColor or Color(125,125,125,255))
end

function PANEL:Update()

	if GAMEMODE.ScoreboardTeamBased then
		self.Color = GAMEMODE:GetTeamColor( self:GetPlayer() )
	else
		self.Color = self:GetPlayer():GetDisplayTextColor( );
	end
	self.UpColor = Color( self.Color.r + 25, self.Color.g + 25, self.Color.b + 25 )
	self.Avatar:SetPlayer( self:GetPlayer() , 32)
	self.PlayerName:SetText( self:GetPlayer():Nick() )
	self:UpdateColumns()
end

function PANEL:AddColumn( Order, Name, pixels, _func )
	self.ColumnUpdates[Order] = {Name, pixels, _func}
	
	local xparent = self:GetParent():GetSize()
	
	self.Column[Order] = vgui.Create( "DLabel", self )
	self.Column[Order]:SetPos(xparent - pixels - 4, 36/2 - 5 );
	--self.Column[Order]:DockMargin(30,10,30,10);
	self.Column[Order]:SetFont( "Lobbymidbold" )
end

function PANEL:UpdateColumns()
	for Order, Column in pairs( self.ColumnUpdates ) do
		self.Column[Order]:SetText( Column[3]( self:GetPlayer() ) or "ERROR" )
		self.Column[Order]:SizeToContents()
		
		local xparent = self:GetParent():GetSize()
		self.Column[Order]:SetPos(xparent - self.ColumnUpdates[Order][2] - 4, 36/2 - 10 );
	end
end

function PANEL:Think()
	self:UpdateColumns()
end

function PANEL:OnMouseReleased(mousecode)
	-- Admin
	
	if ( mousecode == MOUSE_RIGHT ) then
		
		GAMEMODE.CreateAdminMenu(self:GetPlayer())
	end

end

vgui.Register( "scoreboard.user", PANEL, "DPanel" )