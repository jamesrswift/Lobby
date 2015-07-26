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

	local Protocol = packet:ReadLine( )
	if ( Protocol == "LobbyISCP" ) then
	
		local ID = packet:ReadULong( )
		local Type = packet:ReadULong( )
		local Password = packet:ReadStringNT( )
		local Body = packet:ReadStringNT( )
		
		return true, ID, Type, Password, Body
	
	end
	
	return false

end

function GM.Multiserver.Packet.NewPacket( ID, Type, Password, Body )

	local packet = BromPacket()
	
	packet:WriteLine( "LobbyISCP" )
	
	packet:WriteULong( ID )
	packet:WriteULong( Type )
	packet:WriteStringNT( Password )
	packet:WriteStringNT( Body )
	packet:WriteLine( "" )
	
	packet:WriteLine( "" )
	
	return packet

end

