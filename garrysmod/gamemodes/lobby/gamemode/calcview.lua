function GM:CalcVehicleThirdPersonView( Vehicle, ply, origin, angles, fov )

	local view = {}
	view.angles		= angles
	view.fov 		= fov
	
	if ( !Vehicle.CalcView ) then
	
		Vehicle.CalcView = {}
		
		// Try to work out the size
		local min, max = Vehicle:WorldSpaceAABB()
		local size = max - min
		
		Vehicle.CalcView.OffsetUp = size.z
		Vehicle.CalcView.OffsetOut = (size.x + size.y + size.z) * 0.8
	
	end
	
	// Offset the origin
	local Up = view.angles:Up() * Vehicle.CalcView.OffsetUp * 0.66
	local Offset = view.angles:Forward() * -Vehicle.CalcView.OffsetOut
	
	// Trace back from the original eye position, so we don't clip through walls/objects
	local TargetOrigin = Vehicle:GetPos() + Up + Offset
	local distance = origin - TargetOrigin
	
	local trace = {
					start = origin,
					endpos = TargetOrigin,
					filter = Vehicle
				  }
				  
				  
	local tr = util.TraceLine( trace ) 
	
	view.origin = origin + tr.Normal * (distance:Length() - 10) * tr.Fraction
		
	return view

end

function GM:CalcView( ply, origin, angles, fov )
	
	local Vehicle = ply:GetVehicle()
	local wep = ply:GetActiveWeapon()
	
	self.OnThirdPerson = (IsValid( Vehicle ) --[[&& gmod_vehicle_viewmode:GetInt() == 1]]) || (IsValid(ply) && !ply:Alive() && IsValid(ply:GetRagdollEntity()))
	
	if self.OnThirdPerson && IsValid( Vehicle ) then
		return GAMEMODE:CalcVehicleThirdPersonView( Vehicle, ply, origin*1, angles*1, fov )
	end

	--[[local ScriptedVehicle = ply:GetScriptedVehicle()
	if ( ValidEntity( ScriptedVehicle ) ) then
	
		// This code fucking sucks.
		local view = ScriptedVehicle.CalcView( ScriptedVehicle:GetTable(), ply, origin, angles, fov )
		if ( view ) then return view end

	end]]--

	local view = {}
	view.origin 	= origin
	view.angles		= angles
	view.fov 		= fov
	
	// Give the active weapon a go at changing the viewmodel position
	
	if ( IsValid( wep ) ) then
	
		local func = wep.GetViewModelPosition
		if ( func ) then
			view.vm_origin,  view.vm_angles = func( wep, origin*1, angles*1 ) // Note: *1 to copy the object so the child function can't edit it.
		end
		
		local func = wep.CalcView
		if ( func ) then
			view.origin, view.angles, view.fov = func( wep, ply, origin*1, angles*1, fov ) // Note: *1 to copy the object so the child function can't edit it.
		end
	
	end
	
	return view
	
end