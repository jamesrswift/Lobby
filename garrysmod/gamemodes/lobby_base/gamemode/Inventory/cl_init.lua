// cl_init

include( "cl_player.lua" )
include( "Item.lua" )
include( "shops.lua" )
include( "vgui/inventory.lua")
include( "vgui/inventory_item.lua")
include( "vgui/hateditor.lua")

LobbyInventory = { }
LobbyInventory.ClientInventory = {}
LobbyInventory.OtherClientsInventory = {}

usermessage.Hook( "ShopOpen" , function( um )

	local ShopID = um:ReadShort()

	local ShopWindow = vgui.Create( "lobby_shop" )
	ShopWindow:SetShop( ShopID )

end)

function debugshops( )

	local ShopWindow = vgui.Create( "lobby_shop" )
	ShopWindow:SetSize( ( ScrW()/4 ) * 3 , ( ScrH()/4 ) * 3 )
	ShopWindow:SetShop( 1 )
	
end

function LobbyInventory.GetInventory()
	return LobbyInventory.ClientInventory;
end

function LobbyInventory.UpdateInventory(data)
	for slot,v in pairs( LobbyInventory.ClientInventory ) do
		if (v[3]) then
			LobbyItem.DestroyInstance(v[3], LocalPlayer() )
		end
	end
	LobbyInventory.ClientInventory = data
	for slot,v in pairs( LobbyInventory.ClientInventory ) do
		v[3] = table.Copy( LobbyItem.Get( v[1] ) )
		local item = v[3]
		
		if item.SetCustom then item:SetCustom( v[2] ) end
		
		if (slot >= 0 and slot <= 10 ) then
			if item:CanPlayerEquip( LocalPlayer() ) and item.OnEquip then
				item:OnEquip(LocalPlayer())
			end
		else
			if item:CanPlayerHolister( LocalPlayer() ) and item.OnHolister then
				item:OnHolister(LocalPlayer())
			end
		end
		
		for _,hookname in pairs( item.Hooks ) do
			if item[hookname] then
				hook.Add( hookname, hookname ..":" .. item.UniqueName..":"..LocalPlayer():UniqueID(), function( ... ) item[hookname](v[3], ...) end)
			end
		end
	end
	
	if LobbyInventory.InventoryPanel then
		LobbyInventory.InventoryPanel:UpdateContents()
	end
end


function LobbyInventory.UpdateOtherClientsInventory(data)
	for _Player, Inv in pairs( LobbyInventory.OtherClientsInventory ) do
		for slot,v in pairs( Inv ) do
			if (v[3]) then
				LobbyItem.DestroyInstance(v[3], _Player)
			end
		end
	end
	LobbyInventory.OtherClientsInventory = data
	for _Player, Inv in pairs( LobbyInventory.OtherClientsInventory ) do
		if _Player then
			for slot,v in pairs( Inv ) do
				v[3] = LobbyItem.CreateInstance( v[1], slot, v[2] , _Player )
			end
		end
	end
end

net.Receive("Lobby.UpdateInventory", function()
	local data = net.ReadTable();
	LobbyInventory.UpdateInventory(data)
end)

net.Receive("Lobby.UpdateOtherClientsInventory", function()
	local data = net.ReadTable();
	LobbyInventory.UpdateOtherClientsInventory(data)
end)

hook.Add( "InitPostEntity", "LobbyInventory.PlayerIsReady", function()
	net.Start( "Lobby.InventoryClientReady" )
	net.SendToServer()
end)

-- Inventory

AccessorFunc( LobbyInventory, "InventoryPanelIsShowing", "InventoryPanelShowing", FORCE_BOOL )


function LobbyInventory.InitializeInventoryPanel()
	LobbyInventory.InventoryPanel = vgui.Create( "lobby.Inventory" );
	LobbyInventory.InventoryPanel:SetSize( 1000, 200 ) 
	LobbyInventory.InventoryPanel:SetPos( (ScrW() - 1000)/2, -210 )
	LobbyInventory.InventoryPanel:FillSlots()
end

hook.Add( "Think" , "Radio.ShowRadioPanel", function()
	if (!LobbyInventory.InventoryPanel) then return end
	local x, y = LobbyInventory.InventoryPanel:GetPos();
	if LobbyInventory:GetInventoryPanelShowing() then
		LobbyInventory.InventoryPanel:SetPos( x , Lerp( 0.2, y, 0 ) )
	else
		LobbyInventory.InventoryPanel:SetPos( x , Lerp( 0.2, y, -210) )
	end
end)

concommand.Add( "+inventory_show", function() if (!LobbyInventory.InventoryPanel) then LobbyInventory.InitializeInventoryPanel() end LobbyInventory:SetInventoryPanelShowing(true) gui.EnableScreenClicker( true ) end)
concommand.Add( "-inventory_show", function() LobbyInventory:SetInventoryPanelShowing(false) gui.EnableScreenClicker( false ) end)

