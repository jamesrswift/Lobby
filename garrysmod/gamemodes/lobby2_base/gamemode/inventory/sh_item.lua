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
GM.Item.Instances = GM.Item.Instances or setmetatable( {}, {__mode = "k"} ) -- Weak keys (Players), remove instance on disconnect
GM.Item.Folder = GM.Item.Folder or "lobby2_base/gamemode/inventory/items/"

-- Enums
LOBBY_INV_CREATE = 1
LOBBY_INV_DESTROY = 2
LOBBY_INV_CUSTOM = 3

function GM.Item:Add( item )

	local GM = GM or gmod.GetGamemode()
	
	if item.Base then
	
		local base = self:Get( item.Base )
		if base then
		
			-- Derive from base
			setmetatable( item, {__index = base} )
			
		else
		
			GM:Log( "item", "Attempted to create Lobby Item (%s) with unknown base (%s)!", item.UniqueName, item.Base )
			GM:Print( "[item] Attempted to create Lobby Item (%s) with unknown base (%s)!", item.UniqueName, item.Base )
			
			return false
			
		end
		
		item.baseclass = base
		
	end

	self.Items[ item.UniqueName ] = item
	item:Init()
	
	GM:Print( "[item] Registered item (%s)!", item.UniqueName )

end

function GM.Item:Get( Name )

	return self.Items[ Name ] or false
	
end

function GM.Item:LoadSubFolder( Folder )

	local ItemFiles = file.Find( self.Folder .. Folder .. "*" , "LUA" )
	
	for k,v in pairs( ItemFiles ) do
	
		if ( SERVER ) then
			AddCSLuaFile( self.Folder .. Folder .. v)
		end
		
		ITEM = { }
		setmetatable( ITEM, {__index = self._itemmeta} )
		
		include( self.Folder .. Folder .. v )
		self:Add( ITEM )
		
		ITEM = nil
	end
	
end

function GM.Item:CreateInstance( name , slot, extra, player )

	if ( not self:Get( name ) ) then return end

	local item = { }
	setmetatable( item, {__index = self:Get( name ) } )
	
	if ( extra and string.len( extra ) > 0 and item.SetCustom ) then
		item:SetCustom( extra )
	end
	
	-- For Hooks
	if ( not self.Instances[ player ] ) then
		self.Instances[ player ] = { }
	end
	
	self.Instances[ player ][ slot ] = setmetatable( {}, {
		__index = item,
		__mode = "v" -- Weak reference
	})
	
	return item

end

function GM.Item:DestroyInstance( item, Pl, slot )

	if ( item.OnRemove ) then item:OnRemove( Pl ) end
	self.Instances[ item.m_ItemManagerInstanceKey ] = nil
	
end

function GM.Item:RunHook( hook, ... )

	local Return = { }
	local GarbageCollect = { }

	-- Run the hooks
	for Pl, inv in pairs( self.Instances ) do
	
		if ( not IsValid( Pl ) ) then
			table.insert( GarbageCollect, Pl )
			continue
		end
		
		for slot, item in pairs( inv ) do
		
			if ( item[ hook ] ) then
			
				Return = { item[hook]( item , ... ) }
				
			end
			
		end
	
	end
	
	-- Collect garbage
	for i, key in pairs( GarbageCollect ) do
		self.Instances[ key ] = nil
	end
	
	-- Return hook stuff
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

GM.Item:LoadSubFolder( "playermodels/" )