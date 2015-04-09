-- Incoming.lua

GAME.Name 				= "Incoming";
GAME.GMName 			= "Lobby: Incoming";
GAME.ServerID 			= 6;
GAME.Pass 				= ""

GAME.MaxPlayers			= 16;
GAME.Description 		= "Avoid the deathly falling objects!";

GAME.IP 				= "";
GAME.Port 				= 27015;

GAME.CurrentPlayers 	= 0
GAME.Message 			= "Incoming"
GAME.Map 				= ""
GAME.Status 			= 0
GAME.LastUpdate 		= 0
GAME.Online 			= false;
GAME.NextStatus 		= false
GAME.NextMessage		= false



function GAME:OnServerLoad( MyGamemode ) -- True if this is the gamemode being loaded

	if MyGamemode then
		self.Pass = self:GenerateRandomPass( )
	end

end