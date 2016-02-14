--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, Chewgum, 2015
	
-----------------------------------------------------------]]--

util.AddNetworkString( "IncomingWin" )


GM.DeathSounds = GM.DeathSounds or {
	Sound( "vo/npc/male01/no02.wav" ),
	Sound( "vo/npc/Barney/ba_ohshit03.wav" ),
	Sound( "vo/npc/Barney/ba_ohshit03.wav" ),
	Sound( "vo/npc/Barney/ba_no01.wav" ),
	Sound( "vo/npc/Barney/ba_no02.wav" )
}

GM.WinSounds = GM.WinSounds or {
	Sound("vo/coast/odessa/female01/nlo_cheer01.wav"),
	Sound("vo/coast/odessa/female01/nlo_cheer02.wav"),
	Sound("vo/coast/odessa/female01/nlo_cheer03.wav"),
	Sound("vo/coast/odessa/male01/nlo_cheer01.wav"),
	Sound("vo/coast/odessa/male01/nlo_cheer02.wav"),
	Sound("vo/coast/odessa/male01/nlo_cheer03.wav"),
	Sound("vo/coast/odessa/male01/nlo_cheer04.wav"),
	Sound("vo/npc/female01/nice01.wav"),
	Sound("vo/npc/female01/nice02.wav"),
	Sound("vo/npc/female01/thislldonicely01.wav"),
	Sound("vo/npc/male01/nice.wav"),
	Sound("vo/eli_lab/al_gooddoggie.wav"),
	Sound("vo/k_lab/kl_mygoodness01.wav"),
	Sound("vo/k_lab2/al_goodboy.wav"),
	Sound("vo/npc/female01/goodgod.wav"),
	Sound("vo/npc/male01/goodgod.wav"),
	Sound("vo/coast/bugbait/vbaittrain_great.wav"),
	Sound("vo/k_lab2/kl_greatscott.wav")
}

local Meta = FindMetaTable("Player")

function Meta:WinRound()

	local GM = GM or gmod.GetGamemode( )

	if ( not GM.HasWon ) then
	
		self:GiveMoney( GM.WinnerSpots[ game.GetMap() ].WinAmount or 50 )
		
		GM:NotifyAll( "Blue", self:Nick() .. " has won the round! Round will restart in 10 seconds", 10 )
		GM.HasWon = true
		
		net.Start( "IncomingWin" )
			net.WriteEntity( self )
		net.Broadcast( )
		
		self:EmitSound( GM.WinSounds[ math.random( 1, #GM.WinSounds ) ] )
		
		timer.Simple(10, function( )
		
			hook.Run( "RestartRound" )
			
		end)
		
	end
end

function Meta:CalculateDistance( )

	local GM = GM or gmod.GetGamemode( )
	return math.abs( math.floor( self:GetPos():Distance( GAMEMODE.WinnerSpots[ game.GetMap() ].Spot ) / GAMEMODE.WinnerSpots[ game.GetMap() ].Distance * 100 - 100 ))
	
end

function GM:PlayerLoadout( Pl )

	return true
	
end

function GM:PlayerDeath( Pl, Inflictor, Attacker )

	Pl:EmitSound( self.DeathSounds[ math.random( 1, #self.DeathSounds ) ] )
	
	Pl:CreateRagdoll()
	Pl.DeathDoll = Pl:GetRagdollEntity()
	Pl.DeathDoll:SetModel( Pl:GetModel() )
	Pl.DeathDoll:SetPos( Pl:GetPos() + Vector( 0, 0, 1 ) )
	Pl.DeathDoll:SetAngles( Pl:GetAngles() )
	
	Pl:Spectate( OBS_MODE_CHASE )
	Pl:SpectateEntity( Pl.DeathDoll )
	
	self:NotifyPlayer( Pl, "Blue", "You made it " .. Pl:CalculateDistance( ) .. "% up the map", 10 )
	
	for i = 0, Pl.DeathDoll:GetPhysicsObjectCount() do
		local bone = Pl.DeathDoll:GetPhysicsObjectNum( i )
		
		if ( IsValid( bone ) ) then
			bone:SetVelocity( Pl:GetVelocity() )
		end
	end
	
	Pl.NextSpawnTime = CurTime() + 3

end

function GM:DoPlayerDeath( Pl, attacker, dmginfo )

	if ( Pl:Team() == 1 ) then
		Pl:SetTeam( 2 )
	end
	
	Pl:AddDeaths( 1 )
	
	if ( attacker:IsValid() && attacker:IsPlayer() ) then
		if ( attacker == Pl ) then
			attacker:AddFrags( -1 )
		else
			attacker:AddFrags( 1 )
		end
	end
	
end

function GM:PlayerDeathSound()

	return true
	
end

function GM:CanPlayerSuicide( Pl )

	if ( not Pl:Alive() ) then return false end
	if ( Pl:Team() == 2 ) then return false end
	
	return true
	
end
