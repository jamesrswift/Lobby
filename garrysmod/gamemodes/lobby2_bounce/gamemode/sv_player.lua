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

	self.Ball = ents.Create("lobby_ball")
	self.Ball:SetPos(Position or self:GetPos())
	self.Ball:SetOwner(self)
	self.Ball:Spawn()
	self.Ball:Activate()
	self.Ball:SetColor(Color(255, 255, 255, 0))
	
	self:CrosshairDisable()
	self:SetBall( self.Ball )
	
	
	self:SetColor( Color(255, 255, 255, 0) )
	--self:SetMoveType( MOVETYPE_OBSERVER )
	
	self:SpectateEntity(self.Ball)
	self:Spectate( OBS_MODE_CHASE );
	
end

function Meta:HasBall()

	return IsValid( self.Ball )
	
end

function Meta:SetBall( Ball )

	self.Ball = Ball
	self:SetNetworkedEntity("Ball", self.Ball)

end

function Meta:KillBall()

	if ( self:HasBall() ) then
		
		self.Ball:Break()
		self.Ball = nil
		
	end
	
end


function Meta:GetBall( )

	if ( self:HasBall() ) then
	
		return self.Ball
		
	end
	
	return false
	
end
