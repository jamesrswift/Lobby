-- mysql.lua


Achievement.MySQL = { }
Achievement.MySQL.Cache = { }


function Achievement.MySQL.Load( )
	mysql.SelectFromTable( "gm_user" , { "ID" , "Achievement" },  function(data)
		for k,v in pairs( data ) do
			local ID = tonumber( v[1] )
			local Data = von.deserialize( v[2] )
			Achievement.MySQL.Cache[ ID ] = { Data }
		end
	end)
end

hook.Add( "DatabaseConnect", "Achievements" , Achievement.MySQL.Load )


function Achievement.MySQL.Save( ID )
	mysql.Query( "UPDATE gm_user SET Achievement='"..von.serialize( Achievement.MySQL.GetUser( ID ) ) .. "' WHERE ID="..ID);
end


function Achievement.MySQL.GetUser( ID )
	if ( !Achievement.MySQL.Cache[ ID ] ) then
		local T = { }
		for k,v in pairs( Achievement.Loaded ) do
			T[ k ] = 0;
		end
		
		Achievement.MySQL.Cache[ ID ] = T
	end
	
	return Achievement.MySQL.Cache[ ID ]

end
