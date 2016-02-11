--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, 2015
	
-----------------------------------------------------------]]--

GM.MySQL.MapData = GM.MySQL.MapData or {};

function GM:LoadMapInformation( MapName )

	self.MySQL.SelectAll( "gm_maps", function( results )
	
		for row_id, row in pairs( results ) do
		
			local info = util.JSONToTable( row.json_data )
			if ( info ) then
			
				self.MySQL.MapData[ row.map_name ] = info
				hook.Run( "MapInformationLoaded", row.map_name )
				
			else
			
				self:Print( "[MySQL] Error while loading map information for %s!", row.map_name );
			
			end
		
		end
	
	end, (MapName and "WHERE map_name = %s LIMIT 1"), MapName )

end

function GM:GetMapData( MapName )

	MapName = MapName or game.GetMap()
	self.MySQL.MapData[ MapName ] = self.MySQL.MapData[ MapName ] or { }
	
	return self.MySQL.MapData[ MapName ]

end

function GM:SaveMapData( MapName )

	MapName = MapName or game.GetMap()
	local query = self.MySQL.BuildQuery( "REPLACE INTO gm_maps ( map_name, json_data ) Values ( '%s', '%s' )", MapName, util.TableToJSON( self:GetMapData( MapName ) ) )

	if ( query ) then
		tmysql.query( query, function( results )
	
		end )
	end

end