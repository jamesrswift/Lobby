--[[-----------------------------------------------------------

	¦¦+      ¦¦¦¦¦¦+ ¦¦¦¦¦¦+ ¦¦¦¦¦¦+ ¦¦+   ¦¦+    ¦¦¦¦¦¦+ 
	¦¦¦     ¦¦+---¦¦+¦¦+--¦¦+¦¦+--¦¦++¦¦+ ¦¦++    +----¦¦+
	¦¦¦     ¦¦¦   ¦¦¦¦¦¦¦¦¦++¦¦¦¦¦¦++ +¦¦¦¦++      ¦¦¦¦¦++
	¦¦¦     ¦¦¦   ¦¦¦¦¦+--¦¦+¦¦+--¦¦+  +¦¦++      ¦¦+---+ 
	¦¦¦¦¦¦¦++¦¦¦¦¦¦++¦¦¦¦¦¦++¦¦¦¦¦¦++   ¦¦¦       ¦¦¦¦¦¦¦+
	+------+ +-----+ +-----+ +-----+    +-+       +------+

	
	Copyright (c) James Swift, 2015
	
-----------------------------------------------------------]]--

GM.MySQL.PlayerData = GM.MySQL.PlayerData or {};

function GM:LoadPlayerInformation( Pl )

	if ( self.MySQL.PlayerData[ Pl ] ) then
		hook.Run( "PlayerInformationLoaded", Pl )
		return true
	end

	local query = self.MySQL.BuildQuery( "SELECT * FROM gm_users WHERE SteamID64 = %s LIMIT 1", Pl:SteamID64() or 0 )

	if ( query ) then
		tmysql.query( query, function( results )
			if ( IsValid( Pl ) and results[1] ) then
			
			
		
				hook.Run( "PlayerInformationLoaded", Pl )
			else
				self:Print( "[mysql] There was an error while loading player information!" );
			end
		end )
	end

end

function GM:CleanPlayerInformation( )

	local removed = {}

	for k,v in pairs( self.MySQL.PlayerData ) do
		if ( not IsValid( k ) ) then
			self.MySQL.PlayerData[ k ] = nil
			table.insert( removed, k )
		end
	end
	
	hook.Run( "PlayerMySQLInformationCleaned", removed )

end

local Meta = FindMetaTable("Player")

function Meta:GetData( )

	gmod.GetGamemode().MySQL.PlayerData[ self ] = gmod.GetGamemode().MySQL.PlayerData[ self ] or {}
	return gmod.GetGamemode().MySQL.PlayerData[ self ]

end

function Meta:SaveData( )


end
