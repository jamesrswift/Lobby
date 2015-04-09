
-- Copyright (c) 2012 , James Swift
-- This script is under this license : https://sites.google.com/site/jamesaddons/home/terms-of-Service

if mysql then return end
mysql = {}

require( "tmysql" )


if !tmysql and !mysql then
	Msg( "Failed to load MySQL library , please install corect modules\n" );
	return false
end

function mysql.SetHost( Host ) DATABASE_HOST = Host end
function mysql.SetPort( Port ) DATABASE_PORT = Port end
function mysql.SetUser( User ) DATABASE_USERNAME = User end
function mysql.SetPass( Pass ) DATABASE_PASSWORD = Pass end
function mysql.SetDBName( DBName ) DATABASE_NAME = DBName end
function mysql.SetHandle( Handle ) DATABASE_HANDLE = Handle end

 
function mysql.Connect()
	local connected = tmysql.initialize(DATABASE_HOST, DATABASE_USERNAME, DATABASE_PASSWORD, DATABASE_NAME, DATABASE_PORT)
	if !connected then return connected end
	timer.Simple( 0.01 , function() hook.Call( "DatabaseConnect" , GAMEMODE ) end)
	return connected
end



function mysql.Query( ... )
	--print( ... )
	--tmysql.initialize(DATABASE_HOST, DATABASE_USERNAME, DATABASE_PASSWORD, DATABASE_NAME, DATABASE_PORT)
	tmysql.query( ... )
end

function mysql.Insert( name , keys , values )
	local str = "INSERT INTO "
	str = str .. name
	local str2 = " ( "
	
	for k,v in ipairs( keys ) do
		if k == 1 then
			str2 = str2 .. v 
		else
			str2 = str2 .. "," .. v 
		end
	end
	str2 = str2 .. " ) VALUES( "

	for k,v in ipairs( values ) do
		if type( v ) == "number" then
			if k == 1 then
				str2 = str2 .. " " .. v .. ""
			else
				str2 = str2 .. ", " .. v .. ""
			end
		else
			if k == 1 then
				if ( !tmysql.escape(v) ) then print( "NIL VALUE IN " .. k .. " POSITION", name )
					PrintTable( keys )
					PrintTable( values )
				end
				str2 = str2 .. " '" .. tmysql.escape(v) .. "'"
			else
				if ( !tmysql.escape(v) ) then print( "NIL VALUE IN " .. k .. " POSITION", name )
					PrintTable( keys )
					PrintTable( values )
				end
				str2 = str2 .. ", '" .. tmysql.escape(v) .. "'"
			end
		end
	end
	str = str .. str2 .. " )" 

	mysql.Query(str , DATABASE_HANDLE or function() end )
end

function mysql.CreateTable(name , specs)
	local str = "CREATE TABLE IF NOT EXISTS "
	str = str .. name
	local str2 = "( "
	
	for k , v in ipairs( specs ) do
		if k==1 then 
			str2 = str2 .. v[1] .. " " .. v[2]
		else
			str2 = str2 .. " , " .. v[1] .. " " .. v[2]
		end
	end
	str = str .. str2 .. " ) "
	mysql.Query(str , DATABASE_HANDLE or function() end )

	return str
end

function mysql.DropTable(name )
	mysql.Query("DROP TABLE " .. name .." IF EXISTS" , DATABASE_HANDLE or function() end )
end

function mysql.RenameTable(name,newname )
	mysql.Query("RENAME TABLE " .. name .." TO " .. newname , DATABASE_HANDLE or function() end )
end

function mysql.CreateUser(name,pass )
	mysql.Query("CREATE USER '" .. name .."' IDENTIFIED BY " .. pass , DATABASE_HANDLE or function() end )
end

function mysql.EmptyTable( name )
	mysql.Query("TRUNCATE TABLE " .. name , DATABASE_HANDLE or function() end )
end

function mysql.SelectAllFromTable( name, callback  )
	mysql.Query("SELECT * FROM " .. name , callback or DATABASE_HANDLE or function() end )
	return mysql
end

function mysql.SelectFromTable( name , t , callback )
	mysql.Query("SELECT " .. table.concat( t, ", " ) .. " FROM " .. name , callback or DATABASE_HANDLE or function() end )
	return mysql
end