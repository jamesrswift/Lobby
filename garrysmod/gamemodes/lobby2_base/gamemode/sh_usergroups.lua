--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, 2015
	
-----------------------------------------------------------]]--

GM.Usergroups = GM.Usergroups or {}

GM.Usergroups.Colors = GM.Usergroups.Colors or {
	developer 	= Color( 120, 245, 87 , 255 ),
	superadmin 	= Color( 30 , 125, 255, 255 ),
	admin 		= Color( 255, 100, 100, 255 ),
	respected 	= Color( 185, 100, 255, 255 ),
	user 		= Color( 255, 255, 100, 255 )
}

hook.Remove( "PlayerInitialSpawn", "PlayerAuthSpawn")
local Meta = FindMetaTable( "Player" )

function GM.Usergroups.PlayerInformationLoaded( Pl )

	local data = Pl:GetData( )
	if ( data ) then
		
		if ( data.usergroup ) then
			Pl:SetUserGroup( string.lower( data.usergroup ) )
		else
			Pl:SetUserGroup( "user" )
		end
		
	else
		
		Pl:SetUserGroup( "user" )
		
	end
	
	if ( SERVER ) then
	
		local data = Pl:GetData( )
	
		if Pl.IsFullyAuthenticated and not Pl:IsFullyAuthenticated() then
			Pl:ChatPrint( "Hey '%s' - Your SteamID wasn't fully authenticated, so your usergroup has not been set to '%s.'", Pl:Nick(), data.usergroup )
			Pl:ChatPrint( "Try restarting Steam." )
			Pl:SetUserGroup( "user" )
			return
		end

		if ( data.usergroup ~= "user" ) then
			Pl:ChatPrint( "Hey '%s' - You're in the '%s' group on this server.", Pl:Nick(), data.usergroup )
		end
	
	end

end

function Meta:IsDeveloper( )
	
	return self:IsUserGroup( "developer" )
	
end

function Meta:IsSuperAdmin( )
	
	return self:IsDeveloper() or self:IsUserGroup( "superadmin" )
	
end

function Meta:IsAdmin( )
	
	return self:IsSuperAdmin() or self:IsUserGroup( "admin" )
	
end

function Meta:IsRespected( )
	
	return self:IsAdmin() or self:IsUserGroup( "respected" )
	
end

function Meta:GetDisplayTextColor( )

	local GM = GM or gmod.GetGamemode( )

	local Colors = GM.Usergroups.Colors
	
	if GM.TeamBased then
		return team.GetColor( self:Team() )
	end

	if self:GetNWBool( "bIsUndercover" ) then
		return table.Copy(Colors.user)
	end
	
	if self:IsDeveloper() then
		return table.Copy(Colors.developer)
	elseif self:IsSuperAdmin() then
		return table.Copy(Colors.superadmin)
	elseif self:IsAdmin( ) then
		return table.Copy(Colors.admin)
	elseif self:IsRespected() then
		return table.Copy(Colors.respected)
	end
	
	return table.Copy(Colors.user)
	
end
