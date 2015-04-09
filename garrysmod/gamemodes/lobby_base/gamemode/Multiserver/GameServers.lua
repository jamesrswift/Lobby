-- GameServers.lua
-- This information will be used sometime, I have a vaigue idea of when.

if !MultiServer then MultiServer = { }; end
MultiServer.GamesSys = { };
local GamesSys = MultiServer.GamesSys;

--require( 'glon' )

GamesSys.Loaded = { };
GamesSys.Folder = "Lobby_Base/gamemode/multiserver/gamemodes/"

function GamesSys.GenerateRandomPass( )

	local m = "abcdefghijklmnopqrstuvwxyz1234567890"
	tt = string.ToTable( m )
	local s = ""
	for i=1,8 do
		s = s .. tt[ math.random( 1 , #tt ) ]
	end
	
	return s

end

local _GAME = {

	SetStatus = function( self, State )
		self.NextStatus = State
		self:UpdateMySQL( )
	end,
	
	SetMessage = function( self, Message )

		self.NextMessage = Message
		self:UpdateMySQL( )
		
	end,
	
	UpdateMySQL = function( self )

		self.CurrentPlayers = #player.GetAll()
		self.Message = self.NextMessage or self.Message
		self.Map = game.GetMap()
		self.Status = self.NextStatus or self.Status
		self.LastUpdate = os.time()
		self.Online = true;

		MultiServer.MySQL.UpdateServerInformation( self.ServerID , self.CurrentPlayers , self.Message , self.Map , self.Status, self.Pass )

	end,
	
	GenerateRandomPass = GamesSys.GenerateRandomPass

}

function GamesSys.Load( )

	local GamesDir = GamesSys.Folder .. ""
	local GamesFiles = file.Find( GamesDir .. "/*" , "LUA" )
	
	if table.Count( GamesFiles ) == 0 then
		ErrorNoHalt( "[Multiserver] No gamemodes to be registered!!\n")
		return
	end
	
	for k,v in pairs( GamesFiles ) do
		GAME = table.Copy( _GAME )
		include( GamesDir .. v )
		GamesSys.Loaded[ GAME.ServerID ] = table.Copy(GAME)
		Msg( "GameServer Loaded: " .. GAME.Name .. "\n" )
		GAME = nil;
	end
	
end

function GamesSys.GetGamemodeInformation( ID )

	return GamesSys.Loaded[ ID ] or false
	
end

hook.Add( "Initialize" , "GameSys:Load" , function( )

	for k,v in pairs( MultiServer.GamesSys.Loaded ) do
	
		if GAMEMODE.Name == v.GMName then timer.Create( "ServerUpdate:"..v.ServerID , 5 , 0 , GamesSys.UpdateAllMySQL ) end
		v:OnServerLoad( GAMEMODE.Name == v.GMName );
	
	end

end)

function GamesSys.UpdateAllMySQL()

	for k,v in pairs( MultiServer.GamesSys.Loaded ) do
	
		if GAMEMODE.Name == v.GMName then v:UpdateMySQL( ) end
	
	end
end

GamesSys.Load( )