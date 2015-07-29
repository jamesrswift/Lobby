--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, 2015
	
-----------------------------------------------------------]]--

GM.MySQL.Bans = GM.MySQL.Bans or {};

function GM:LoadBans( )

	local query = self.MySQL.BuildQuery( "SELECT * FROM gm_bans" )
	
	if ( query ) then
		tmysql.query( query, function( results )
		
			for k, ban in pairs( results ) do
			
				local start = tonumber( results[2] )
				local length = tonumber( results[3] )
				
				if ( start + length > os.time( ) ) then
			
					self.MySQL.Bans[ results[1] ] = { 
						start = start,
						length = length,
						reason = results[4],
						admin = results[5]
					}
					
				end
			
			end
			
		end )
	end

end

function GM:IsPlayerBanned( SteamID64 )

	local ban = self.MySQL.Bans[ SteamID64 ]
	
	if ( not ban ) then return false end
	if ( ban.start + ban.length > os.time( ) ) then return false end
	
	return ban

end

local Meta = FindMetaTable( "Player" )

function Meta:IsBanned( )

	local GM = GM or gmod.GetGamemode( )
	return GM:IsPlayerBanned( self:SteamID64() )

end