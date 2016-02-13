--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, 2015
	
-----------------------------------------------------------]]--

GM.Name					= "Lobby2: Plane Crazy"
GM.Author				= "James Swift"
GM.Email				= "n/a"
GM.Website				= ""
GM.AllowDownload			= false
GM.RemoveDefaultHUD			= false

GM.ServerID				= 6

DeriveGamemode( "lobby2_base" )

function GM:OnGamemodeLoaded( )

	self:LoadModules({
		"currency",
		"scoreboard",
		"location"
	})

end

TEAM_PLAYERS = 200

function GM:CreateTeams()


	team.SetUp( TEAM_PLAYERS, "Players", Color( 255, 255, 100 ), true )
	team.SetSpawnPoint( TEAM_PLAYERS, "info_player_start" )
	team.SetClass( TEAM_PLAYERS, { "Default" } )
	
end

function GM:DoExplosion( pl )

	if ( !IsValid( pl ) ) then return end
	
	util.BlastDamage( pl, pl, pl:GetPos(), 300, 200 )
		
	local effectdata = EffectData()
		effectdata:SetOrigin( pl:GetPos() )
 	util.Effect( "Explosion", effectdata, true, true )

end

function GM:Move( pl, mv )

	if ( !pl:Alive() ) then return end
	if ( pl:Team() == TEAM_SPECTATOR ) then return end
	--if ( !pl:GetNWFloat( "Speed", false ) ) then return end
	
	local vel = pl:GetNWFloat( "Speed", 100 )
	local accel = 30.0
	
	local Dot = pl:GetAimVector():Dot( Vector( 0, 0, -1 ) )
	
	-- Boost, todo, make temporary
	if ( pl:KeyDown( IN_JUMP ) ) then
		Dot = Dot + 5.0
	end
	
	vel = math.Clamp( vel + Dot * FrameTime() * accel, 0, 1000 )
	
	if ( vel > 200 && !pl:KeyDown( IN_JUMP ) ) then
		vel = vel - ( FrameTime() * 120 )
	end
	
	pl:SetNWFloat( "Speed", vel )

	local Velocity = pl:GetAimVector() * vel * 5
	
	local Target = pl:GetPos() + Velocity * FrameTime()

	
	--debugoverlay.Line( pl:GetPos(), Target, 10 )
	
	local trace = { start = pl:GetPos(), endpos = Target, filter = pl }	  
	local tr = util.TraceLine( trace )
	
	if ( tr.Hit ) then
		
		pl:SetPos( tr.HitPos + tr.HitNormal * 50 )
		mv:SetVelocity( Vector(0,0,0) )
		
		if ( SERVER ) then
			timer.Simple( 0, function() GAMEMODE:DoExplosion( pl ) end )
			pl:Kill()
		end
	
	else
	
		mv:SetVelocity( Velocity )
		mv:SetOrigin( Target )
	
	end	
	
	return true

end