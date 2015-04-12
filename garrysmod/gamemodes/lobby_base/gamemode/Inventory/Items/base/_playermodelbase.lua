-- Test Item

ITEM.ShopID 		= 0

ITEM.Name 			= "Playermodel Base"
ITEM.UniqueName 	= "_playermodelbase"
ITEM.Description 	= "Item base for playermodels"
ITEM.Price			= 200

ITEM.Player			= false
ITEM.Model 			= "models/player/alyx.mdl"
ITEM.Hooks			= {"PlayerSetModelPost"}

function ITEM:Init( )
	player_manager.AddValidModel( self.Name, self.Model )
end

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