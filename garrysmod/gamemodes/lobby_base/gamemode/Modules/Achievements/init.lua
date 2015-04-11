-- Init.lua

Achievement = { }
Achievement.Loaded = { }

ACHIEVEMENT_ONCE = 0
ACHIEVEMENT_INCR = 1

include( "mysql.lua" )
include( "hooks.lua" )

AddCSLuaFile( "cl_init.lua" )

-- Table :
--			-Name
--			-Type
--			-Max

function Achievement.Init( )
	hook.Call( "AddAchievements" , GAMEMODE ) -- For Adding Achievements
end
hook.Add( "Initialize" , "Achievements" , Achievement.Init )


function Achievement.Register( ID , Table )

	if ( !Table.Max ) then
		Table.Max = 1
		Table.Type = ACHIEVEMENT_ONCE
	end
	
	if ( Table.Type == ACHIEVEMENT_ONCE and Table.Max > 1 ) then
		Table.Max = 1
	end
	
	if ( Table.Type == ACHIEVEMENT_INCR and Table.Max < 2 ) then
		Table.Max = 1
		Table.Type = ACHIEVEMENT_ONCE
	end
	
	if Table.Hooks then
		for k,v in pairs ( Table.Hooks ) do
			if Table[v] then
				hook.Add( v, "Achievement."..Table.ID, function(...) return Table[v](Table, ... ) end)
			end
		end
	end

	Achievement.Loaded[ ID ] = Table

end


function Achievement.Get( ID )

	return Achievement.Loaded[ ID ] or false

end

function Achievement.Call( Pl, ID , Amount )

	local User = Achievement.MySQL.GetUser( Pl:UniqueID() )
	if ( User[ID] == true ) then return end

	local Ach = Achievement.Get( ID )
	if Ach then
	
		local Type = Ach.Type
		local Max = Ach.Max
		
		if ( Type == ACHIEVEMENT_ONCE ) then
			hook.Call( "AchievementWon" , GAMEMODE, Pl, ID )
			Achievement.MySQL.GetUser( Pl:UniqueID() )[ID] = true
			Achievement.MySQL.Save( Pl:UniqueID() )
			return
		end
		
		if ( Type == ACHIEVEMENT_INCR and Pl.Achievements[ ID ] < Max ) then
			Achievement.MySQL.GetUser( Pl:UniqueID() )[ID] = Achievement.MySQL.GetUser( Pl:UniqueID() )[ID] + 1
			if ( Pl.Achievements[ ID ] == Max ) then
				hook.Call( "AchievementWon" , GAMEMODE, Pl, ID )
				Achievement.MySQL.GetUser( Pl:UniqueID() )[ID] = true
				Achievement.MySQL.Save( Pl:UniqueID() )
			end
			Achievement.MySQL.Save( Pl:UniqueID() )
		end
	
	end

end