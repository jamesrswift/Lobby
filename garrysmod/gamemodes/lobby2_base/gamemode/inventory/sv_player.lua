--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, 2015
	
-----------------------------------------------------------]]--


local _Player = FindMetaTable("Player")

function _Player:GiveItem( Name, slot, extra )

	local GM = GM or gmod.GetGamemode( )

	local ID = tonumber( self:UniqueID() )
	slot = slot or self:GetNextAvailableSlot( )
	extra = extra or ""
	
	if ( GM.Item:Get( Name ) ) then
		
		hook.Run( "InventoryPlayerRecievedItem", self, Name, slot, extra )
		
	end
end

function _Player:GetItems( )

	local data = self:GetData( )
	if ( data ) then
		return data.inventory or { }
	end
	
end

function _Player:GetItem( slot )

	return self:GetItems()[slot] or false

end

function _Player:UpdateClientInventory()

	net.Start( "Lobby.UpdateInventory" )

	local data = {}
	
	for slot, item in pairs( self:GetItems() ) do
		data[slot] = { ID = item.ID, Custom = item.Custom }
	end
	
	net.WriteTable( data )
	net.Send( self )
	
end

function _Player:UpdateOtherClientsInventory()

	net.Start( "Lobby.UpdateOtherClientsInventory" )
	
	local data = {}
	
	for k, Pl in pairs ( player.GetAll() ) do
	
		if ( Pl and IsValid( Pl ) and Pl:IsPlayer() and Pl ~= self ) then
			data[ Pl ] = { }
			for slot, item in pairs( Pl:GetItems() ) do
				data[ Pl ][ slot ] = { ID = item.ID, Custom = item.Custom }
			end
			
		end
		
	end
	
	net.WriteTable( data )
	net.Send( self )
	
end

function _Player:InitItems()

	local GM = GM or gmod.GetGamemode( )

	for slot, item in pairs( self:GetItems() ) do
		
		item.Instance = GM.Item:CreateInstance( item.ID , slot, item.Custom, self )
		
	end
	
	self:UpdateClientInventory()
	for k,v in pairs( player.GetAll() ) do
		v:UpdateOtherClientsInventory()
	end

end

function _Player:BuyItem( name, slot, extra )

	local GM = GM or gmod.GetGamemode()
	slot = slot or self:GetNextAvailableSlot( )
	
	local item = GM.Item:Get( name )
	if item then
	
		local price = item.Price
		
		if self:CanAfford( price ) then
		
			self:TakeMoney( price )
			self:GiveItem( name, slot, extra or "" )
			return true
			
		end
		
	end
	
	return false
	
end

function _Player:DestroyItem( slot )

	local GM = GM or gmod.GetGamemode( )
	local item = self:GetItem( slot )
	
	if item then
	
		GM.Item:DestroyInstance( item.Instance, self, slot )
		
		self:GetData().inventory[slot] = nil
		self:SaveData()
		
		self:UpdateClientInventory()
		for k,v in pairs( player.GetAll() ) do
			v:UpdateOtherClientsInventory()
		end
		
	end
	
end

function _Player:MoveItemToSlot( slot1, slot2 )

	
end

function _Player:GetNextAvailableSlot( )

	for i=1, 50 do
		if ( not self:GetItem( i ) ) then return i end
	end
	
	return false
	
end

function _Player:SetItemCustom( slot, custom )

	local item = self:GetItem( slot )
	if item then
	
		item.Custom = custom
		item.Instance:SetCustom( custom )
		self:SaveData( )
		
		self:UpdateClientInventory()
		for k,v in pairs( player.GetAll() ) do
			v:UpdateOtherClientsInventory()
		end
		
	end
	
end

function _Player:GetItemCustom( slot )

	local item = self:GetItem( slot )
	if item then return item.Custom end
	
end