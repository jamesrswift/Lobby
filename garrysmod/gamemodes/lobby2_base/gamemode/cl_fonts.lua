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
		size = 16,
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

matproxy.Add( {
	name = "lobbyspherebot",
	init = function( self, mat, values )
		self.ResultTo = values.resultvar
	end,
	bind = function( self, mat, ent )
		mat:SetVector( self.ResultTo, Vector( 0,0.8,1 ) )
	end
} )

matproxy.Add( {
	name = "lobbyspheretop",
	init = function( self, mat, values )
		self.ResultTo = values.resultvar
	end,
	bind = function( self, mat, ent )
		mat:SetVector( self.ResultTo, Vector( 1,1,1 ) )
	end
} )
