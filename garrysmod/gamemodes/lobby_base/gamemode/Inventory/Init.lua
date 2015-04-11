// inventory D:

LobbyInventory = { }

include( "HexSave.lua" )
include( "MySQL.lua" )
include( "Item.lua" )
include( "Shops.lua" )

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "Shops.lua" )
AddCSLuaFile( "Item.lua" )

util.AddNetworkString("Lobby.UpdateInventory");

hook.Add( "InitPostEntity", "SpawnShops" , function( )

	for k,v in pairs( GAMEMODE.Shops ) do
		local Shop = ents.Create( "snpc_shop" )
		Shop:SetAngles( v.Angles )
		Shop:SetPos( v.Position )
		if v.WorldModel then
			Shop:SetModel( v.WorldModel )
		end
		Shop:Spawn()
		Shop:Activate()
		Shop:SetShopID( k )
	end

end)

local _Player = FindMetaTable( "Player" )

function _Player:GiveItem( Name, slot, extra )
	local ID = tonumber( self:UniqueID() )
	slot = slot or #LobbyInventory.MySQL.GetUser( ID )
	extra = extra or ""
	
	if ( LobbyItem.Get( Name ) ) then
		
		LobbyInventory.MySQL.Cache[ ID ][slot] = { Name, extra }
		LobbyInventory.MySQL.Save( ID )
		
		hook.Call( "InventoryPlayerRecievedItem", GAMEMODE, self, Name, slot, extra )
		
	end
end

function _Player:GetItems( )
	local ID = tonumber( self:UniqueID() )
	return LobbyInventory.MySQL.GetUser( ID )
end

function _Player:UpdateClientInventory()

	net.Start( "Lobby.UpdateInventory" )
	net.WriteTable( LobbyInventory.MySQL.GetUser( self:UniqueID() ) )
	net.Send( self )
	
end

function _Player:InitItems()
	for slot,v in pairs( self:GetItems() ) do
		local name = v[1]
		local extra = v[2]
		
		local item = LobbyItem.Get( name )
		if item then
			if (slot >= 0 and slot <= 10 ) then
				item:OnEquip(self)
			else
				item:OnHolister(self)
			end
		end
		
	end
	
	self:UpdateClientInventory()
end

hook.Add( "PlayerInitialSpawn", "Inventory.SendInventory", function ( pl ) pl:InitItems() end )