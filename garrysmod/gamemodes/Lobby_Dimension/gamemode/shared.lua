/*

  __  __    ___ ___ _  _    ____ ___  __  __  __    ___  __ __ ___ 
 / _)/ _)  (   \  _) )( )  (_  _)  _)(  )(  \/  )  (__ \/  \  )__ \
( (_( (/\   ) ) ) _)\\//     )(  ) _)/__\ )    (   / __/ () )(/ __/
 \__)\__/  (___/___)(__)    (__)(___)_)(_)_/\/\_)  \___)\__/__)___)

	Copyright (c) James Swift, Alex Swift 2012
 
 */


GM.Name     		= "Lobby: Dimension"
GM.Author   		= "James and Alex"

GM.ScoreboardName	= "Dimension"
GM.Community		= "CitronGamers"
GM.Website  		= "http://www.citrongamers.com/"
GM.AllowDownload	= true
GM.NewHud 			= false

DeriveGamemode("Lobby_Base")  

LobbyModules.LoadModules( {
	"money",
	"scoreboard2",
	"translations"
} )