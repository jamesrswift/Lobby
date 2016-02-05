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

	local Data = Buffer( packet:ReadStringAll() )

	if ( Data:ReadStringNT( ) == "LobbyISCP" ) then
	
		local ID = Data:ReadInteger( )
		local Type = Data:ReadInteger( )
		local Password = Data:ReadStringNT( )
		local Body = Data:ReadStringNT( )
		
		return true, ID, Type, Password, Body
	
	end
	
	return false

end

function GM.Multiserver.Packet.NewPacket( ID, Type, Password, Body )

	local packet = Buffer( )
	
	packet:WriteStringNT( "LobbyISCP" )
	packet:WriteInteger( ID )
	packet:WriteInteger( Type )
	packet:WriteStringNT( Password )
	packet:WriteStringNT( Body )
	
	PrintTable( string.ToTable( packet:GetData() ) )
	
	return packet:ToPacket( )

end

