// inventory D:

LobbyInventory = { }

include( "HexSave.lua" )
include( "MySQL.lua" )
include( "sv_player.lua" )
include( "Item.lua" )
include( "Shops.lua" )

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_player.lua" )
AddCSLuaFile( "vgui/inventory.lua" )
AddCSLuaFile( "vgui/inventory_item.lua" )
AddCSLuaFile( "vgui/hateditor_modelviewer.lua" )
AddCSLuaFile( "vgui/hateditor.lua" )
AddCSLuaFile( "Shops.lua" )
AddCSLuaFile( "Item.lua" )

util.AddNetworkString("Lobby.InventoryClientReady");
util.AddNetworkString("Lobby.UpdateInventory");
util.AddNetworkString("Lobby.UpdateOtherClientsInventory");
util.AddNetworkString("Lobby.ItemSwitch");

hook.Add( "InitPostEntity", "SpawnShops" , function( )

	for k,v in pairs( GAMEMODE.Shops ) do
		local Shop = ents.Create( "snpc_shop" )
		Shop:SetAngles( v.Angles )
		Shop:SetPos( v.Position )
		if v.WorldModel then
			Shop:SetModel( v.WorldModel )
		end
		Shop:Spawn()
		Shop:SetShopID( k )
		print( "spawning shop" )
	end

end)
net.Receive("Lobby.InventoryClientReady", function(len,pl) pl:InitItems() end)

net.Receive("Lobby.ItemSwitch", function(len,pl) pl:MoveItemToSlot( net.ReadInt(8), net.ReadInt(8) ) end)