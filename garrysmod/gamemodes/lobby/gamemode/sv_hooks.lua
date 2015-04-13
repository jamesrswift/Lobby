
hook.Add("PlayerSwitchFlashlight", "LobbyFlashLight", function(ply, isOn)

	if !ply:IsPrivAdmin() then
		if !ply.FlashLightTime then ply.FlashLightTime = 0 end
		if ply.FlashLightTime > CurTime() then return false end
		
		ply.FlashLightTime = CurTime() + 1
	end

	return true
	
end)
