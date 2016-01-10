--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, 2015
	
-----------------------------------------------------------]]--

require( "tmysql" )
if ( not tmysql ) then GM:Print( "[MySQL] tMySQL module not found!" ) return false end

GM.MySQL = GM.MySQL or {}
GM.MySQL.Database = GM.MySQL.Database or false
GM.MySQL.InformationSchema = GM.MySQL.InformationSchema or {}

GM.MySQL.MapData = GM.MySQL.MapData or {}
GM.MySQL.ServerData = GM.MySQL.ServerData or {}


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

	self.MySQL.Database = tmysql.initialize(self.MySQL.HOST, self.MySQL.USERNAME, self.MySQL.PASSWORD, self.MySQL.NAME, self.MySQL.PORT, nil, CLIENT_MULTI_STATEMENTS)
	
	if ( not self.MySQL.Database ) then
		self:Print( "[MySQL] There was an error while connecting to the MySQL!" )
		self:Log( "mysql", "There was an error while connecting to the MySQL!" )
		return false
	end
	
	self:Print( "[MySQL] Connected" )
	self:Log( "mysql", "New Connection" )
	
	hook.Run( "MySQLConnected" )
	
	self:LoadBans( )
	self:LoadServerInformation( self.ServerID or 0 )
	
	timer.Create( "lobby2_base:MySQL:CleanPlayerInformation", 15*60, 0, function() self:CleanPlayerInformation() end)
	
end

function GM.MySQL.BuildQuery( Query, ... )

	local vararg = {}
	
	-- Safe string
	for k,v in pairs( {...} ) do
		if ( type( v ) == "string" ) then
			vararg[ k ] = tmysql.escape( tostring( v ) )
		else
			vararg[ k ] = v
		end
	end
	
	return string.format( Query, unpack( vararg ) )

end

function GM.MySQL.InitializeTable( tbl_name, schema_name )

	local GM = GM or gmod.GetGamemode( )

	local query = self.MySQL.BuildQuery( "SELECT COLUMN_NAME, ORDINAL_POSITION, DATA_TYPE FROM 'information_schema`.COLUMNS WHERE TABLE_NAME = %s AND TABLE_SCHEMA = %s;", tbl_name, schema_name or self.MySQL.NAME )
	if ( query ) then
	
		tmysql.query( query, function( results )
		
			GM.MySQL.InformationSchema[ tbl_name ] = GM.MySQL.InformationSchema[ tbl_name ] or { }
		
			for k, column in pairs( results ) do
			
				GM.MySQL.InformationSchema[ tbl_name ][ column[2] ] = { column[1],  column[3] }
			
			end
			
		end)
		
	end

end

function GM.MySQL.SelectAll( tbl_name, callback, extra )

	local GM = GM or gmod.GetGamemode( )
	if ( not GM.MySQL.InformationSchema[ tbl_name ] ) then GM.MySQL.InitializeTable( tbl_name ) end
	
	local query = self.MySQL.BuildQuery( "SELECT * FROM %s " .. extra .. ";", tbl_name )
	if ( query ) then
	
		tmysql.query( query, function( results )

			local result = { }
			
			for k,v in pairs( results ) do
			
				result[ k ] = { }
				
				for k2,v2 in pairs( v ) do
					
					if ( table.HasValue( {"integer", "int", "smallint", "tinyint", "mediumint", "bigint"}, GM.MySQL.InformationSchema[ tbl_name ][ k2 ][3] ) ) then
						result[ k ][ GM.MySQL.InformationSchema[ tbl_name ][ k2 ][1] ] = tonumber(v2)
					else
						result[ k ][ GM.MySQL.InformationSchema[ tbl_name ][ k2 ][1] ] = v2
					end
				
				end
			
			end
			
			callback( result, results )
			
		end)
		
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

end

function GM:PlayerInformationLoaded( Pl )

	self:Print( "Loaded player information" )

end

function GM:MapInformationLoaded( MapName )

	self:Print( "Loaded map information" )

end
