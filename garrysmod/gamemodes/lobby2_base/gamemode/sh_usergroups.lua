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
	developer 	= Color( 30 , 125, 255, 255 ),
	superadmin 	= Color( 255, 100, 100, 255 ),
	admin 		= Color( 185, 100, 255, 255 ),
	respected 	= Color( 120, 245, 87 , 255 ),
	user 		= Color( 255, 255, 100, 255 )
}

hook.Remove( "PlayerInitialSpawn", "PlayerAuthSpawn")
local Meta = FindMetaTable( "Player" )

function GM.Usergroups.PlayerInformationLoaded( Pl )

	local data = Pl:GetData( )
	if ( data ) then
		if ( data.usergroup ) then
			Pl:SetUserGroup( data.usergroup )
		else
			Pl:SetUserGroup( "user" )
		end
	else
		Pl:SetUserGroup( "user" )
	end

end

hook.Add( "PlayerInformationLoaded", "Usergroups", GM.Usergroups.PlayerInformationLoaded )

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

	local Colors = GAMEMODE.Uergroups.Colors
	
	if GAMEMODE.TeamBased then return table.Copy(Colors.user) end

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