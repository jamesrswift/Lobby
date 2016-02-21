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
	local data = self:GetData()
	
	slot = slot or self:GetNextAvailableSlot( )
	extra = extra or ""
	
	if ( GM.Item:Get( Name ) and data and slot ) then
		
		data.inventory[slot] = { Name = Name, Extra = extra, Instance = GM.Item:CreateInstance( Name , slot, extra, self ) }
		self:SaveData( )

		GM.Item:SendUpdate( self, {
			[slot] = {
				Type = LOBBY_INV_CREATE,
				Name = Name,
				Extra = Extra
			}
		})
		
		hook.Run( "InventoryPlayerRecievedItem", self, Name, slot, extra )
		
		return true
		
	end
	
	return false
	
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

function _Player:InitItems()

	local GM = GM or gmod.GetGamemode( )
	local net_data = { }

	for slot, item in pairs( self:GetItems() ) do
		
		item.Instance = GM.Item:CreateInstance( item.Name , slot, item.Extra, self )
		
		net_data[slot] = {
			Type = LOBBY_INV_CREATE,
			Name = Name,
			Extra = Extra
		}

	end
	
	GM.Item:SendUpdate( self, net_data )

end

function _Player:BuyItem( name, slot, extra )

	local GM = GM or gmod.GetGamemode()
	slot = slot or self:GetNextAvailableSlot( )
	
	local item = GM.Item:Get( name )
	if ( item and slot ) then
	
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
		
		GM.Item:SendUpdate( self, {
			[slot] = {
				Type = LOBBY_INV_DESTROY,
				Name = Name,
				Extra = Extra
			}
		})
		
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
	
		item.Extra = custom
		item.Instance:SetCustom( custom )
		self:SaveData( )
		
		GM.Item:SendUpdate( self, {
			[slot] = {
				Type = LOBBY_INV_CUSTOM,
				Name = Name,
				Extra = custom
			}
		})
		
	end
	
end

function _Player:GetItemCustom( slot )

	local item = self:GetItem( slot )
	if item then return item.Extra end
	
end