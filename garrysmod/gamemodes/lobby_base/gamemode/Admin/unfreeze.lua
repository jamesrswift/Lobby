
function GM:CanPlayerUnfreeze(ply, ent, physObj)
	return ply:IsAdmin()
end