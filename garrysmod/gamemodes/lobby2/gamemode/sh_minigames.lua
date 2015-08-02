--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, 2015
	
-----------------------------------------------------------]]--

GM.Minigames = GM.Minigames or { }
GM.Minigames.Registered = GM.Minigames.Registered or { }
GM.Minigames.Directory = "lobby2/gamemode/minigames/"
GM.Minigames.Mt = GM.Minigames.Mt or { }

function GM.Minigames.Register( tbl )

	if ( not tbl.Name ) then return end
	
	GM.Minigames.Registered[ tbl.Name ] = tbl

end

function GM.Minigames.Load( )

	local GM = GM or gmod.GetGamemode( )

	local files = file.Find( GM.Minigames.Directory, "LUA" )
	
	for k,v in pairs( files ) do
	
		Minigame = { }
		setmetatable( Minigame, { __index = GM.Minigames.Mt } )
		
		include( "minigames/" .. v )
		
		GM.Minigames.Register( Minigame )
		Minigame = { }
	
	end

end

function GM.Minigames.OnLocationChange( Pl, OldLocation, NewLocation, lobby_location )


end