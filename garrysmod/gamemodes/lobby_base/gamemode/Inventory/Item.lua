// Item

LobbyItem = { }
LobbyItem.Items = { }
LobbyItem._itemmeta = {
	Init = function( ) end,
	OnBuy = function( Item, _Player ) end,
	OnSell = function( Item, _Player ) end,
	CanPlayerBuy = function( Item, _Player ) return not Item.Base end,
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

	local item = {}
	if Table.Base then
		local base = LobbyItem.Get( Table.Base )
		if base then
			for k,v in pairs( base ) do
				if type(v) == "table" then
					item[k] = table.Copy(v)
				else
					item[k] = v
				end
			end
		else
			print( "[ITEM] Attempted to create Lobby Item with unknown base!" )
		end
	end
	
	for k,v in pairs( Table ) do
		item[k] = v
	end

	local Uni = item.UniqueName
	LobbyItem.Items[ simplehash(Uni)] = item
	item:Init();

end

function LobbyItem.Get( Name )

	if LobbyItem.Items[ simplehash(Name)] then
	
		return LobbyItem.Items[ simplehash(Name)]
		
	end

end

function LobbyItem.LoadSubFolder( Folder )

	local ItemFiles = file.Find( "Lobby_Base/gamemode/inventory/items/"..Folder.."*" , "LUA" )
	
	for k,v in pairs( ItemFiles ) do
		if SERVER then
			AddCSLuaFile( "Lobby_Base/gamemode/inventory/items/"..Folder.. v)
		end
		
		ITEM = table.Copy(LobbyItem._itemmeta)
		include( "Lobby_Base/gamemode/inventory/items/"..Folder .. v )
		LobbyItem.Add( table.Copy(ITEM) )
		ITEM = nil;
	end
	
end

function LobbyItem.CreateInstance( name , slot, extra, player )
	local item = table.Copy( LobbyItem.Get( name ) )

	if (slot >= 0 and slot <= 10 ) then
		if item:CanPlayerEquip( player) and item.OnEquip then
			item:OnEquip(player)
		end
	else
		if item:CanPlayerHolister( player ) and item.OnHolister then
			item:OnHolister(player)
		end
	end
	
	for _,hookname in pairs( item.Hooks ) do
		if item[hookname] then
			hook.Add( hookname, hookname ..":" .. tostring(slot).. ":".. item.UniqueName..":"..player:UniqueID(), function( ... ) item[hookname](item, ...) end)
		end
	end
	
	return item

end

function LobbyItem.DestroyInstance( ItemTable, player, slot )
	if (ItemTable.OnRemove) then ItemTable:OnRemove() end
	
	for _,hookname in pairs( ItemTable.Hooks ) do
		hook.Remove( hookname, hookname ..":" .. tostring(slot).. ":".. ItemTable.UniqueName..":"..player:UniqueID())
	end
end

function LobbyItem.LoadBases()
	local ItemFiles = file.Find( "Lobby_Base/gamemode/inventory/items/base/*" , "LUA" )
	
	for k,v in pairs( ItemFiles ) do
		if SERVER then
			AddCSLuaFile( "Lobby_Base/gamemode/inventory/items/base/" .. v )
		end
		
		ITEM = table.Copy(LobbyItem._itemmeta)
		include( "Lobby_Base/gamemode/inventory/items/base/" .. v )
		LobbyItem.Add( table.Copy(ITEM) )
		--print ( "[ITEM] Regestered " .. ITEM.Name .. " as item base" )
		ITEM = nil;
	end

end

LobbyItem.LoadBases()

LobbyItem.LoadSubFolder( "" ) -- Items/
LobbyItem.LoadSubFolder( "Hats/" )
LobbyItem.LoadSubFolder( "Halos/" )
LobbyItem.LoadSubFolder( "Playermodels/" )
LobbyItem.LoadSubFolder( "Trails/" )
LobbyItem.LoadSubFolder( "Playercolors/" )
LobbyItem.LoadSubFolder( "Weapons/" )
