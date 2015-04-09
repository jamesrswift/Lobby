-- Dimension.lua

GAME.Name 				= "Dimension";
GAME.GMName 			= "Lobby: Dimension";
GAME.ServerID 			= 5;
GAME.Pass 				= ""

GAME.MaxPlayers			= 8;
GAME.Description 		= "Kill your opponant while using matrix-style movements";

GAME.IP 				= "";
GAME.Port 				= 27015;

GAME.CurrentPlayers 	= 0
GAME.Message 			= "Dimension"
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

