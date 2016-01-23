--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, Chewgum, 2015
	
-----------------------------------------------------------]]--

GM.Name					= "Lobby2: Incoming"
GM.Author				= "James Swift, Chewgum"
GM.Email				= "n/a"
GM.Website				= ""
GM.AllowDownload			= false
GM.RemoveDefaultHUD			= false

GM.ServerID				= 5
GM.TeamBased			= true

DeriveGamemode( "lobby2_base" )

function GM:OnGamemodeLoaded( )

	self:LoadModules({
		"currency",
		"scoreboard",
		"location"
	})
	
	if ( CLIENT ) then
		print( "calling" )
		table.insert( self.HideElements, "CHudHealth" )
		table.insert( self.HideElements, "CHudBattery" )
	end

end

team.SetUp( 1, "Alive", Color( 255, 255, 100, 255 ) )
team.SetUp( 2, "Dead", Color( 100, 100, 50, 255 ) )