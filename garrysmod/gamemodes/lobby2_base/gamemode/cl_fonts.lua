--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, 2015
	
-----------------------------------------------------------]]--

function GM:CreateFonts( )

	surface.CreateFont( "LobbyNotification", {
		font = "Roboto Bold",
		size = 14,
		weight = 500,
		blursize = 0,
		antialias = true
	})
	
	surface.CreateFont( "LobbyChat", {
		font = "Roboto Bold",
		size = 16,
		weight = 500,
		blursize = 0,
		antialias = true
	})
	
	surface.CreateFont( "LobbyTitle", {
		font = "Pacifico",
		size = 32,
		weight = 300,
		blursize = 0,
		antialias = true
	})

end