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
GM.Multiserver.Server = GM.Multiserver.Server or { }

-- Port range: 44901 - 44999
GM.Multiserver.Server.StartPort = 44901

require( "bromsock");

function GM.Multiserver.Server.New( )

	local GM = GM or gmod.GetGamemode( )
	local port = GM.Multiserver.Server.StartPort + (GM.ServerID or 0)
	
	if ( GM.Multiserver.Server.server ) then GM.Multiserver.Server.server:Close(); end
	GM.Multiserver.Server.server = BromSock();
	
	if (not GM.Multiserver.Server.server:Listen(port)) then
		GM:Print("[Multiserver] Failed to listen!");
	else
		GM:Print("[Multiserver] Server listening on port %u", port);
	end

	
	GM.Multiserver.Server.server:SetCallbackAccept( GM.Multiserver.Server.Accept );
	GM.Multiserver.Server.server:Accept();

end

function GM.Multiserver.Server.Accept( serversock, clientsock )
	
	local GM = GM or gmod.GetGamemode( )

	serversock:Accept();
	
	clientsock:SetCallbackReceive( function(s, p)
		local r_num = p:ReadInt( )
		
		local packet = GM.Multiserver.Coms.HandleConnection( s, p )
		if ( packet ) then
			s:Send( packet )
		end
		
	end	);
	
	clientsock:SetCallbackSend(function()
		clientsock:Close();
	end);
	
	clientsock:SetTimeout(5000);
	clientsock:ReceiveUntil("\r\n\r\n");
end
