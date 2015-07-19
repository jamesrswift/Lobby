--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, 2015
	
-----------------------------------------------------------]]--

require( "tmysql" );
if ( not tmysql ) then print( "[px][mysql] tMySQL module not found!" ) return false end

GM.MySQL = GM.MySQL or {}
GM.MySQL.Database = GM.MySQL.Database or false;

GM.MySQL.MapData = GM.MySQL.MapData or {};
GM.MySQL.PlayerData = GM.MySQL.PlayerData or {};
GM.MySQL.ServerData = GM.MySQL.ServerData or {};


--[[--------------------------------
	Config
--------------------------------]]--
GM.MySQL.HOST = "localhost"
GM.MySQL.PORT = 3306
GM.MySQL.USERNAME = "root"
GM.MySQL.PASSWORD = ""
GM.MySQL.NAME = "px"

function GM.MySQL:SetHost( Host ) self.HOST = Host end
function GM.MySQL:SetPort( Port ) self.PORT = Port end
function GM.MySQL:SetUser( User ) self.USERNAME = User end
function GM.MySQL:SetPass( Pass ) self.PASSWORD = Pass end
function GM.MySQL:SetDBName( DBName ) self.NAME = DBName end

--[[--------------------------------
	Main
--------------------------------]]--
function GM:InitializeMySQL()

	self.MySQL.Database = tmysql.initialize(self.MySQL.HOST, self.MySQL.USERNAME, self.MySQL.PASSWORD, self.MySQL.NAME, self.MySQL.PORT, nil, CLIENT_MULTI_STATEMENTS);
	
	if ( not self.MySQL.Database ) then
		self:Print( "[mysql] There was an error while connecting to the MySQL!" );
		return false
	end
	
	hook.Run( "MySQLConnected" )
	
	self:LoadServerInformation( self.ServerID or 0 );
	
	timer.Create( "lobby2_base:MySQL:CleanPlayerInformation", 15*60, 0, function() self:CleanPlayerInformation() end)
	
end

function GM.MySQL.BuildQuery( Query, ... )

	local vararg = {}
	
	-- Safe string
	for k,v in pairs( {...} ) do
		vararg[ k ] = tmysql.escape( tostring( v ) )
	end
	
	return string.format( Query, unpack( vararg ) )

end


--[[--------------------------------
	Player
--------------------------------]]--
function GM:LoadPlayerInformation( Pl )

	if ( self.MySQL.PlayerData[ Pl ] ) then
		hook.Run( "PlayerInformationLoaded", Pl )
		return true
	end

	local query = self.MySQL.BuildQuery( "SELECT * FROM gm_users WHERE SteamID64 = %s LIMIT 1", Pl:SteamID64() or 0 )

	if ( query ) then
		tmysql.query( query, function( results )
			PrintTable( results )
			if ( results[1] ) then
			
			
		
				hook.Run( "PlayerInformationLoaded", Pl )
			else
				self:Print( "[mysql] There was an error while loading player information!" );
			end
		end )
	end

end

function GM:CleanPlayerInformation( )

	for k,v in pairs( self.MySQL.PlayerData ) do
		if ( not IsValid( k ) ) then
			self.MySQL.PlayerData[ k ] = nil
		end
	end

end

local Meta = FindMetaTable("Player")

function Meta:GetData( )

	self.MySQL.PlayerData[ self ] = self.MySQL.PlayerData[ self ] or {}
	return self.MySQL.PlayerData[ self ]

end


--[[--------------------------------
	Map
--------------------------------]]--
function GM:LoadMapInformation( MapName )

	local query = self.MySQL.BuildQuery( "SELECT * FROM gm_maps WHERE map = %s LIMIT 1", MapName )

	if ( query ) then
		tmysql.query( query, function( results )
			PrintTable( results )
			if ( results[1] ) then
			
			
		
				hook.Run( "MapInformationLoaded", MapName )
			else
				print( "[px][mysql] There was an error while loading player information!" );
			end
		end )
	end

end


--[[--------------------------------
	Server
--------------------------------]]--
function GM:LoadServerInformation( ServerID )


end


--[[--------------------------------
	hooks
--------------------------------]]--

function GM:MySQLConnected( Database )

	-- Connection was made!
	self:Print( "MySQL Connected" )

end

function GM:PlayerInformationLoaded( Pl )

	self:Print( "Loaded player information" )

end

function GM:MapInformationLoaded( MapName )

	self:Print( "Loaded player information" )

end
