--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, 2015
	
-----------------------------------------------------------]]--


include('shared.lua')


function ENT:Initialize()

	self.Player = ClientsideModel( "models/player/alyx.mdl", RENDERGROUP_BOTH )
	self.Player:SetIK( false )
	PrintTable( self.Player:GetSequenceList() )

end

function ENT:Draw()

	self.Player:SetPos( self:GetPos() - Vector( 0, 0, 40 ) )
	self:UpdateAnimation( self:GetVelocity( ), 250 )
	self:DrawModel()
	
	self.LastPaint = RealTime()
	
end

function ENT:DrawTranslucent()

	self:Draw()
	
end

function ENT:UpdateAnimation( velocity, maxseqgroundspeed )

	if ( not IsValid( self.Player ) ) then return end

	local len2d = velocity:Length2D()
	local len = velocity:Length()
	local Sequence = self.Player:LookupSequence( "walk_all" )
	
	local movement = 1.0
	if ( len > 0.2 ) then
		movement = ( len / maxseqgroundspeed )
	end
	
	self.m_fAnimSpeed = math.min( movement, 2 )
	self.Player:SetPlaybackRate( self.m_fAnimSpeed )
	self.Player:FrameAdvance( ( RealTime() - (self.LastPaint or RealTime() ) ) * self.m_fAnimSpeed )
	
	if ( len2d > 150 ) then
	
		Sequence = self.Player:LookupSequence( "run_all_01" )
		
	elseif ( len2d > 0.5 ) then
		
		Sequence = self.Player:LookupSequence( "walk_all" )
		
	end

	self.Player:ResetSequence( 311 )
	
end

function ENT:OnRemove()

	self.Player:Remove( )
	
end