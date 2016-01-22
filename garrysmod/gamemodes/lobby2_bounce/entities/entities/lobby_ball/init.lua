--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, 2015
	
-----------------------------------------------------------]]--


AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()

	self.Entity:SetModel( "models/lobby/sphere.mdl" )
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	
	local Phys = self:GetPhysicsObject()
	if ( Phys:IsValid() ) then
		Phys:Wake()
	end
	
	-- Change the speeds depending on the tickrate (based on 33 tickrate)
	local Tickrate = FrameTime() * 33
	self.ForwardSpeed = math.Round(self.ForwardSpeed * Tickrate)
	self.ReverseSpeed = math.Round(self.ReverseSpeed * Tickrate)
	self.StrafeSpeed = math.Round(self.StrafeSpeed * Tickrate)

end


function ENT:Think()

	local Owner = self:GetOwner()
	local BallPhysObj = self:GetPhysicsObject()
	local Aim = Owner:EyeAngles()
	Aim.r = 0
	Aim.p = 0

	Owner:SetPos( self:GetPos() )
	
	if ( Owner:KeyDown(IN_FORWARD) ) then
		local Aim = Aim:Forward()
		BallPhysObj:ApplyForceCenter(Aim * ((self.ForwardSpeedBoost or self.ForwardSpeed) - (self.ForwardSlowdown or 0)))
	end
	
	if ( Owner:KeyDown(IN_BACK) ) then
		local Aim = Aim:Forward() * -1
		BallPhysObj:ApplyForceCenter(Aim * self.ReverseSpeed)
	end
	
	if ( Owner:KeyDown(IN_MOVELEFT) ) then
		local Aim = Aim:Right() * -1
		BallPhysObj:ApplyForceCenter(Aim * self.StrafeSpeed)
	end
	
	if (Owner:KeyDown(IN_MOVERIGHT)) then
		local Aim = Aim:Right()
		BallPhysObj:ApplyForceCenter(Aim * self.StrafeSpeed)
	end

	self:NextThink(CurTime())
	
	return true
	
end

function ENT:Break()

	self:Remove()
	
end
