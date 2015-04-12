-- Test Item

ITEM.ShopID 		= 0

ITEM.Name 			= "Playercolour Base"
ITEM.UniqueName 	= "_playercolourbase"
ITEM.Description 	= "Item base for player colour"
ITEM.Price			= 200

ITEM.Player			= false
ITEM.Color			= Vector( 0,0,0 ) -- Vector for SetPlayerColor
ITEM.Hooks			= {"PlayerSetModelPost"}

function ITEM:GetColor()
	return self.Color or Vector(1,1,1)
end

function ITEM:OnEquip( _Player )
	self.Equiped = true
	self.Player = _Player
	_Player:SetPlayerColor( self:GetColor() )
end

function ITEM:PlayerSetModelPost( ply, model, skin )
	if self.Equiped and self.Player then
		self.Player:SetPlayerColor( self:GetColor() )
	end
end

function ITEM:OnHolister( _Player )
	self.Equiped = false
	self.Player = false
end