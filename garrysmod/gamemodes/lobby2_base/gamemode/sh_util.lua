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

function GM:Log( StartName, str, ... )

	file.CreateDir( "lobby" )
	local date = os.date( "%b-%d", os.time( ) )

	file.Append( "lobby/" .. StartName .. " - " .. date .. ".dat" , os.date( "[%H:%M:%S] ", os.time( ) ) .. string.format( str, ... ) .."\n" )

end


if ( SERVER ) then

	util.AddNetworkString( "lobby_notification" )
	util.AddNetworkString( "lobby_clientready" )

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
	
	net.Receive( "lobby_clientready", function( len, Pl )
	
		hook.Run( "LobbyClientReady", Pl )
	
	end)

end

if ( CLIENT ) then

	hook.Add( "Think", "NotifyReady", function()
	
		if ( GAMEMODE.FirstThink ) then return end
	
		net.Start( "lobby_clientready" )
		net.SendToServer( )
		
		GAMEMODE.FirstThink = true
	
	end)

end

-- Hook Override

local old_hook_call = hook.Call

function hook.Call( name, ENV, ... )

	local GM = GM or gmod.GetGamemode( )
	if ( GM.Modules ) then
	
		local a, b, c, d, e, f = GM.Modules.RunHook( name, ... )
		
		if ( a ~= nil ) then
			return a, b, c, d, e, f
		end
		
	end
	
	return old_hook_call( name, ENV, ... )

end