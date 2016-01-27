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

function PANEL:Init()
	self:SetSize( 1000, 200 ) 
	self:SetPos( (ScrW() - 1000)/2, -210 )

	self.Grid = vgui.Create( "DGrid", self )
	self.Grid:Dock( FILL )
	self.Grid:SetCols( 10 )
	self.Grid:SetColWide( self:GetWide()/10 )
	self.Grid:SetRowHeight( self:GetTall()/2 )
end

function PANEL:Paint( w, h )
	surface.SetDrawColor(Color(0,0,0,150))
	surface.DrawRect( 0, 0, w, h)
	surface.DrawRect( 0, 0, w, h/2)
end

function PANEL:Think()

end

function PANEL:Remove()

end


local function CreateItemVgui( slot, p )
	local item = vgui.Create("lobby.InventoryItem", p)
	item:SetSize( 100,100 )
	item:SetSlotID( slot )
	item:UpdateContents()
	return item
end

function PANEL:FillSlots()
	for i=1, 20 do
		local item = CreateItemVgui( i, self )
		self.Grid:AddItem( item )
	end
end

function PANEL:SwitchItemSlots( slot1, slot2 )
	-- Network stuffs
	net.Start( "Lobby.ItemSwitch" )
	net.WriteInt( slot1, 8 )
	net.WriteInt( slot2, 8 )
	net.SendToServer()

	--self.Grid.Items[ slot1 ], self.Grid.Items[ slot2 ] = self.Grid.Items[ slot2 ], self.Grid.Items[ slot1 ]
	--self.Grid:InvalidateLayout()
end

function PANEL:UpdateContents( )
	--for k, panel in pairs( self.Grid.Items ) do
		--self.Grid.Items[ k ] = nil
		--panel:Remove()	
	--end
	--self.Grid:InvalidateLayout()
	
	--self:FillSlots()
	
	for i=1, 20 do
		if self.Grid.Items[ i ] then
			self.Grid.Items[ i ]:UpdateContents()
		end
	end

end

vgui.Register( "lobby.Inventory", PANEL, "Panel" )