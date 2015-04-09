// clientside seats!
include("shared.lua")

hook.Add("ShouldDrawLocalPlayer", "seats.shoulddrawlocalplayer", function(ply)
	if (ply:GetVehicle() and IsValid(ply:GetVehicle())) then
		return true
	end
	return false
end)

concommand.Add("GetAimAngle", function()
	local a = LocalPlayer():EyePos()
	local b = LocalPlayer():GetEyeTrace().HitPos
	
	-- dot
	
	local dot = a.x * b.x + a.y*b.y + a.z*b.z
	
	-- mag
	local maga = math.sqrt( a.x^2 + a.y^2 + a.z^2 )
	local magb = math.sqrt( b.x^2 + b.y^2 + b.z^2 )
	
	print ( dot, maga, magb )
	print ( dot / (maga * magb ) )
	print ( math.acos( dot / (maga * magb ) ) )


end)