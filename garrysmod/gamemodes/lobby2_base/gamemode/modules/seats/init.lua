--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, 2015
	
-----------------------------------------------------------]]--

Module.Hooks = {
	"KeyRelease",
	"CanPlayerEnterVehicle",
	"CanExitVehicle",
	"PlayerDeath",
	"PlayerSilentDeath",
	"PlayerDisconnected",
	"InitPostEntity"
}

Module.ChairOffsets = {}

Module.ChairOffsets["models/props/de_inferno/furniture_couch02a.mdl"] = {
				Vector(7.6080, 0.2916, -5.1108)
}

Module.ChairOffsets["models/props/cs_office/sofa.mdl"] = {
                Vector(12.83425617218, -25.016822814941, 19.691375732422),
                Vector(11.887982368469, 0.47359153628349, 19.074829101563),
                Vector(11.508950233459, 26.898155212402, 18.528305053711),
}

Module.ChairOffsets["models/props/cs_office/sofa_chair.mdl"] = {
                Vector(7.77490234375, -0.62280207872391, 20.302822113037),
}

Module.ChairOffsets["models/props/de_tides/patio_chair2.mdl"] = {
                Vector(1.4963380098343, -1.5668944120407, 17.591537475586),
}

Module.ChairOffsets["models/props_trainstation/traincar_seats001.mdl"] = {
                Vector(4.6150, 41.7277, 18.5313),
                Vector(4.7320, 14.4948, 18.5313),
                Vector(4.5561, -13.3913, 18.5313),
                Vector(5.4507, -40.9903, 18.5313)
}

Module.ChairOffsets["models/props_c17/chair02a.mdl"] = {
                Vector(16.809963226318, 5.6439781188965, 1.887882232666),
}

Module.ChairOffsets["models/props_c17/chair_stool01a.mdl"] = {
                Vector(-0.4295127093792, -1.5806334018707, 35.876251220703),
}

Module.ChairOffsets["models/props/cs_militia/barstool01.mdl"] = {
                Vector(-0.72143560647964, 0.90307611227036, 33.387348175049),
}

Module.ChairOffsets["models/props_interiors/furniture_chair01a.mdl"] = {
                Vector(0.46997031569481, -0.053411800414324, -1.7953878641129),
}

Module.ChairOffsets["models/props/cs_militia/couch.mdl"] = {
                Vector(30.384033203125, 5.251708984375, 15.507431030273),
                Vector(0.44091796875, 4.386474609375, 16.095657348633),
                Vector(-31.472412109375, 6.045166015625, 16.215229034424),
}
Module.ChairOffsets["models/props_c17/furnituretoilet001a.mdl"] = {
                Vector(0.90478515625, -0.208984375, -30.683263778687),
}
Module.ChairOffsets["models/props/cs_office/chair_office.mdl"] = {
                Vector(2.5078778266907, 1.4323912858963, 14.806640625),
}

Module.ChairOffsets["models/props_c17/furniturechair001a.mdl"] = {
                Vector(0.30538135766983, 0.14535087347031, -6.69970703125),
}

Module.ChairOffsets["models/props_combine/breenchair.mdl"] = {
                Vector(6.8169813156128, -2.8282260894775, 16.551658630371),
}

Module.ChairOffsets["models/www.gaming-models.de/couch/couch_2er.mdl"] = {
                Vector(15.7320, 16.4948, 19.5313),
                Vector(15.5561, -15.3913, 19.5313)
}

Module.ChairOffsets["models/www.gaming-models.de/couch/couch_3er.mdl"] = {
				Vector(12.517623901367, -37.104835510254, 21.353481292725),
				Vector(11.715372085571, -2.0069818496704, 21.353481292725),
				Vector(14.980969429016, 36.744983673096, 21.353485107422),
}


Module.NotRight = { }

local function HandleRollercoasterAnimation( vehicle, player )
	return player:SelectWeightedSequence( ACT_GMOD_SIT_ROLLERCOASTER ) 
end

function Module:CreateSeatAtPos(pos, angle)

	local ent = ents.Create("prop_vehicle_prisoner_pod")
	ent:SetModel("models/nova/airboat_seat.mdl")
	ent:SetKeyValue("vehiclescript","scripts/vehicles/prisoner_pod.txt")
	ent:SetPos(pos)
	ent:SetAngles(angle)
	ent:SetNoDraw(true)
	ent:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )

	ent.HandleAnimation = HandleRollercoasterAnimation

	ent:Spawn()
	ent:Activate()

	local phys = ent:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableMotion(false)
	end

	return ent
	
end

function Module:KeyRelease(ply, key)
	if key != IN_USE || ply:InVehicle() || (ply.ExitTime && CurTime() < ply.ExitTime + 1) then return end

	local eye = ply:EyePos()
	local trace = util.TraceLine({start=eye, endpos=eye+ply:GetAimVector()*100, filter=ply})

	if !IsValid(trace.Entity) then return end
	
	if trace.Entity:IsVehicle() then
	
		ply.EntryPoint = ply:GetPos()
		ply.EntryAngles = ply:EyeAngles()
		ply.SeatEnt = trace.Entity
		ply.SeatPos = trace.Entity:GetPos()

		ply:EnterVehicle(trace.Entity)
		trace.Entity:SetOwner( ply )
		
		hook.Run( "PlayerEnterVehicle", ply, ply.SeatEnt )
		
	end

