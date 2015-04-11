
LobbyAdmins = {
	["STEAM_0:0:0"] = true, // Localhost
	["STEAM_0:1:22894915"] = true// Neo
}

LobbyPrivAdmins = {
	["STEAM_0:0:0"] = true,
	["STEAM_0:1:19259989"] = true //OMGMac
}

LobbyVip = {
	--["STEAM_0:0:0"] = true,
	--["STEAM_0:1:22894915"] = true //steamid goes here!
}

local PlayerMeta = FindMetaTable("Player")

function PlayerMeta:IsVip()
	local steam = self:SteamID()
	return ( LobbyVip[steam] or self:IsPrivAdmin() or false)
end

function PlayerMeta:IsPrivAdmin()
	local steam = self:SteamID()
	return ( LobbyPrivAdmins[steam] or self:IsAdmin() or false)
end

function PlayerMeta:IsAdmin()
	local steam = self:SteamID()
	return (LobbyAdmins[steam] or false)
end

hook.Add("PlayerInitialSpawn", "LobbyCheckAdmin", function(ply)
	if ply:IsAdmin() then
		ply:SetUserGroup( "superadmin" )
	elseif ply:IsPrivAdmin() then
		ply:SetUserGroup( "privadmin" )
	elseif ply:IsVip() then
		ply:SetUserGroup( "vip" )
	end
end )

hook.Remove( "PlayerInitialSpawn", "PlayerAuthSpawn")


color_admin = Color(255, 100, 100, 255)
color_privadmin = Color(185, 100, 255, 255)
color_respected = Color( 30 , 125 , 255 , 255 )
--color_respected = Color( 120 , 245 , 87 , 255 )
color_default = Color( 255, 255, 100, 255 )

function PlayerMeta:GetDisplayTextColor( )

	if GAMEMODE.TeamBased then return table.Copy(color_default) end

	if self:IsPrivAdmin() and self:GetNWBool( "bIsUndercover" ) then
		return table.Copy(color_default)
	end
	
	if self:IsAdmin() then
		return table.Copy(color_admin)
	elseif self:IsPrivAdmin() then
		return table.Copy(color_privadmin)
	elseif self:IsVip( ) then
		return table.Copy(color_respected)
	end
	
	return table.Copy(color_default)
	
end


function GM:PlayerSetModel( ply )
	local model = ply:GetInfo( "cl_playermodel" )
	local allow = hook.Call("AllowModel", GAMEMODE, ply, model, skin )
	if !model || allow != true then
		model, skin = "none", 0
	end
	
	local modelname = player_manager.TranslatePlayerModel( model )
	util.PrecacheModel( modelname )	
	ply:SetModel( modelname )

	hook.Call("PlayerSetModelPost", GAMEMODE, ply, model, skin )
end

local bannedmodels = {
	"models/player/alyx.mdl"
}

function GM:AllowModel( ply, model )
	return not table.HasValue( bannedmodels, model )
end

function GM:PlayerSpray( ply )
	return !(ply:IsAdmin())
end

function GM:PlayerCanHearPlayersVoice( listener, talker )
	return talker:IsAdmin()
end


-- Logger

hook.Add( "PlayerSay" , "ChatLogger" , function( pl , text )
	local nick = ( IsValid( pl ) and pl:Nick() or "CONSOLE" );
	local id = GAMEMODE.ServerID
	
	mysql.Insert( "gm_chat" , { "ServerID" , "Timestamp", "User", "ID" , "Entry" } , { id , os.time(), nick, pl:UniqueID(), text } )

end)

hook.Add("PlayerSpawn", "PISCollisions", function(ply)
	ply:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
end)


hook.Add("PhysgunDrop", "ResetPISCollisions", function(pl, ent)
	if IsValid( ent ) && ent:GetClass() == "player"  then
		ent:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
	end
end)

hook.Add("PlayerSwitchFlashlight", "LobbyFlashLight", function(ply, isOn)

	if !ply:IsPrivAdmin() then
		if !ply.FlashLightTime then ply.FlashLightTime = 0 end
		if ply.FlashLightTime > CurTime() then return false end
		
		ply.FlashLightTime = CurTime() + 1
	end

	return true
	
end)