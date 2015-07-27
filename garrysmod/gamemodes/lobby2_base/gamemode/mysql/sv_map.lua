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

	local query = self.MySQL.BuildQuery( "SELECT * FROM gm_maps WHERE map = %s LIMIT 1", MapName )

	if ( query ) then
		tmysql.query( query, function( results )
			PrintTable( results )
			if ( results[1] ) then
			
			
		
				hook.Run( "MapInformationLoaded", MapName )
			else
				self:Print( "[MySQL] There was an error while loading map information!" );
			end
		end )
	end

end

function GM:GetMapData( MapName )
	
	GM.MySQL.MapData[MapName] = GM.MySQL.MapData[MapName] or { }
	return GM.MySQL.MapData[MapName]

end

function GM:SaveMapData( MapName )


end