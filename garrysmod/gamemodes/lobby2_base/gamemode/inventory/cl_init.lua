--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, 2015
	
-----------------------------------------------------------]]--

GM.Inventory = GM.Inventory or { }
GM.Inventory.ClientInventory = {}
GM.Inventory.OtherClientsInventory = {}

include( "cl_ghost.lua" )
include( "cl_player.lua" )
include( "sh_item.lua" )
include( "sh_shops.lua" )

AccessorFunc( GM.Inventory, "InventoryPanelIsShowing", "InventoryPanelShowing", FORCE_BOOL )

function GM.Inventory:GetInventory()

	return self.ClientInventory
	
end

function GM.Inventory:UpdateInventory(data)

	local GM = GM or gmod.GetGamemode()

	for slot,item in pairs( self.ClientInventory ) do
		if ( item.Instance ) then
			GM.Item:DestroyInstance(item.Instance, LocalPlayer(), slot )
		end
	end
	
	self.ClientInventory = data
	for slot,item in pairs( self.ClientInventory ) do
		item.Instance = LobbyItem.CreateInstance( item.ID, slot, item.Custom, LocalPlayer() )
	end
	
	if self.InventoryPanel then
		self.InventoryPanel:UpdateContents()
	end
	
end


function GM.Inventory:UpdateOtherClientsInventory(data)

	for _Player, Inv in pairs( LobbyInventory.OtherClientsInventory ) do
		for slot,item in pairs( Inv ) do
			if ( item.Instance ) then
				GM.Item:DestroyInstance(item.Instance, _Player, slot )
			end
		end
	end
	
	LobbyInventory.OtherClientsInventory = data
	for _Player, Inv in pairs( LobbyInventory.OtherClientsInventory ) do
		if ( _Player and IsValid( _Player ) and _Player:IsPlayer() ) then
			for slot,item in pairs( Inv ) do
				item.Instance = LobbyItem.CreateInstance( item.ID, slot, item.Custom, LocalPlayer() )
			end
		end
	end
	
end

net.Receive("Lobby.UpdateInventory", function()
	local GM = GM or gmod.GetGamemode( )
	GM.Inventory:UpdateInventory(net.ReadTable() or {})
end)

net.Receive("Lobby.UpdateOtherClientsInventory", function()
	local GM = GM or gmod.GetGamemode( )
	GM.Inventory:UpdateOtherClientsInventory(net.ReadTable() or {})
end)

hook.Add( "InitPostEntity", "LobbyInventory.PlayerIsReady", function()
	net.Start( "Lobby.InventoryClientReady" )
	net.SendToServer()
end)


function GM.Inventory:InitializeInventoryPanel()

	self.InventoryPanel = vgui.Create( "lobby.Inventory" );
	self.InventoryPanel:SetSize( 1000, 200 ) 
	self.InventoryPanel:SetPos( (ScrW() - 1000)/2, -210 )
	self.InventoryPanel:FillSlots()
	
end

function GM.Inventory:Think( )

	self.Ghost:UpdateGhostEntity()

	if ( not self.InventoryPanel ) then return end
	
	local x, y = GM.Inventory.InventoryPanel:GetPos();
	if self:GetInventoryPanelShowing() then
		self.InventoryPanel:SetPos( x , Lerp( 0.2, y, 0 ) )
	else
		self.InventoryPanel:SetPos( x , Lerp( 0.2, y, -210) )
	end
	
end

concommand.Add( "+inventory_show", function() local GM = GM or gmod.GetGamemode() if (not GM.Inventory.InventoryPanel) then GM.Inventory:InitializeInventoryPanel() end GM.Inventory:SetInventoryPanelShowing(true) gui.EnableScreenClicker( true ) end)
concommand.Add( "-inventory_show", function() local GM = GM or gmod.GetGamemode() GM.Inventory:SetInventoryPanelShowing(false) gui.EnableScreenClicker( false ) end)
