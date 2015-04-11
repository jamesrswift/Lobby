-- mysql.lua


LobbyInventory.MySQL = { }
LobbyInventory.MySQL.Cache = { }


function LobbyInventory.MySQL.Load( )
	mysql.SelectFromTable( "gm_user" , { "ID" , "Inventory" },  function(data)
		for k,v in pairs( data ) do
			local ID = tonumber( v[1] )
			local Data =  von.deserialize( v[2] )
			LobbyInventory.MySQL.Cache[ tonumber(ID) ] = Data
		end
	end)
end

hook.Add( "DatabaseConnect", "LobbyInventorys" , LobbyInventory.MySQL.Load )


function LobbyInventory.MySQL.Save( ID )
	print( "UPDATE gm_user SET Inventory='"..tmysql.escape(von.serialize( LobbyInventory.MySQL.GetUser( ID ) )) .. "' WHERE ID=".. tonumber(ID) )
	mysql.Query( "UPDATE gm_user SET Inventory='"..tmysql.escape(von.serialize( LobbyInventory.MySQL.GetUser( ID ) )) .. "' WHERE ID="..tonumber(ID));
end


function LobbyInventory.MySQL.GetUser( ID )
	if ( !LobbyInventory.MySQL.Cache[ tonumber(ID) ] ) then
		LobbyInventory.MySQL.Cache[ tonumber(ID) ] = {}
	end
	
	return LobbyInventory.MySQL.Cache[ tonumber(ID) ]

end
