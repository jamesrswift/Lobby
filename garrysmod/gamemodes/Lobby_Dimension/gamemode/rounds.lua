-- Round.lua
-- For Round System

Round = { }
Round.Active = false
Round.InterRounds = false
Round.Count = 0
Round.Max = 3
Round.Length = 3 * 60
Round.Intermission = 15

-- Hooks :	-- OnRoundStart
			-- OnRoundEnd
			-- WhileRound
			-- WhileInterMission
			-- EndGame
			
-- Functions :
			-- Start
			-- End
			-- CleanUp
			
			
hook.Add( "Tick" , "WhileRound" , function( )

	if Round.Active then
	
		hook.Call( "WhileRound" , GAMEMODE )
		
	elseif Round.InterRounds then
	
		hook.Call( "WhileInterMission" , GAMEMODE )
	
	end

end)


function Round.Start( )

	if Round.Active then return false end

	Round.Count = Round.Count + 1
	Round.Active = true
	Round.InterRounds = false
	
	timer.Simple( Round.Length , Round.End )
	
	hook.Call( "OnRoundStart" , GAMEMODE )

end


function Round.End( )

	Round.CleanUp( )
	
	if ( Round.Count < Round.Max ) then
	
		timer.Simple( Round.Intermission , Round.Start )
		Round.InterRounds = true
		
	else
	
		hook.Call( "GameEnd" , GAMEMODE )
	
	end

end


function Round.CleanUp( )

	game.CleanUpMap( )
	hook.Call( "InitPostEntity" , GAMEMODE )

end