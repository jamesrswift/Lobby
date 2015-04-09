-- protocol.lua
-- DEPRICATED , USE MYSQL

require( 'litesocket' );

if !Hex then return end -- We needs hex
if !MultiServer then MultiServer = { }; end
MultiServer.ProtocolSys = { };
local ProtocolSys = MultiServer.ProtocolSys ;

ProtocolSys.WaitingList = { };
ProtocolSys.AuthList = { };


-- Listen

concommand.Add( "Lobby_RCON" , function( _ , __ , arguments )

	print( "Recieved!!" )

	MultiServer.RecievedInformation( arguments[1] )

end)

-- Send-Listen

hook.Add( "Tick", "Protocolsys:Send-Listen" , function( )

	for k,v in pairs( ProtocolSys.WaitingList ) do
	
	    local d, ip, port, ln = v:RecvFromTable()
        if d then
            d = SocketConcatTable(d,ln)
            hook.Call( "ProtocolSys_Recv" , GAMEMODE , d , ln );
            v:Close()
            ProtocolSys.WaitingList[k] = nil
        end
	
	end
	
	for k,v in pairs( ProtocolSys.AuthList ) do
	
	    local d, ip, port, ln = v:RecvFromTable()
        if d then
            d = SocketConcatTable(d,ln)
            hook.Call( "ProtocolSys_Authed" , GAMEMODE , d , ln );
            v:Close()
            ProtocolSys.AuthList[k] = nil
        end
	
	end
	
end)

function GM:ProtocolSys_Recv( Data, Len )

	print( Data, Len )

end

function GM:ProtocolSys_Authed( Data, Len )

	print( Data, Len )

end

-- Sending

function ProtocolSys:Auth( IP, Port, Pass )

	/*local connection = Socket(IPPROTO_TCP)
    connection:Bind("*",0)
	connection:SetTimeout(0)
	
	local Size, Packet = Source.AuthenticatePacket( Pass ) -- function removed
	
    local success, error = connection:SendTo( Packet, Size , IP,Port)
	
	if success then
		ProtocolSys.AuthList[connection] = connection;
	else
		return false, error
	end*/

end

function ProtocolSys:Send( IP, Port, QueryString )

	/*QueryString = "Lobby_RCon " .. QueryString

	local connection = Socket(IPPROTO_TCP)
    connection:Bind("*",0)
	connection:SetTimeout(0)
	
    local success, error = connection:SendTo( Source.CommandPacket( QueryString ), #QueryString , IP,Port) -- function removed
	
	if success then
		ProtocolSys.WaitingList[connection] = connection;
	else
		return false, error
	end*/

end