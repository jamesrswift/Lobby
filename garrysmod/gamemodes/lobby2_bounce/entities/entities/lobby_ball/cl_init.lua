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

	self.Player = ClientsideModel( "models/player/kleiner.mdl", RENDERGROUP_BOTH )
	self.Player:SetIK( true )
	PrintTable( self.Player:GetSequenceList() )
	
	self.LastPos = self:GetPos( )
	self.Lastang = self:GetAngles( )

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
	local Sequence = self.Player:LookupSequence( "walk_fist" )
	
	local movement = 1.0
	if ( len > 0.2 ) then
		movement = ( len / maxseqgroundspeed )
	end
	
	--self.m_fAnimSpeed = math.min( movement, 2 )
	--self.Player:SetPlaybackRate( self.m_fAnimSpeed )
	self.Player:FrameAdvance( ( RealTime() - (self.LastPaint or RealTime() ) ) * 1 )
	
	if ( len2d > 150 ) then
	
		Sequence = self.Player:LookupSequence( "run_fist" )
		
	elseif ( len2d > 0.5 ) then
		
		Sequence = self.Player:LookupSequence( "walk_fist" )
		
	end
	
	local move = self:GetPos() - self.LastPos
	move:Rotate( velocity:Angle() )
	
	self.Player:SetPoseParameter( "move_x", ( math.abs( move.x ) ) )
	self.Player:SetPoseParameter( "move_y", ( math.abs( move.y ) ) )
	self.Player:ResetSequence( Sequence )
	
	self.Player:SetAngles( Angle( 0, velocity:Angle().y, 0 ) )
	self.LastPos = self:GetPos( )
	self.Lastang = self:GetAngles( )
	
	
end

function ENT:OnRemove()

	self.Player:Remove( )
	
end