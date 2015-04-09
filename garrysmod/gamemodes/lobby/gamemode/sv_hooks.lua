hook.Add("PlayerSpawn", "PISCollisions", function(ply)
	ply:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
end)

hook.Add("PhysgunPickup", "NoFuncForFun", function( ply, ent )
	if ( IsValid( ent ) and ent:GetClass() == "player" ) then return ( ply:IsPrivAdmin() and !ent:IsPrivAdmin() ) end
	
	local Class = ent:GetClass()
	return ( string.sub( Class, 1, 5 ) != "func_" and string.sub( Class, 1, 5 ) != "prop_" )
end )

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
