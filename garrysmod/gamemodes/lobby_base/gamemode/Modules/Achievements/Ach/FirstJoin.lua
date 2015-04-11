-- First Joined Achievement :L

ACH_FirstJoin = 1

ACH.Name 		= "Welcome to the Lobby!"
ACH.ID 			= ACH_FirstJoin 
ACH.Type		= ACHIEVEMENT_ONCE
ACH.Win			= 50

ACH.Hooks = {"OnPlayerFirstJoined"}

function ACH:OnPlayerFirstJoined( Pl )

	Achievement.Call( Pl, ACH_FirstJoin , 1)

end