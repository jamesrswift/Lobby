-- hooks.lua


function GM:AchievementWon( Pl , AchID )
	
	--Pl:GiveMoney(200, true)
	
	--Achievement.MySQL.GetUser( Pl:UniqueID() )[AchID] = true
	--Achievement.MySQL.Save( Pl:UniqueID() )

end

Achievement.Folder = "Lobby_Base/gamemode/modules/Achievements/Ach/"

function GM:AddAchievements( )

	local AchDir = Achievement.Folder .. ""
	local AchFiles = file.Find( AchDir .. "/*" , "LUA" )

	for k,v in pairs( AchFiles ) do
		ACH = { }
		include( AchDir .. v )
		Achievement.Register( ACH.ID , table.Copy( ACH ) )
		ACH = nil;
	end

end
