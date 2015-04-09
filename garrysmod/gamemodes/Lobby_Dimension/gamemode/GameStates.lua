-- GameStates.lua

-- Put this in your gamemode to get functionality for multiservers
-- Defines : GM.ServerID


STATE_IDLE = 0
STATE_JOINING = 1
STATE_PLAYING = 2
STATE_FINISHED = 0

function GM:SetServerState( State )

	MultiServer.GamesSys.GetGamemodeInformation( self.ServerID ):SetStatus( State )
	
end



function GM:SetServerMessage( Message )

	MultiServer.GamesSys.GetGamemodeInformation( self.ServerID ):SetMessage( Message )
	
end



function GM:CallServerBaseFunction( Name , ... )

	MultiServer.GamesSys.GetGamemodeInformation( GM.ServerID )[ Name ]( ... )
	
end