-- Test Item

ITEM.ShopID 		= 1

ITEM.Name 			= "Alyx Player Model"
ITEM.UniqueName 	= "AlyxPlayerModel"
ITEM.Description 	= "This is just a test"
ITEM.Price			= 200

ITEM.Model 			= "models/player/alyx.mdl"
ITEM.Hooks			= {"PlayerSetModelPost"}

function ITEM:OnEquip( _Player )
	self.Equiped = true
	_Player:SetModel( self.Model )
end

function ITEM:PlayerSetModelPost( ply, model, skin )
	if self.Equiped then
		ply:SetModel( self.Model )
	end
end

function ITEM:OnHolister( _Player )
	self.Equiped = false
end