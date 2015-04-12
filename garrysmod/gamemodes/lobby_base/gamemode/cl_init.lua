--[[

  __  __    ___ ___ _  _    ____ ___  __  __  __    ___  __ __ ___ 
 / _)/ _)  (   \  _) )( )  (_  _)  _)(  )(  \/  )  (__ \/  \  )__ \
( (_( (/\   ) ) ) _)\\//     )(  ) _)/__\ )    (   / __/ () )(/ __/
 \__)\__/  (___/___)(__)    (__)(___)_)(_)_/\/\_)  \___)\__/__)___)

	Copyright (c) James Swift, Alex Swift 2012
 
--]]
 
 
include("shared.lua")
include("sh_modules.lua" )
include("sh_vgui.lua")
include("sh_modules.lua")
include("sh_player.lua")
include("cl_hud.lua")
include("inventory/cl_init.lua")
include("sh_admin.lua")
include("chat/main.lua")
include("Admin/alltalk.lua")


CurMap = game.GetMap()

hook.Add("UpdateAnimation", "Breathing", function(ply)
	ply:SetPoseParameter("breathing", 0.2)
end)

function GM:AllowModel( ply, model )
	return false
end

function GM:ChatText( playerindex, playername, text, filter )
	return false
end

function GM:AllowChatIcons( linedata )
	return true
end