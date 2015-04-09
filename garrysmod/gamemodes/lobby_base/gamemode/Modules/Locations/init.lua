include( "shared.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )

local PlayerMeta = FindMetaTable("Player")

function PlayerMeta:GetLocation( )
	local location = "Unknown"
	for k,v in pairs( GAMEMODE.Locations ) do
		for _, ent in pairs( ents.FindInBox( v[2] , v[3] ) ) do
			if self == ent then
				location = v[1]
				break
			end
		end
	end
	return location
end

hook.Add( "Initialize" , "Location" , function()

	if GAMEMODE.OverrideLocation then
	
		for k,v in pairs( player.GetAll() ) do
			v:SetNWString( "Location" , GAMEMODE.OverrideLocation )
		end
	
	else

		timer.Create( "Lobby:SetLocation" , 0.1 , 0 , function()
			for k,v in pairs( player.GetAll() ) do
				if ( v.GetLocation ) then
					v:SetNWString( "Location" , v:GetLocation() )
				else
					v:SetNWString( "Location" ,"Location function not found!" )
				end
			end
		end)
		
	end
	
end)
