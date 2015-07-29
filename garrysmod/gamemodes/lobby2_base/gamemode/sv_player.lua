--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, 2015
	
-----------------------------------------------------------]]--

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

function GM:PlayerSpray( Pl )

	return ( not Pl:IsAdmin( ) )

end

function GM:PlayerSpawn( Pl )

	Pl:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )

end


function GM:PhysgunDrop( Pl, ent )

	if ( IsValid( ent ) and string.lower( ent:GetClass( ) ) == "player" ) then
		ent:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
	end
	
end

function GM:PlayerSwitchFlashlight( Pl, IsOn )

	if ( not ply:IsPrivAdmin( ) ) then
		
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
