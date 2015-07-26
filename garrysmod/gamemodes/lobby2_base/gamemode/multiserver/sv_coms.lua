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
GM.Multiserver.Coms = GM.Multiserver.Coms or { }
GM.Multiserver.Coms.Methods = GM.Multiserver.Coms.Methods or { }
GM.Multiserver.Coms.WhiteList = GM.Multiserver.Coms.WhiteList or { }

function GM.Multiserver.Coms.AddMethod( Type, Function )

	local GM = GM or gmod.GetGamemode( )
	if ( not GM.Multiserver.Coms.GetMethod( Type ) ) then
	
		GM.Multiserver.Coms.Methods[ Type ] = Function
		
	end
	
end

function GM.Multiserver.Coms.GetMethod( Type )

	return GM.Multiserver.Coms.Methods[ Type ] or false
	
end

function GM.Multiserver.Coms.HandleMethod( IP, Type, ID, Password, Body )

	local GM = GM or gmod.GetGamemode( )
	local method = GM.Multiserver.Coms.GetMethod( Type )
	
	if ( method ) then
	
		if ( GM.Multiserver.Coms.CheckPassword( IP, Password ) ) then
		
			return method( Body )
		
		end
	
	end

end

function GM.Multiserver.Coms.CheckPassword( IP, Password )

	local GM = GM or gmod.GetGamemode( )
	return GM.Multiserver.Coms.WhiteList[ IP ] == Password

end

function GM.Multiserver.Coms.AddLogin( IP, Password )

	local GM = GM or gmod.GetGamemode( )
	GM.Multiserver.Coms.WhiteList[ IP ] = Password
	
end

function GM.Multiserver.Coms.HandleConnection( sock, packet )

	local GM = GM or gmod.GetGamemode( )

	local IP = sock:GetIP( )
	local success, ID, Type, Password, Body = GM.Multiserver.Packet.ReadPacket( packet )
	
	if ( success ) then
	
		return GM.Multiserver.Coms.HandleMethod( IP, Type, ID, Password, Body )
	
	end

end