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

	self:SetModel( "models/lobby/sphere.mdl" )
	--self:PhysicsInit(SOLID_VPHYSICS)
	self:PhysicsInitSphere( 40, "default_silent" )
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	
	local Phys = self:GetPhysicsObject()
	if ( Phys:IsValid() ) then
		Phys:SetMass( 500 )
		Phys:Wake()
	end
	
	-- Change the speeds depending on the tickrate (based on 33 tickrate)
	local Tickrate = FrameTime() / engine.TickInterval()
	self.ForwardSpeed = math.Round(self.ForwardSpeed * Tickrate)
	self.ReverseSpeed = math.Round(self.ReverseSpeed * Tickrate)
	self.StrafeSpeed = math.Round(self.StrafeSpeed * Tickrate)
	
	self.Player = ents.Create( "lobby_ball_player" )
	self.Player:SetPos( self:GetPos() - Vector( 0, 0, 65 ) )
	self.Player.Ball = self
	self.Player:SetOwner( self:GetOwner() )
	self.Player:Spawn()
	self.Player:Activate()
	self.Player:SetColor(Color(255, 255, 255, 0))
	
	--self.Player:SetParent( self )
	
	-- spawn lobby_ball_player
	-- set player as owner
	
end


function ENT:Think()

	local Owner = self:GetOwner()
	local BallPhysObj = self:GetPhysicsObject()
	local Aim = Owner:EyeAngles()
	Aim.r = 0
	Aim.p = 0
	
	--self.Player:SetPos( self:GetPos() )
	
	local Phys = self:GetPhysicsObject()
	if ( Phys:IsValid() ) then
		Phys:SetMass( 500 )
		Phys:Wake()
		self.Player:SetPos( Phys:GetPos() )
	end
	
	self.Player:UpdateAnimation( self:GetVelocity(), 250 )

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

function ENT:OnRemove()

	-- remove lobby_ball_player
	self.Player:Remove( )
	
end