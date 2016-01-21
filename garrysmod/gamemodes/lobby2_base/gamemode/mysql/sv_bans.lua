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
	
	self.MySQL.SelectAll( "gm_bans", function( results )
	
		for k, ban in pairs( results ) do
			
			if ( ban.Start + ban.Length > os.time( ) ) then
		
				self.MySQL.Bans[ ban.SteamID64 ] = { 
					start = ban.Start,
					length = ban.Length,
					reason = ban.Reason,
					admin = ban.Admin64
				}
				
			end
		
		end
	
	end)

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
