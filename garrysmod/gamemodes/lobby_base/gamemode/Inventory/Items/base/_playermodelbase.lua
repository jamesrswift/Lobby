-- Test Item

ITEM.ShopID 		= 0

ITEM.Name 			= "Playermodel Base"
ITEM.UniqueName 	= "_playermodelbase"
ITEM.Description 	= "Item base for playermodels"
ITEM.Price			= 200

ITEM.Player			= false
ITEM.Model 			= "models/player/alyx.mdl"
ITEM.Hooks			= {"PlayerSetModelPost"}
ITEM.BodyGroups		= {}

function ITEM:Init( )
	player_manager.AddValidModel( self.Name, self.Model )
end

function ITEM:OnEquip( _Player )
	self.Equiped = true
	self.Player = _Player
	_Player:SetModel( self.Model )
	self:UpdateBodyGroups()
end

function ITEM:UpdateBodyGroups()
	if self.Player and self.Equiped then
		for k,v in pairs(self.BodyGroups) do
			self.Player:SetBodygroup( v[1], v[2] )
		end
	end
end

function ITEM:PlayerSetModelPost( ply, model, skin )
	if self.Equiped and self.Player and self.Player == ply then
		self.Player:SetModel( self.Model )
		self:UpdateBodyGroups()
	end
end

function ITEM:OnHolister( _Player )
	self.Equiped = false
	self.Player = false
end