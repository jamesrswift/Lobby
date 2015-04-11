// cl_init

include( "Item.lua" )
include( "shops.lua" )

LobbyInventory = { }
LobbyInventory.ClientInventory = {}

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
end

net.Receive("Lobby.UpdateInventory", function()
	local data = net.ReadTable();
	LobbyInventory.UpdateInventory(data)
end)