end

function Module:CanPlayerEnterVehicle(ply, vehicle)

	if vehicle:GetClass() != "prop_vehicle_prisoner_pod" then return end
	if vehicle.Removing then return false end
	
	return (vehicle:GetOwner() == ply)
	
end

local airdist = Vector(0,0,48)

function Module:TryPlayerExit(ply, ent)

	local pos = ent:GetPos()
	local trydist = 8
	local yawval = 0
	local yaw = Angle(0, ent:GetAngles().y, 0)

	while trydist <= 64 do
		local telepos = pos + yaw:Forward() * trydist
		local trace = util.TraceEntity({start=telepos, endpos=telepos - airdist}, ply)

		if !trace.StartSolid && trace.Fraction > 0 && trace.Hit then
			ply:SetPos(telepos)
			return
		end

		yaw:RotateAroundAxis(yaw:Up(), 15)
		yawval = yawval + 15
		if yawval > 360 then
			yawval = 0
			trydist = trydist + 8
		end
	end

	print("player", ply, "couldn't get out")
	
	hook.Run( "PlayerStuck", ply, ent )
	
end

function Module:CanExitVehicle( vehicle, ply )
	if vehicle:GetClass() != "prop_vehicle_prisoner_pod" then return end
	
	if !IsValid(ply.SeatEnt) then
		return true
	end

	ply.SeatPos = 0
	ply.SeatEnt = nil

	ply.ExitTime = CurTime()
	ply:ExitVehicle()

	ply:SetEyeAngles(ply.EntryAngles)

	local trace = util.TraceEntity({start=ply.EntryPoint, endpos=ply.EntryPoint}, ply)

	if vehicle:GetPos():Distance(ply.EntryPoint) < 128 && !trace.StartSolid && trace.Fraction > 0 then
		ply:SetPos(ply.EntryPoint)
	else
		self:TryPlayerExit(ply, vehicle)
	end

	--vehicle.Removing = true
	--vehicle:Remove()
	
	hook.Call( "PlayerExitVehicle" , GAMEMODE , ply, vehicle )

	return false

end

function Module:PlayerExitLeft( ply )
	local Vehicle = ply:GetVehicle()
	
	if IsValid( Vehicle ) then
		PlayerLeaveVehice( Vehicle, ply )
	end
end

function Module:InitPostEntity(ent)

	local phys = ents.FindByClass("prop_physics")

	for k,v in pairs(phys) do
		local model = v:GetModel()
		if self.ChairOffsets[model] then
			for x,y in pairs(self.ChairOffsets[model]) do
				local ang = v:GetRight():Angle()
				if self.NotRight[model] then ang = (v:GetForward() * self.NotRight[model]):Angle() end

				local s = self:CreateSeatAtPos(v:LocalToWorld(y), ang)
				s:SetParent(v)
			end
		end
	end
	
	for k,v in pairs(ents.FindByClass("prop_dynamic")) do
		local model = v:GetModel()
		if self.ChairOffsets[model] then
			for x,y in pairs(self.ChairOffsets[model]) do
				local ang = v:GetRight():Angle()
				if self.NotRight[model] then ang = (v:GetForward() * self.NotRight[model]):Angle() end

				local s = self:CreateSeatAtPos(v:LocalToWorld(y), ang)
				s:SetParent(v)
			end
		end
	end

end

function Module:PlayerDeath( ... ) self:PlayerExitLeft(...) end
function Module:PlayerSilentDeath( ... ) self:PlayerExitLeft(...) end
function Module:PlayerDisconnected( ... ) self:PlayerExitLeft(...) end

--[[-----------------------------------
		Debug
-----------------------------------]]--

if ( not Module.Configuration.debug ) then return end
table.insert( Module.Hooks, "KeyPress" )

Module.DEBUGOFFSETS = {}

function Module:KeyPress(ply, key)

	if key != IN_USE then return end

	local trace = util.TraceLine(util.GetPlayerTrace(ply))

	if ( not IsValid(trace.Entity) or (trace.Entity:IsVehicle()) ) then return end

	local ent = self:CreateSeatAtPos(trace.HitPos, trace.Entity:GetRight():Angle())
	constraint.NoCollide(ent, trace.Entity, 0, 0)

	local model = trace.Entity:GetModel()
	
	if !self.DEBUGOFFSETS[model] then self.DEBUGOFFSETS[model] = {} end

	table.insert(self.DEBUGOFFSETS[model], {trace.Entity, ent})
end

local Module = Module

concommand.Add("dump_seats", function()

	for k,v in pairs(Module.DEBUGOFFSETS) do
		print("ChairOffsets[\"" .. tostring(k) .. "\"] = {")
		for k,v in pairs(v) do
			if IsValid(v[2]) then
				local offset = v[1]:WorldToLocal(v[2]:GetPos())
				print("\t\tVector(" .. tostring(offset.x) .. ", " .. tostring(offset.y) .. ", " .. tostring(offset.z) .. "),")
			end
		end
		print("}")
	end
end)