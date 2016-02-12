--[[-----------------------------------------------------------
	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝
	
	Copyright (c) James Swift, 2015
	
-----------------------------------------------------------]]--


GM.Item = GM.Item or { }
GM.Item.Items = GM.Item.Items or { }

GM.Item._itemmeta = {
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

function GM.Item:Add( Table )

	local GM = GM or gmod.GetGamemode()
	local item = {}
	
	if Table.Base then
	
		local base = self.Get( Table.Base )
		if base then
		
			for k,v in pairs( base ) do
				if type(v) == "table" then
					item[k] = table.Copy(v)
				else
					item[k] = v
				end
			end
			
		else
			GM:Log( "item", "Attempted to create Lobby Item (%s) with unknown base (%s)!", Table.UniqueName, Table.Base )
		end
		
	end
	
	for k,v in pairs( Table ) do
		item[k] = v
	end

	local Uni = item.UniqueName
	self.Items[ Uni ] = item
	
	item:Init();

end

function GM.Item:Get( Name )

	return self.Items[ Name ] or false
	
end

function GM.Item:LoadSubFolder( Folder )

	local ItemFiles = file.Find( "lobby_base2/gamemode/inventory/items/" .. Folder .. "*" , "LUA" )
	
	for k,v in pairs( ItemFiles ) do
	
		if ( SERVER ) then
			AddCSLuaFile( "lobby_base2/gamemode/inventory/items/"..Folder.. v)
		end
		
		ITEM = table.Copy(self._itemmeta)
		
		include( "lobby_base2/gamemode/inventory/items/" .. Folder .. v )
		self:Add( table.Copy(ITEM) )
		
		ITEM = nil;
	end
	
end

function GM.Item:CreateInstance( name , slot, extra, player )

	local item = table.Copy( self:Get( name ) )

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
	
	if ( string.len( extra ) > 0 and item.SetCustom ) then
		item:SetCustom( extra )
	end
	
	return item

end

function GM.Item:DestroyInstance( ItemTable, player, slot )

	if (ItemTable.OnRemove) then ItemTable:OnRemove() end
	
	for _,hookname in pairs( ItemTable.Hooks ) do
		hook.Remove( hookname, hookname ..":" .. tostring(slot).. ":".. ItemTable.UniqueName..":"..player:UniqueID())
	end
	
end

function GM.Item:LoadBases()
	local ItemFiles = file.Find( "Lobby_Base/gamemode/inventory/items/base/*" , "LUA" )
	
	for k,v in pairs( ItemFiles ) do
		if SERVER then
			AddCSLuaFile( "Lobby_Base/gamemode/inventory/items/base/" .. v )
		end
		
		ITEM = table.Copy(self._itemmeta)
		
		include( "Lobby_Base/gamemode/inventory/items/base/" .. v )
		self:Add( table.Copy(ITEM) )
		
		ITEM = nil;
	end

end

GM.Item:LoadBases()

GM.Item:LoadSubFolder( "" )
GM.Item:LoadSubFolder( "Hats/" )
GM.Item:LoadSubFolder( "Halos/" )
GM.Item:LoadSubFolder( "Playermodels/" )
GM.Item:LoadSubFolder( "Trails/" )
GM.Item:LoadSubFolder( "Playercolors/" )
GM.Item:LoadSubFolder( "Weapons/" )