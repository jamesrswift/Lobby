--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, 2015
	
-----------------------------------------------------------]]--

GM.Inventory = GM.Inventory or { }
GM.Inventory.ClientInventories = {}

include( "cl_ghost.lua" )
include( "cl_player.lua" )
include( "cl_trailmanager.lua" )
include( "cl_inventory.lua" )
include( "sh_item.lua" )
include( "sh_item_meta.lua" )
include( "sh_shops.lua" )

include( "vgui/inventory.lua" )
include( "vgui/inventory_item.lua" )

function GM.Inventory:GetInventory()

	return self.ClientInventories
	
end

function GM.Inventory:UpdateInventory( Pl,  data)

	local GM = GM or gmod.GetGamemode()
	
	if ( not self:GetInventory()[ Pl ] ) then self:GetInventory()[ Pl ] = { } end
	
	for slot, info in pairs( data ) do
	
		if ( info.Type == LOBBY_INV_CREATE ) then
		
			self:GetInventory()[ Pl ][ slot ] = {
				Name = info.Name,
				Extra = info.Extra,
				Instance = GM.Item:CreateInstance( info.Name, slot, info.Extra, Pl )
			}
		
		elseif ( info.Type == LOBBY_INV_DESTROY ) then
			
			GM.Item:DestroyInstance( self:GetInventory()[ Pl ][ slot ].Instance, Pl, slot )
			self:GetInventory()[ Pl ][ slot ] = nil
			
		elseif ( info.Type == LOBBY_INV_CUSTOM ) then
			
			self:GetInventory()[ Pl ][ slot ].Extra = info.Extra
			self:GetInventory()[ Pl ][ slot ].Instance:SetCustom( info.Extra )
			
		end
	
	end

	if ( self.InventoryPanel and Pl == LocalPlayer() ) then
		self.InventoryPanel:UpdateContents( data )
	end
	
end

function GM.Inventory:CreateInventoryItemElement( slot, parent )

	local Inv = self:GetInventory()[ LocalPlayer() ]
	if ( not Inv ) then return end
	
	local item = Inv[ slot ]
	if ( not item ) then return end
	
	local Element = vgui.Create( "Lobby.InventoryItem", parent )
	Element:SetData({
		Name = item.Name,
		Model = item.Instance.Model,
		Skin = item.Instance.Skin,
		Material = item.Instance.Material,
		Description = item.Instance.Description,
		SetupMenu = item.Instance.SetupMenu,
		Instance = item.Instance,
		NoScroll = item.Intance.NoScroll
	})
	
	return Element
	
end


net.Receive("Lobby.UpdateInventory", function()

	local GM = GM or gmod.GetGamemode( )
	GM.Inventory:UpdateInventory( net.ReadEntity(), net.ReadTable() or {} )
	
end)

function GM.Inventory:Think( )

	self.Ghost:UpdateGhostEntity()
	self.TrailManager:Think( )
	self:PanelThink( )
	
end
