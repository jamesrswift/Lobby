--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, 2015
	
-----------------------------------------------------------]]--

GM.Name					= "Lobby2"
GM.Author				= "James Swift"
GM.Email				= "n/a"
GM.Website				= ""
GM.AllowDownload			= false
GM.RemoveDefaultHUD			= false

GM.ServerID				= 99

DeriveGamemode( "lobby2_base" )

function GM:OnGamemodeLoaded( )

	self:LoadModules({
		"currency",
		"scoreboard",
		"location",
		"seats",
		"size",
		"legs",
		"name"
	})

end
