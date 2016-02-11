--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, 2015
	
-----------------------------------------------------------]]--


ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.RenderGroup		= RENDERGROUP_OPAQUE
ENT.AutomaticFrameAdvance = true

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