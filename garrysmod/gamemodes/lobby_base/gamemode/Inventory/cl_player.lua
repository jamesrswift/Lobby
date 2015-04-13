local _Player = FindMetaTable("Player")

function _Player:GetItems( )
	if self == LocalPlayer() then return LobbyInventory.ClientInventory end
	return LobbyInventory.OtherClientsInventory[self] or false
end

function _Player:GetItem( slot )
	local items = self:GetItems()
	if not items then return false end
	return items[slot] or false
end
