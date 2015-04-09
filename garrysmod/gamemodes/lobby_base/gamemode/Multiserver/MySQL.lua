// MySQL.Lua


if !mysql then return end -- We needs MySQL
if !MultiServer then MultiServer = { }; end
MultiServer.MySQL = { }
local MySQLSys = MultiServer.MySQL

MySQLSys.Delay = 4;
MySQLSys.ServerTimeout = 20;


-- Update the Cache


-- Collum1 : Server ID
-- Collum2 : Players
-- Collum3 : Msg
-- Collum4 : Map
-- Collum5 : Status
-- Collum6 : LastUpdate


function MySQLSys.GetServerInformations( )

	mysql.SelectAllFromTable( "gm_server" , function(data)
		for k,v in pairs( data ) do
		
			local Server = MultiServer.GamesSys.GetGamemodeInformation( tonumber(v[1]) )
			Server.CurrentPlayers = v[2] 
			Server.Message = v[3]
			Server.Map = v[4]
			Server.Status = v[5]
			Server.LastUpdate = v[6]
			Server.Online = true;
			Server.Pass = v[7]
			if tonumber(Server.LastUpdate) < ( os.time() - MySQLSys.ServerTimeout ) then Server.Online = false end
			
		end
	end)

end

timer.Create( "MultiServer:UpdateMySQLCache" , MySQLSys.Delay , 0 , MySQLSys.GetServerInformations )

-- UPDATE Function


function MySQLSys.UpdateServerInformation( ID , Players , Message , Map , Status, Pass )

	mysql.Query( "DELETE FROM gm_server WHERE ID="..ID or -1 );
	mysql.Insert( "gm_server" , {"ID" , "Players" , "Msg" , "Map" , "Status" , "LastUpdate", "Pass" } , { ID or 0 , Players or 0, Message or "" , Map or "" , Status or -1 , os.time(), Pass } )

	--mysql.Query( "UPDATE gm_server SET Players="..Players .. ", Msg='"..Message or "" .. "', Map='"..Map or "".."', Status="..Status or -1 .. "', LastUpdate="..os.time()..", Pass='"..Pass.."';")
	
end