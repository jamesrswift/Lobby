--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, 2015
	
-----------------------------------------------------------]]--

GM.Chat = GM.Chat or {}
GM.Chat.Icons = GM.Chat.Icons or {}

function GM.Chat.GetIcon( Icon )

	local GM = GM or gmod.GetGamemode( )
	
	if ( not GM.Chat.Icons[ Icon ] ) then
		GM.Chat.Icons[ Icon ] = Material( Icon )
	end
	
	return GM.Chat.Icons[ Icon ]

end

function GM:GetPlayerChatIcon( Pl )

	if ( not IsValid( Pl ) ) then return false end

	if ( self.NoChatIcons ) then return false end
	
	if ( Pl:GetNWBool( "bIsUndercover", false ) ) then
		--return self.Chat.GetIcon( "icon16/user.png" )
		return false
	end
	
	if ( Pl:IsDeveloper() ) then
		return self.Chat.GetIcon( "icon16/user_gray.png" )
	elseif ( Pl:IsSuperAdmin() ) then
		return self.Chat.GetIcon( "icon16/star.png" )
	elseif ( Pl:IsAdmin() ) then
		return self.Chat.GetIcon( "icon16/shield.png" )
	--elseif ( Pl:IsRespected() ) then
	--	return self.Chat.GetIcon( "icon16/heart.png" )
	end

	return false
	
end