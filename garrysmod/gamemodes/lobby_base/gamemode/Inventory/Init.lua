// inventory D:

LobbyInventory = { }

include( "HexSave.lua" )
include( "MySQL.lua" )
include( "Item.lua" )
include( "Shops.lua" )

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "Shops.lua" )
AddCSLuaFile( "Item.lua" )

util.AddNetworkString("Lobby.InventoryClientReady");
util.AddNetworkString("Lobby.UpdateInventory");
util.AddNetworkString("Lobby.UpdateOtherClientsInventory");

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
	slot = slot or #LobbyInventory.MySQL.GetUser( ID ) + 1
	extra = extra or ""
	
	if ( LobbyItem.Get( Name ) ) then
		
		LobbyInventory.MySQL.Cache[ ID ][slot] = { Name, extra }
		LobbyInventory.MySQL.Save( ID )
		self:UpdateClientInventory()
		
		for k,v in pairs( player.GetAll() ) do
			v:UpdateOtherClientsInventory()
		end
		
		LobbyInventory.MySQL.Cache[ ID ][slot][3] = LobbyItem.CreateInstance( Name , slot, extra, self )
		
		hook.Call( "InventoryPlayerRecievedItem", GAMEMODE, self, Name, slot, extra )
		
	end
end

function _Player:GetItems( )
	local ID = tonumber( self:UniqueID() )
	return LobbyInventory.MySQL.GetUser( ID )
end

function _Player:UpdateClientInventory()

	net.Start( "Lobby.UpdateInventory" )
	local inv = LobbyInventory.MySQL.GetUser( tonumber(self:UniqueID()) )
	local data = {}
	for k,v in pairs( inv ) do
		data[k] = {v[1],v[2]}
	end
	net.WriteTable( data )
	net.Send( self )
	
end

function _Player:UpdateOtherClientsInventory()

	net.Start( "Lobby.UpdateOtherClientsInventory" )
	local inv = LobbyInventory.MySQL.GetUser( tonumber(self:UniqueID()) )
	local data = {}
	for plID, inv in pairs( LobbyInventory.MySQL.Cache ) do
		local _player = player.GetByUniqueID( tostring(plID) )
		if _player and _player != self then -- Don't resend to the client his inventory, only send others
			data[_player] = {}
			for k,v in pairs( inv ) do
				data[_player][k] = {v[1],v[2]}
			end
		end
	end
	net.WriteTable( data )
	net.Send( self )
	
end

function _Player:InitItems()
	for slot,v in pairs( self:GetItems() ) do
		local name = v[1]
		local extra = v[2]
		
		v[3] = LobbyItem.CreateInstance( name , slot, extra, self )
		
	end
	
	self:UpdateClientInventory()
	for k,v in pairs( player.GetAll() ) do
		v:UpdateOtherClientsInventory()
	end
end

function _Player:BuyItem( name, slot, extra )
	local ID = tonumber( self:UniqueID() )
	slot = slot or #LobbyInventory.MySQL.GetUser( ID ) + 1
	extra = extra or ""
	local item = LobbyItem.Get( name )
	if item then
		local price = item.Price
		if self:CanAfford( price ) then
			self:TakeMoney( price )
			self:GiveItem( name, slot, extra )
			return true
		end
	end
	return false
end

net.Receive("Lobby.InventoryClientReady", function(len,pl) pl:InitItems() end)