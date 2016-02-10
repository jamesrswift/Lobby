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

function ENT:UpdateAnimation( velocity, maxseqgroundspeed )

	self.CalcIdeal = ACT_MP_STAND_IDLE
	local len2d = velocity:Length2D()
	local len = velocity:Length()
	
	local movement = 1.0
	if ( len > 0.2 ) then
		movement = ( len / maxseqgroundspeed )
	end
	
	self.m_fAnimSpeed = math.min( movement, 2 )
	self:SetPlaybackRate( self.m_fAnimSpeed )
	
	if ( len2d > 150 ) then
	
		local Sequence = self:LookupSequence( "run_all" )
		self:ResetSequence( Sequence )
		
	elseif ( len2d > 0.5 ) then
		
		local Sequence = self:LookupSequence( "walk_all" )
		self:ResetSequence( Sequence )
		
	end
	
	self.m_fAnimSpeed = 0.000001
	
end