--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, 2015
	
-----------------------------------------------------------]]--

function GM:Print( s , ... )
	
	MsgC( (SERVER and Color(78,177,255) or Color(255,217,78)), "[lobby2] ", color_white, string.format( s, ... ) , "\n" )

end

if SERVER then

util.AddNetworkString( "lobby_notification" )

function GM:NotifyPlayer( Pl, Type, Text, Lifetime )

	net.Start( "lobby_notification" )
	net.WriteString( Type )
	net.WriteString( Text )
	net.WriteFloat( Lifetime )
	net.Send( Pl )

end


function GM:NotifyAll( Type, Text, Lifetime )

	net.Start( "lobby_notification" )
	net.WriteString( Type )
	net.WriteString( Text )
	net.WriteFloat( Lifetime )
	net.Broadcast( )


end

end