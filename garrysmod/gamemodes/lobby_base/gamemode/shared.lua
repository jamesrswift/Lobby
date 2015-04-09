--[[

  __  __    ___ ___ _  _    ____ ___  __  __  __    ___  __ __ ___ 
 / _)/ _)  (   \  _) )( )  (_  _)  _)(  )(  \/  )  (__ \/  \  )__ \
( (_( (/\   ) ) ) _)\\//     )(  ) _)/__\ )    (   / __/ () )(/ __/
 \__)\__/  (___/___)(__)    (__)(___)_)(_)_/\/\_)  \___)\__/__)___)

	Copyright (c) James Swift, Alex Swift 2012
 
--]]


GM.Name				= "Lobby_Base"
GM.Author			= "Neo and Oss"
GM.Email			= "n/a"
GM.Website			= ""
GM.AllowDownload	= false
GM.RemoveDefaultHUD	= false

function GM:SetPlayerChatIcon( ply )

	if self.NoChatIcons then return false end
	if ply:GetNWBool( "bIsUndercover" ) then return "icon16/user.png" end
	if ply:IsAdmin() then return "icon16/star.png" end
	if ply:IsPrivAdmin() then return "icon16/shield.png" end
	if ply:IsVip() then return "icon16/heart.png" end
	return "icon16/user.png"

end