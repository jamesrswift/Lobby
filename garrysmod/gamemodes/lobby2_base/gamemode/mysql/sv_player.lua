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
	
	self.MySQL.SelectAll( "gm_users", function( results )
		
		if ( IsValid( Pl ) ) then
			
			local data = Pl:GetData()
		
			if ( results[1] ) then
				
				data.money = results[1].Money
				data.usergroup = results[1].Usergroup or "user"
				
				if ( string.len( results[1].Inventory ) > 0 ) then
					data.inventory = util.JSONToTable( results[1].Inventory )
				else
					data.inventory = { }
				end
				
				if ( string.len( results[1].Achievements ) > 0 ) then
					data.achievements = util.JSONToTable( results[1].Achievements  )
				else
					data.achievements = { }
				end
				
				data.model = results[1].Model or "kleiner"
			
			else
			
				data.money = 0
				data.usergroup = "user"
				data.inventory = { }
				data.achievements = { }
				data.model = "kleiner"
			
			end
			
			self.Usergroups.PlayerInformationLoaded( Pl )
			hook.Run( "PlayerInformationLoaded", Pl )
			
		else
		
			self:Print( "[MySQL] There was an error while loading player information!" );
			
		end
	
	end, "WHERE SteamID64 = %s LIMIT 1", Pl:SteamID64() or 0 )

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

	local data = self:GetData( )

	local GM = GM or gmod.GetGamemode( )
	
	local query = GM.MySQL.BuildQuery( "REPLACE INTO gm_users ( SteamID64, Money, Usergroup, Inventory, Achievements, Model ) Values ( '%s', %i, '%s', '%s', '%s', '%s' )",
		self:SteamID64() or 0, data.money or 0, data.usergroup or "user", util.TableToJSON( data.inventory or {} ), util.TableToJSON( data.achievements or {} ), data.Model or "kleiner" )

	if ( query ) then
		tmysql.query( query, function( results )
	
		end )
	end

end
