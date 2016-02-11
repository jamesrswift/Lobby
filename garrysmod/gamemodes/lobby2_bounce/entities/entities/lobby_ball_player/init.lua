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

	self:SetModel( self:GetOwner():GetModel( ) )

	self:SetModel( "models/player/alyx.mdl" )
	
	
	self:PhysicsInit( SOLID_NONE )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_NONE )

	PrintTable( self:GetSequenceList() )
	
	self.LastThink = RealTime( )
	
end


function ENT:Think()

	self:FrameAdvance( ( RealTime() - self.LastThink ) * ( self.m_fAnimSpeed or 1 ) )
	self.LastThink = RealTime( )
	
	--self:SetPos( self.Ball:GetPos() )
	
	self:NextThink(CurTime())
	
	return true
	
end

function ENT:Break()

	self:Remove()
	
end

function ENT:OnRemove()
	
end
