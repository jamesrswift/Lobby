--[[

  __  __    ___ ___ _  _    ____ ___  __  __  __    ___  __ __ ___ 
 / _)/ _)  (   \  _) )( )  (_  _)  _)(  )(  \/  )  (__ \/  \  )__ \
( (_( (/\   ) ) ) _)\\//     )(  ) _)/__\ )    (   / __/ () )(/ __/
 \__)\__/  (___/___)(__)    (__)(___)_)(_)_/\/\_)  \___)\__/__)___)

	Copyright (c) James Swift, Alex Swift 2012

--]]


AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("calcview.lua")

include("shared.lua")
include("sv_hooks.lua")
include("sv_player.lua")
include("GameStates.lua")

hook.Add( "DatabaseConnect" , "SetUpGameServer" , function( )
	GAMEMODE:SetServerState( STATE_PLAYING )
	GAMEMODE:SetServerMessage( "Lobby" )
end)

function GM:PlayerLoadout( pl )
	return true
end

function GM:EntityTakeDamage( ent, inflictor, attacker, amount, dmginfo  ) 
	if ent:IsNPC() then
		dmginfo:ScaleDamage( 0.0 )
	end
end
