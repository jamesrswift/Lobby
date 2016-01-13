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

	local query = GM.MySQL.BuildQuery( "SELECT COLUMN_NAME, ORDINAL_POSITION, DATA_TYPE FROM 'information_schema`.COLUMNS WHERE TABLE_NAME = %s AND TABLE_SCHEMA = %s;", tbl_name, schema_name or GM.MySQL.NAME )
	if ( query ) then
	
		tmysql.query( query, function( results )
		
			GM.MySQL.InformationSchema[ tbl_name ] = GM.MySQL.InformationSchema[ tbl_name ] or { }
		
			for k, column in pairs( results ) do
			
				GM.MySQL.InformationSchema[ tbl_name ][ column[2] ] = { column[1],  column[3] }
			
			end
			
		end)
		
	end

end

function GM.MySQL.GetColumnInformationFromColumn( tbl_name, column_id )
	
	local GM = GM or gmod.GetGamemode( )
	if ( not GM.MySQL.InformationSchema[ tbl_name ] ) then GM.MySQL.InitializeTable( tbl_name ) end
	return GM.MySQL.InformationSchema[ tbl_name ][ column_id ]
	
end

function GM.MySQL.GetColumnInformationFromColumnName( tbl_name, column_name )
	
	local GM = GM or gmod.GetGamemode( )
	if ( not GM.MySQL.InformationSchema[ tbl_name ] ) then GM.MySQL.InitializeTable( tbl_name ) end
	
	for id, info in pairs( GM.MySQL.InformationSchema[ tbl_name ] ) do
		if ( info[1] == column_name ) then
			return info
		end
	end

	return false

end

function GM.MySQL.SelectAll( tbl_name, callback, extra )

	local GM = GM or gmod.GetGamemode( )
	if ( not GM.MySQL.InformationSchema[ tbl_name ] ) then GM.MySQL.InitializeTable( tbl_name ) end
	
	local query = GM.MySQL.BuildQuery( "SELECT * FROM %s " .. ( extra or "" ) .. ";", tbl_name )
	if ( query ) then
	
		tmysql.query( query, function( results )

			local result = { }
			
			for row,v in pairs( results ) do
			
				result[ row ] = { }
				
				for column_id, data in pairs( v ) do
					
					local info = GM.MySQL.GetColumnInformationFromColumn( tbl_name, column_id )
					if ( table.HasValue( {"integer", "int", "smallint", "tinyint", "mediumint", "bigint"}, info[2] ) ) then
						result[ row ][ info[1] ] = tonumber(data)
					else
						result[ row ][ info[1] ] = data
					end
				
				end
			
			end
			
			callback( result, results )
			
		end)
		
	end

end

function GM.MySQL.Select( tbl_name, columns, callback, extra )

	local GM = GM or gmod.GetGamemode( )
	if ( not GM.MySQL.InformationSchema[ tbl_name ] ) then GM.MySQL.InitializeTable( tbl_name ) end
	
	local query = GM.MySQL.BuildQuery( "SELECT " .. string.Implode( ", ", tmysql.escape( tostring(columns) ) ) .. " FROM %s " .. extra .. ";", tbl_name )
	if ( query ) then
	
		tmysql.query( query, function( results )

			local result = { }
			
			for row,v in pairs( results ) do
				
				result[ row ] = { }
				
				for column, column_name in pairs( columns ) do
					
					if ( table.HasValue( {"integer", "int", "smallint", "tinyint", "mediumint", "bigint"}, GM.MySQL.GetColumnInformationFromColumnName( tbl_name, column_name )[2] ) ) then
						result[ row ][ column_name ] = tonumber(v2)
					else
						result[ row ][ column_name ] = v2
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
