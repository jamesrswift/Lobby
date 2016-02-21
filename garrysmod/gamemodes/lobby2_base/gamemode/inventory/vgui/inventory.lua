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

	self.m_BGColor = Color(0,0,0,150)

	self:SetSize( 1000, 200 ) 
	self:SetPos( (ScrW() - 1000)/2, -210 )
	
	-- Setup for DragNDrop
	self:Receiver( 'LobbyInventoryItem', self.OnRecieve, {} )
	self.RowHeight = 100
	self.ColWidth = 100
	
	self.Contents = { }
	
end

function PANEL:Paint( w, h )

	surface.SetDrawColor( self.m_BGColor )
	surface.DrawRect( 0, 0, w, h )
	surface.DrawRect( 0, 0, w, h/2 )
	
end

function PANEL:CalculateNearestSlot( mx, my )

	return ( mx - mx%self.ColWidth ), ( my - my%self.RowHeight )

end

function PANEL:OnRecieve( tDroppedPanels, isDropped, menuIndex, mx, my )

	local x, y = self:CalculateNearestSlot( mx, my )

	for k, pnl in pairs( tDroppedPanels ) do
	
		pnl:SetParent( self )
		pnl:SetPos( x, y )
	
	end
	

end

function PANEL:UpdateContents( data )
	
	local GM = GM or gmod.GetGamemode( )
	
	for slot, info in pairs( data ) do
		
		if ( info.Type == LOBBY_INV_CREATE ) then
			
			local Item = GM.Inventory:CreateInventoryItemElement( slot, self )
			
			local Col = slot % (self:GetWidth( )/self.ColWidth)
			local row = ( slot - Col ) % (self:GetHeight( )/self.RowHeight)
			
			Item:SetPos( Col * self.ColWidth, row * self.RowHeight )
			
			self.Contents[ slot ] = Item
			
		elseif ( info.Type == LOBBY_INV_DESTROY ) then
			
			self.Contents[ slot ]:Remove()
			self.Contents[ slot ] = nil
			
		elseif ( info.Type == LOBBY_INV_CUSTOM ) then
			
			self.Contents[ slot ]:SetCustom( info.Extra )
			
		end
	
	end
	
end

vgui.Register( "lobby.Inventory", PANEL, "Panel" )