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
GM.Item._itemmeta = GM.Item._itemmeta or {}
GM.Item.Instances = GM.Item.Instances or { }

-- Enums
LOBBY_INV_CREATE = 1
LOBBY_INV_DESTROY = 2
LOBBY_INV_CUSTOM = 3

function GM.Item:Add( item )

	local GM = GM or gmod.GetGamemode()
	
	if item.Base then
	
		local base = self.Get( item.Base )
		if base then
		
			setmetatable( item, {__index = base} )
		else
			GM:Log( "item", "Attempted to create Lobby Item (%s) with unknown base (%s)!", item.UniqueName, item.Base )
		end
		
	end

	self.Items[ item.UniqueName ] = item
	item:Init()

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
		
		ITEM = { }
		setmetatable( ITEM, {__index = self._itemmeta} )
		
		include( "lobby_base2/gamemode/inventory/items/" .. Folder .. v )
		self:Add( ITEM )
		
		ITEM = nil
	end
	
end

function GM.Item:CreateInstance( name , slot, extra, player )

	local item = { }
	setmetatable( item, {__index = self:Get( name ) } )
	
	if ( string.len( extra ) > 0 and item.SetCustom ) then
		item:SetCustom( extra )
	end
	
	-- For Hooks
	local key = table.insert( self.Instances, item )
	item.m_ItemManagerInstanceKey = key
	
	return item

end

function GM.Item:DestroyInstance( item, Pl, slot )

	if ( item.OnRemove ) then item:OnRemove( Pl ) end
	self.Instances[ item.m_ItemManagerInstanceKey ] = nil
	
end

function GM.Item:RunHook( hook, ... )

	local Return = { }

	for m_ItemManagerInstanceKey, item in pairs( self.Instances ) do
	
		if ( item[ hook ] ) then
		
			Return = { item[hook]( item , ... ) }
			
		end
	
	end
	
	return unpack( Return )

end

function GM.Item:SendUpdate( Pl, data )

	if ( not SERVER ) then return end

	net.Start( "Lobby.UpdateInventory" )
		net.WriteEntity( Pl )
		net.WriteTable( data )
	net.Broadcast( )
	
end

-- Load
GM.Item:LoadSubFolder( "base/" )

GM.Item:LoadSubFolder( "" )
GM.Item:LoadSubFolder( "Hats/" )
GM.Item:LoadSubFolder( "Halos/" )
GM.Item:LoadSubFolder( "Playermodels/" )
GM.Item:LoadSubFolder( "Trails/" )
GM.Item:LoadSubFolder( "Playercolors/" )
GM.Item:LoadSubFolder( "Weapons/" )