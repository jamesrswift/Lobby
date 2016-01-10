--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, 2015
	
-----------------------------------------------------------]]--

util.AddNetworkString( "lobby.chat.PlayerChatPrint" )

local Meta = FindMetaTable( "Player" )

function GM:CheckPassword( steamid64, networkid, server_password, password, name )

	local ban = self:IsPlayerBanned( steamid64 )
	if ( ban ) then
		return false, string.format( "You are currently banned, for reason \"%s\". You're ban will be lifted on %s.", ban.reason, os.date( "%H:%M, %A %d %M, %Y", ban.start + ban.length ) )
	end

	if ( server_password != "" ) then

		if ( server_password != password ) then
			return false, "#GameUI_ServerRejectBadPassword"
		end

	end

	return true

end

function GM:PlayerAuthed( Pl )

	self:LoadPlayerInformation( Pl )
	local data = Pl:GetData( )
	
    if Pl.IsFullyAuthenticated and not Pl:IsFullyAuthenticated() then
		Pl:ChatPrint( "Hey '%s' - Your SteamID wasn't fully authenticated, so your usergroup has not been set to '%s.'", Pl:Nick(), data.usergroup )
		Pl:ChatPrint("Try restarting Steam.")
		return
    end

	ply:SetUserGroup(SteamIDs[steamid].group)
	ply:ChatPrint( "Hey '%s' - You're in the '%s' group on this server.", Pl:Nick(), data.usergroup )

end

function GM:PlayerSpray( Pl )

	return ( not Pl:IsRespected( ) )

end

function GM:PlayerSpawn( Pl )

	Pl:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
	
	hook.Run( "PlayerSetModel", Pl )

end


function GM:PhysgunDrop( Pl, ent )

	if ( IsValid( ent ) and string.lower( ent:GetClass( ) ) == "player" ) then
		ent:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
	end
	
end

function GM:PlayerSwitchFlashlight( Pl, IsOn )

	if ( not Pl:IsRespected( ) ) then
		
		if ( not Pl.FlashLightTime ) then Pl.FlashLightTime = 0 end
		if ( Pl.FlashLightTime > CurTime() ) then return false end
		
		Pl.FlashLightTime = CurTime() + 1
		
	end

	return true
	
end

function GM:PhysgunPickup( Pl, ent )
	
	if ( Pl:IsAdmin() and string.lower( ent:GetClass( ) ) == "player"  ) then
		return true
	end
	
end

function GM:ShowTeam( ply )

	if ( !GAMEMODE.TeamBased ) then return end
	
	-- I'll figure out what to put here soon enough

end

function GM:PlayerNoClip( Pl, bState )

	return Pl:IsAdmin( )

end

function GM:PlayerSetModel( ply )

	local model = ply:GetInfo( "cl_playermodel" )
	local allow = hook.Run("AllowModel", ply, model, skin )
	if ( not model or allow ~= true ) then
		model, skin = "none", 0
	end
	
	local modelname = player_manager.TranslatePlayerModel( model )
	util.PrecacheModel( modelname )	
	ply:SetModel( modelname )
	
	ply:SetPlayerColor( Vector(1,1,1) )

	hook.Run("PlayerSetModelPost", ply, model, skin )
	
end

function GM:AllowModel( Pl, Model, Skin )


end

function GM:PlayerSetModelPost( Pl, Model, Skin )


end

function Meta:ChatPrint( str, ... )

	if ( str and string.len( str ) > 0 ) then
	
		net.Start( "lobby.chat.PlayerChatPrint" )
		net.WriteString( string.format( str, ... ) )
		net.Send( self )
		
	end
	
end