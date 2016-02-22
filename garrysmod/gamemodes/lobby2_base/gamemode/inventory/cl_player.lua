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

function _Player:GetItems( )
	
	local GM = GM or gmod.GetGamemode( )
	
	GM.Inventory.ClientInventories[self] = GM.Inventory.ClientInventories[self] or { }
	return GM.Inventory.ClientInventories[self]
	
end

function _Player:GetItem( slot )

	local items = self:GetItems()
	if not items then return false end
	
	return items[slot] or false

end