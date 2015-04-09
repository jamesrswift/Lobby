--[[

  __  __    ___ ___ _  _    ____ ___  __  __  __    ___  __ __ ___ 
 / _)/ _)  (   \  _) )( )  (_  _)  _)(  )(  \/  )  (__ \/  \  )__ \
( (_( (/\   ) ) ) _)\\//     )(  ) _)/__\ )    (   / __/ () )(/ __/
 \__)\__/  (___/___)(__)    (__)(___)_)(_)_/\/\_)  \___)\__/__)___)

	Copyright (c) James Swift, Alex Swift 2012
 
 --]]


GM.Name     		= "Lobby: Main"
GM.Author   		= "James and Alex"
GM.ServerID	= 99

GM.ScoreboardName	= "Lobby"
GM.Community		= "CitronGamers"
GM.Website  		= "http://www.citrongamers.com/"
GM.AllowDownload	= true
GM.RemoveDefaultHUD	= false

DeriveGamemode("Lobby_Base")

LobbyModules.LoadModules( {
	"seats",
	"translations",
	"locations",
	"money",
	"scoreboard2",
	"spawnmenu",
	"thirdperson",
	"size",
	"achievements"
} )