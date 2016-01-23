--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, Chewgum, 2015
	
-----------------------------------------------------------]]--

function GM:RestartRound()

	self.HasWon = false

	for k, Pl in pairs( player.GetAll() ) do
	
		Pl:SetTeam( 1 )
		Pl:Spawn()
		
		for _, prop_physics in pairs( ents.FindByClass( "prop_physics" ) ) do
			prop_physics:Remove()
		end
		
	end
	
end

local DumbDelay = 0

function GM:RoundThink()

	if ( team.NumPlayers( 1 ) <= 0 and DumbDelay < CurTime()  ) then
		
		self:NotifyAll( "Blue", "No one has won the round! Restarting round in 5 seconds.", 5 )
		timer.Simple( 5, function()
			self:RestartRound()
		end )
		
		DumbDelay = CurTime() + 6
		
	end
	
end