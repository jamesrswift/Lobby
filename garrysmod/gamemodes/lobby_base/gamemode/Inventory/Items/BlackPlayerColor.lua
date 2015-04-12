-- Test Item

ITEM.ShopID 		= 1

ITEM.Name 			= "Black Player Colour"
ITEM.UniqueName 	= "BlackPlayerColour"
ITEM.Description 	= "This is just a test"
ITEM.Price			= 200

ITEM.Player			= false
ITEM.Color			= Vector( 0,0,0 ) -- Vector for SetPlayerColor
ITEM.Hooks			= {"PlayerSetModelPost"}

function ITEM:OnEquip( _Player )
	self.Equiped = true
	self.Player = _Player
	_Player:SetPlayerColor( self.Color )
end

function ITEM:PlayerSetModelPost( ply, model, skin )
	if self.Equiped and self.Player then
		self.Player:SetPlayerColor( self.Color )
	end
end

function ITEM:OnHolister( _Player )
	self.Equiped = false
	self.Player = false
end