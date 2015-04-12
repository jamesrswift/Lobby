// cl_init

include( "Item.lua" )
include( "shops.lua" )

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
	LobbyInventory.ClientInventory = data
	for slot,v in pairs( LobbyInventory.ClientInventory ) do
		v[3] = table.Copy( LobbyItem.Get( v[1] ) )
		local item = v[3]
		
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
end


function LobbyInventory.UpdateOtherClientsInventory(data)
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
