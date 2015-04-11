-- Test Item

ITEM.ShopID 		= 1

ITEM.Name 			= "Alyx Player Model"
ITEM.UniqueName 	= "AlyxPlayerModel"
ITEM.Description 	= "This is just a test"
ITEM.Price			= 200

ITEM.Player			= false
ITEM.Model 			= "models/player/alyx.mdl"
ITEM.Hooks			= {"PlayerSetModelPost"}

function ITEM:OnEquip( _Player )
	self.Equiped = true
	self.Player = _Player
	_Player:SetModel( self.Model )
end

function ITEM:PlayerSetModelPost( ply, model, skin )
	if self.Equiped and self.Player then
		self.Player:SetModel( self.Model )
	end
end

function ITEM:OnHolister( _Player )
	self.Equiped = false
	self.Player = false
end