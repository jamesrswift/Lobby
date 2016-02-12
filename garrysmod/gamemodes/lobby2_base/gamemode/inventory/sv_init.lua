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

include( "sv_player.lua" )
include( "sh_item.lua" )
include( "sh_shops.lua" )

AddCSLuaFile( "cl_ghost.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_player.lua" )
AddCSLuaFile( "sh_shops.lua" )
AddCSLuaFile( "sh_item.lua" )

AddCSLuaFile( "vgui/inventory.lua" )
AddCSLuaFile( "vgui/inventory_item.lua" )

--[[
AddCSLuaFile( "vgui/hateditor_modelviewer.lua" )
AddCSLuaFile( "vgui/hateditor.lua" )--]]

util.AddNetworkString("Lobby.UpdateInventory");
util.AddNetworkString("Lobby.UpdateOtherClientsInventory");
util.AddNetworkString("Lobby.ItemSwitch");


function GM.Inventory.ClientReady( Pl )

	Pl:InitItems()
	
end

net.Receive("Lobby.ItemSwitch", function(len,pl) pl:MoveItemToSlot( net.ReadInt(8), net.ReadInt(8) ) end)