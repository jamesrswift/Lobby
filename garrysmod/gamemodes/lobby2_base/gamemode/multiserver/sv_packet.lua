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
GM.Multiserver.Packet = GM.Multiserver.Packet or { }

require( "bromsock" )

function GM.Multiserver.Packet.ReadPacket( packet )

	local Data = string.Explode( "\r\n", packet:ReadStringAll() )

	local Protocol = Data[ 1 ]
	if ( Protocol == "LobbyISCP" ) then
	
		local ID = tonumber( Data[ 2 ] )
		local Type = tonumber( Data[ 3 ] )
		local Password = Data[ 4 ]
		local Body = Data[ 5 ]
		
		return true, ID, Type, Password, Body
	
	end
	
	return false

end

function GM.Multiserver.Packet.NewPacket( ID, Type, Password, Body )

	local packet = BromPacket()
	
	packet:WriteLine( "LobbyISCP" )
	
	packet:WriteLine( tostring( ID ) )
	packet:WriteLine( tostring( Type ) )
	packet:WriteLine( Password )
	packet:WriteLine( Body )
	
	packet:WriteLine( "" )
	
	return packet

end
