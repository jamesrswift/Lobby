--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, 2015
	
-----------------------------------------------------------]]--

GM.Multiserver = GM.Multiserver or { }
GM.Multiserver.Rcon = GM.Multiserver.Rcon or { }

GM.Multiserver.Rcon.Connections = GM.Multiserver.Connections or { }

function GM.Multiserver.Rcon.RandomID( )

	return string.char( math.random( 0, 255 ) ) .. string.char( math.random( 0, 255 ) ) .. string.char( math.random( 0, 255 ) ) .. string.char( math.random( 0, 255 ) )

end

function GM.Multiserver.Rcon.BuildAuthPacket( Password, Callback )
	
	local GM = GM or gmod.GetGamemode( )

	local ID = GM.Multiserver.Rcon.RandomID( )
	local Type = string.char( 3 ) .. string.rep( string.char( 0 ) , 3 )
	
	local Packet = ID .. Type .. Password .. string.rep( string.char( 0 ) , 2 )

end

function GM.Multiserver.Rcon.GetConnection( IP , Port )

	local GM = GM or gmod.GetGamemode( )
	
	if ( GM.Multiserver.Rcon.Connections[ IP .. ":" .. Port ] ) then
		return GM.Multiserver.Rcon.Connections[ IP .. ":" .. Port ]
	end
	
	return false

end

function GM.Multiserver.Rcon.NewConnection( IP, Port )

	local connection = GM.Multiserver.Rcon.GetConnection( IP , Port )
	if ( not connection ) then
	
		connection = BromSock()
		GM.Multiserver.Rcon.Connections[ IP .. ":" .. Port ] = connection
		
	end

end