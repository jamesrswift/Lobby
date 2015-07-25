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

	local length = 0
	for i=0, 3 do
		length = length + packet:ReadByte() * ( 256 ^ i )
	end
	
	local ID = 0
	for i=0, 3 do
		ID = ID + packet:ReadByte() * ( 256 ^ i )
	end
	
	local Type = 0
	for i=0, 3 do
		Type = Type + packet:ReadByte() * ( 256 ^ i )
	end
	
	local Body = packet:ReadStringNT()
	
	return length, ID, Type, Body

end

function GM.Multiserver.Packet.NewPacket( ID, Type, Body )

	local packet = BromPacket()
	local length = string.len( Body ) + 10
	
	-- Length
	packet:WriteByte( bit.band( length, 0x000000FF ) )
	packet:WriteByte( bit.rshift( bit.band( length, 0x0000FF00 ), 8 ) )
	packet:WriteByte( bit.rshift( bit.band( length, 0x00FF0000 ), 16 ) )
	packet:WriteByte( bit.rshift( bit.band( length, 0xFF000000 ), 24 ) )
	
	-- ID
	packet:WriteByte( bit.band( ID, 0x000000FF ) )
	packet:WriteByte( bit.rshift( bit.band( ID, 0x0000FF00 ), 8 ) )
	packet:WriteByte( bit.rshift( bit.band( ID, 0x00FF0000 ), 16 ) )
	packet:WriteByte( bit.rshift( bit.band( ID, 0xFF000000 ), 24 ) )
	
	-- WriteType
	packet:WriteByte( bit.band( Type, 0x000000FF ) )
	packet:WriteByte( bit.rshift( bit.band( Type, 0x0000FF00 ), 8 ) )
	packet:WriteByte( bit.rshift( bit.band( Type, 0x00FF0000 ), 16 ) )
	packet:WriteByte( bit.rshift( bit.band( Type, 0xFF000000 ), 24 ) )
	
	-- Body
	packet:WriteStringNT( Body )
	
	-- Null
	packet:WriteByte( 0 )
	
	return packet

end

function GM.Multiserver.Packet.AuthPacket( ID, Password )

	local GM = GM or gmod.GetGamemode( )
	return GM.Multiserver.PacketBuilder.NewPacket( ID, 3, Password )

end

function GM.Multiserver.Packet.ExecCommandPacket( ID, Command )

	local GM = GM or gmod.GetGamemode( )
	return GM.Multiserver.Packet.NewPacket( ID, 2, Command )

end
