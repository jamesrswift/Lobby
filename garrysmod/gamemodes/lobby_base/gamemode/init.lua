--[[

  __  __    ___ ___ _  _    ____ ___  __  __  __    ___  __ __ ___ 
 / _)/ _)  (   \  _) )( )  (_  _)  _)(  )(  \/  )  (__ \/  \  )__ \
( (_( (/\   ) ) ) _)\\//     )(  ) _)/__\ )    (   / __/ () )(/ __/
 \__)\__/  (___/___)(__)    (__)(___)_)(_)_/\/\_)  \___)\__/__)___)

	Copyright (c) James Swift, Alex Swift 2012
 
--]]


-- Extensions

include( "extensions/hex.lua" ); -- Very first thing to be loaded.
include( "extensions/mysql.lua" ); -- Saving
include( "extensions/json.lua" ); -- Serialize
include( "extensions/serial.lua" ); -- Ditto
include( "extensions/steamapi.lua" ); -- Useless piece of shit
include( "extensions/command.lua" ); --require( "LobbyCommand" );-- Sure, why not
include( "extensions/usermessage.lua" ); -- Saves me some trouble

-- MultiServer

include( "MultiServer/MultiServer.lua" ); -- Main server communications
include( "MultiServer/MySQL.lua" ); -- Packet builder
include( "MultiServer/GameServers.lua" ); -- Gamesystem abstraction

-- Inventory

include( "Inventory/Init.lua" )

-- AddCSLuaFile

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_hud.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("sh_modules.lua" )
AddCSLuaFile("sh_vgui.lua")
AddCSLuaFile("sh_player.lua")
AddCSLuaFile("sh_admin.lua")
AddCSLuaFile("chat/main.lua")
AddCSLuaFile("Admin/alltalk.lua")

-- Includes

include("shared.lua")
include("sh_resources.lua")
include("sh_modules.lua" )
include("sh_vgui.lua")
include("sh_player.lua")
include("sh_admin.lua" )
include("chat/main.lua")

-- Setting Up MySQL

hook.Add( "Initialize" , "StartDatabase" , function( )

	mysql.SetHost( "localhost" )
	mysql.SetPort( 3306 )
	mysql.SetUser( "root" )
	mysql.SetPass( "" )
	mysql.SetDBName( "Lobby" )
	mysql.SetHandle( function() end )
	
	print( "Attempting to connect to MySQL" )
	local connected = mysql.Connect()
	if connected then print( "Connection Established!" ) else
	print( "Connection Failed!" ) end

end)

-- Util I guess

function GetMaxSlots()
	local Slots = GetConVarNumber("sv_visiblemaxplayers")
	if Slots <= 1 then //If MaxSlots is not set, just adjust it to the true maxplayers
		return MaxPlayers()
	end
	return Slots
end
