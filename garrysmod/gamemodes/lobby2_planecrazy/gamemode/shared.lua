--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, 2015
	
-----------------------------------------------------------]]--

GM.Name					= "Lobby2: Plane Crazy"
GM.Author				= "James Swift"
GM.Email				= "n/a"
GM.Website				= ""
GM.AllowDownload			= false
GM.RemoveDefaultHUD			= false

GM.ServerID				= 6

DeriveGamemode( "lobby2_base" )

function GM:OnGamemodeLoaded( )

	self:LoadModules({
		"currency",
		"scoreboard",
		"location"
	})

end

TEAM_PLAYERS = 200

function GM:CreateTeams()


	team.SetUp( TEAM_PLAYERS, "Players", Color( 255, 255, 100 ), true )
	team.SetSpawnPoint( TEAM_PLAYERS, "info_player_start" )
	team.SetClass( TEAM_PLAYERS, { "Default" } )
	
	team.SetUp( TEAM_SPECTATOR, "Spectators", Color( 200, 200, 200 ), true )
	team.SetSpawnPoint( TEAM_SPECTATOR, "info_player_start" )
	team.SetClass( TEAM_SPECTATOR, { "Spectator" } )

end