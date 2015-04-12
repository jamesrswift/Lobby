-- BaseHaloItem

ITEM.ShopID 		= 0

ITEM.Name 			= "Halo Base"
ITEM.UniqueName 	= "_halobase"
ITEM.Description 	= "Item base for halos"
ITEM.Price			= 20000

ITEM.Hooks			= {"PreDrawHalos"}
ITEM.Player			= false

function ITEM:OnEquip( _Player )
	self.Equiped = true
	self.Player = _Player
end

function ITEM:GetColor()
	return self.Color or Color(0,0,0)
end

function ITEM:PreDrawHalos()
	if self.Equiped and self.Player and self:GetColor() then
		if self.Player:Alive() then
			halo.Add( {self.Player}, self:GetColor(),5,5 )
		else
			halo.Add( {self.Player:GetRagdollEntity()}, self:GetColor(),5,5 )
		end
	end
end

function ITEM:OnHolister( _Player )
	self.Equiped = false
	self.Player = false
end