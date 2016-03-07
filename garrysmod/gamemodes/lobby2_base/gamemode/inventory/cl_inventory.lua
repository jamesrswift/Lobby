--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, 2015
	
-----------------------------------------------------------]]--

AccessorFunc( GM.Inventory, "InventoryPanelIsShowing", "InventoryPanelShowing", FORCE_BOOL )

function GM.Inventory:InitializeInventoryPanel()

	self.InventoryPanel = vgui.Create( "lobby.Inventory" )
	self.InventoryPanel:SetSize( 1000, 200 ) 
	self.InventoryPanel:SetPos( (ScrW() - 1000)/2, -210 )
	
	-- Fill the inventory with current items
	local inv = LocalPlayer():GetItems( )
	if ( inv ) then
	
		local data = { }
	
		for slot, item in pairs( inv ) do
		
			table.insert( data, {
				Type = LOBBY_INV_CREATE,
				Extra = item.Extra
			})
		
		end
		
		self.InventoryPanel:UpdateContents( data )
	
	end
	
end

function GM.Inventory:PanelThink( )

	if ( not self.InventoryPanel ) then return end
	
	local x, y = self.InventoryPanel:GetPos();
	if self:GetInventoryPanelShowing() then
		self.InventoryPanel:SetPos( x , Lerp( 0.2, y, 0 ) )
	else
		self.InventoryPanel:SetPos( x , Lerp( 0.2, y, -210) )
	end
	
end

function GM.Inventory:BindPress( Pl, bind, bPressed )

	-- Remake the inventory as a profile page thing maybe, I dislike this GMTower idea remenant.

	if ( Pl ~= LocalPlayer() ) then return end
	
	if ( string.lower( bind ) == "+menu_context" ) then
	
		if ( not self.InventoryPanel ) then
			self:InitializeInventoryPanel()
		end
		
		self:SetInventoryPanelShowing( bPressed )
		gui.EnableScreenClicker( bPressed )
		
	elseif ( string.lower( bind ) == "-menu_context" ) then
	
		self:SetInventoryPanelShowing( false )
		gui.EnableScreenClicker( false )
		
	end

end
