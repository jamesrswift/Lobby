-- sh_round.lua

function GM:RestartRound()
	for k, v in pairs( player.GetAll() ) do
		v:SetTeam( 1 )
		v:Spawn()
		self.HasWon = false
		
		for _, v2 in pairs( ents.FindByClass( "prop_physics" ) ) do
			v2:Remove()
		end
	end
end

local DumbDelay = 0

function GM:RoundThink()
	if ( team.NumPlayers( 1 ) <= 0 and DumbDelay < CurTime()  ) then
		DumbDelay = CurTime() + 6
		for _, ply in pairs( player.GetAll() ) do	
			ply:PrintMessage( HUD_PRINTTALK, "No one has won the round!" )
			ply:PrintMessage( HUD_PRINTTALK, "Restarting round in 5 seconds." )
		end
		
		timer.Simple( 5, function()
			self:RestartRound()
		end )
	end
end