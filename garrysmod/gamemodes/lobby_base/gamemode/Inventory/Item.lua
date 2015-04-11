// Item

LobbyItem = { }
LobbyItem.Items = { }
LobbyItem._itemmeta = {
	ShopID 			= 0,
	Name 			= "",
	UniqueName 		= "",
	Description 	= "",
	Price			= 0,
	Model 			= "",
	Hooks			= {},

	OnBuy = function( Item, _Player ) end,
	OnSell = function( Item, _Player ) end,
	OnEquip = function ( Item, _Player ) end,
	OnHolister = function ( Item, _Player ) end,
	CanPlayerBuy = function( Item, _Player ) return true end,
	CanPlayerSell = function( Item, _Player ) return true end,
	CanPlayerTrade = function ( Item, _Player ) return true end,
	CanPlayerEquip = function ( Item, _Player ) return true end,
	CanPlayerHolister = function ( Item, _Player ) return true end
}


function simplehash(str)
	local hash = 1

	for i=1, #str do
		hash = (2 * hash) + string.byte(str, i)
	end
	hash = hash % 55565

	return hash
end

function LobbyItem.Add( Table )

	local Uni = Table.UniqueName
	LobbyItem.Items[ simplehash(Uni)] = Table

end

function LobbyItem.Get( Name )

	if LobbyItem.Items[ simplehash(Name)] then
	
		return LobbyItem.Items[ simplehash(Name)]
		
	end

end

function LobbyItem.Load( )

	local ItemFiles = file.Find( "Lobby_Base/gamemode/inventory/items/*" , "LUA" )
	
	for k,v in pairs( ItemFiles ) do
		if SERVER then
			AddCSLuaFile( "Lobby_Base/gamemode/inventory/items/" .. v )
		end
		
		ITEM = table.Copy(LobbyItem._itemmeta)
		include( "Lobby_Base/gamemode/inventory/items/" .. v )
		LobbyItem.Add( table.Copy(ITEM) )
		ITEM = nil;
	end
	
end

LobbyItem.Load( )
