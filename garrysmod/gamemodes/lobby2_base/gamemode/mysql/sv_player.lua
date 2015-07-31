--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, 2015
	
-----------------------------------------------------------]]--

GM.MySQL.PlayerData = GM.MySQL.PlayerData or {};

function GM:LoadPlayerInformation( Pl )

	local query = self.MySQL.BuildQuery( "SELECT * FROM gm_users WHERE SteamID64 = %s LIMIT 1", Pl:SteamID64() or 0 )

	if ( query ) then
		tmysql.query( query, function( results )
		
			if ( IsValid( Pl ) ) then
			
				local data = Pl:GetData()
			
				if ( results[1] ) then
					
					data.money = results[1][2]
					data.usergroup = results[1][3]
					
					if ( string.len( results[1][4] ) > 0 ) then
						data.inventory = util.JSONToTable( results[1][4] )
					else
						data.inventory = { }
					end
				
				else
				
					data.money = 0
					data.usergroup = "user"
					data.inventory = { }
				
				end
				
				self.Usergroups.PlayerInformationLoaded( Pl )
				hook.Run( "PlayerInformationLoaded", Pl )
				
			else
			
				self:Print( "[MySQL] There was an error while loading player information!" );
				
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

	local PlayerData = gmod.GetGamemode().MySQL.PlayerData
	PlayerData[ self ] = PlayerData[ self ] or {}
	return PlayerData[ self ]

end

function Meta:SaveData( )


end
