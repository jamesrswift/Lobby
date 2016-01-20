--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, 2015
	
-----------------------------------------------------------]]--

local Meta = FindMetaTable("Player")

function Meta:SpawnBall( Position )

	if ( not IsValid(self) ) then return end
	
	self:KillBall()

	self.Ball = ents.Create("lobby2_bounce_ball")
	self.Ball:SetPos(Position or self:GetPos())
	self.Ball:SetOwner(self)
	self.Ball:Spawn()
	self.Ball:Activate()
	self.Ball:SetColor(Color(255, 255, 255, 0))
	
	self:SpectateEntity(self.Ball)
	self:CrosshairDisable()
	self:SetBall( self.Ball )
	
	
	self:SetColor( Color(255, 255, 255, 0) )
	self:SetMoveType( MOVETYPE_OBSERVER )
	self:Spectate( OBS_MODE_CHASE );
	
end

function Meta:HasBall()

	return IsValid( self.Ball )
	
end

function Meta:SetBall( Ball )

	self.Ball = Ball
	self:SetNetworkedEntity("Ball", self.Ball)

end

function Meta:BreakMelon()

	if ( self:HasMelon() ) then
		
		self.Melon:Break()
		self.Melon = nil
		
	end
	
end
