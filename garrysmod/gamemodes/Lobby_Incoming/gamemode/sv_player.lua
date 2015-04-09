-- sv_player.lua

local PlayerMeta = FindMetaTable("Player")

function PlayerMeta:WinRound()
	if !GAMEMODE.HasWon then
		self:GiveMoney( GAMEMODE.WinnerSpots[ game.GetMap() ].WinAmount or 50 )
		for k, v in pairs( player.GetAll() ) do
			v:PrintMessage( HUD_PRINTCENTER, self:Nick() .. " has won the round! Round will restart in 5 seconds" ) -- Replace to work with Chat
			GAMEMODE.HasWon = true
		end
		timer.Simple(5, function() GAMEMODE:RestartRound() end)
	end
end

function GM:PlayerLoadout( pl )
	return true
end

local DeathSounds = {
	Sound( "vo/npc/male01/no02.wav" ),
	Sound( "vo/npc/Barney/ba_ohshit03.wav" ),
	Sound( "vo/npc/Barney/ba_ohshit03.wav" ),
	Sound( "vo/npc/Barney/ba_no01.wav" ),
	Sound( "vo/npc/Barney/ba_no02.wav" )
}

function GM:PlayerDeath( Victim, Inflictor, Attacker )
	Victim:EmitSound( DeathSounds[ math.random( 1, #DeathSounds ) ] )
	
	-- Create Ragdoll
	Victim.DeathDoll = ents.Create( "prop_ragdoll" )
	Victim.DeathDoll:SetModel( Victim:GetModel() )
	Victim.DeathDoll:SetPos( Victim:GetPos() + Vector( 0, 0, 1 ) )
	Victim.DeathDoll:SetAngles( Victim:GetAngles() )
	Victim.DeathDoll:Spawn()
	
	--Spectate ragdoll
	Victim:Spectate( OBS_MODE_CHASE )
	Victim:SpectateEntity( Victim.DeathDoll )
	
	-- Message player about progress, change to work with chat
    local Dist = math.abs( math.floor( Victim:GetPos():Distance( GAMEMODE.WinnerSpots[ game.GetMap() ].Spot ) / GAMEMODE.WinnerSpots[ game.GetMap() ].Distance * 100 - 100 ))
	Victim:PrintMessage(HUD_PRINTTALK , "You made it " ..Dist .. "% up the map")
	
	-- Make ragdoll flail
	for i = 0, Victim.DeathDoll:GetPhysicsObjectCount() do
		local bone = Victim.DeathDoll:GetPhysicsObjectNum( i )
		
		if ( IsValid( bone ) ) then
			bone:SetVelocity( Victim:GetVelocity() )
		end
	end

	umsg.Start( "PlayerKilled" )
		umsg.Entity( Victim )
	umsg.End()
end

function GM:PlayerLoadout( ply ) end


function GM:DoPlayerDeath( ply, attacker, dmginfo )
	if ( ply:Team() == 1 ) then
		ply:SetTeam( 2 )
	end
	
	ply:AddDeaths( 1 )
	
	if ( attacker:IsValid() && attacker:IsPlayer() ) then
		if ( attacker == ply ) then
			attacker:AddFrags( -1 )
		else
			attacker:AddFrags( 1 )
		end
	end
end

function GM:PlayerDeathSound()
	return true
end

function GM:CanPlayerSuicide( ply )
	if ( !ply:Alive() ) then return false end
	if ( ply:Team() == 2 ) then return false end
	
	return true
end