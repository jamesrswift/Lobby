--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, 2015
	
-----------------------------------------------------------]]--

GM.BannedPlayerModels = { } -- If a model is purchasable, you shouldn't have it for free
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

end

function GM:PlayerSpray( Pl )

	return ( not Pl:IsRespected( ) )

end

function GM:PlayerSpawn( Pl )

	if ( self.TeamBased && ( Pl:Team() == TEAM_SPECTATOR || Pl:Team() == TEAM_UNASSIGNED ) ) then

		self:PlayerSpawnAsSpectator( Pl )
		return
	
	end

	Pl:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
	
	hook.Run( "PlayerLoadout", Pl )
	hook.Run( "PlayerSetModel", Pl )
	
	Pl:SetupHands()
	
	player_manager.OnPlayerSpawn( Pl )
	player_manager.RunClass( Pl, "Spawn" )

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
	
	local model = "kleiner"

	if ( ply:GetData().model and hook.Run("AllowModel", ply, ply:GetData().model ) ) then
		model = ply:GetData().model
	elseif ( hook.Run("AllowModel", ply, ply:GetInfo( "cl_playermodel" ) ) ) then	
		model = ply:GetInfo( "cl_playermodel" )
	end
	
	local modelname = player_manager.TranslatePlayerModel( model )
	util.PrecacheModel( modelname )	
	ply:SetModel( modelname )
	
	ply:SetPlayerColor( Vector(1,1,1) )

	player_manager.RunClass( ply, "SetModel" )
	hook.Run("PlayerSetModelPost", ply, ply:GetModel() )
	
end

function GM:AllowModel( Pl, Model )

	--return not ( self.BannedPlayerModels[ Model ] == true )
	
	return true

end

function GM:AddBannedPlayerModel( Model )

	self.BannedPlayerModels[ Model ] = true

end

function GM:PlayerSetModelPost( Pl, Model )


end

function GM:OnGiveMoney( Pl, Amount )

	self:NotifyPlayer( Pl, "Blue", "You've recieved " .. tonumber( Amount ) .. " credits!", 10 )

end

function Meta:ChatPrint( str, ... )

	if ( str and string.len( str ) > 0 ) then
	
		net.Start( "lobby.chat.PlayerChatPrint" )
		net.WriteString( string.format( str, ... ) )
		net.Send( self )
		
	end
	
end

function GM:PlayerSay( player, text, teamonly )

	if ( not IsValid( player ) ) then
		MsgC( Color( 255, 0, 0, 255 ), "Console", color_white, ": ", text, "\n" )
	else
		MsgC( player:GetDisplayTextColor( ), player:Nick( ), color_white, ": ", text, "\n" )
	end
	
	return text

end

function Meta:Notify( Type, Text, Lifetime )
	
	local GM = GM or gmod.GetGamemode( )
	GM:NotifyPlayer( self, Type, Text, Lifetime )

end
