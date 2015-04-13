-- BaseHaloItem

ITEM.ShopID 		= 0

ITEM.Name 			= "Halo Base"
ITEM.UniqueName 	= "_halobase"
ITEM.Description 	= "Item base for halos"
ITEM.Price			= 20000

ITEM.Hooks			= {"PreDrawHalos"}
ITEM.Player			= false
ITEM.ShouldDraw		= true

function ITEM:OnEquip( _Player )
	self.ShouldDraw = hook.Call( "InventoryShouldDrawHalo", GAMEMODE, _Player )
	self.Equiped = true
	self.Player = _Player
end

function ITEM:GetColor()
	return self.Color or Color(0,0,0)
end

function ITEM:PreDrawHalos()
	if self.Player then
		self.ShouldDraw = hook.Call( "InventoryShouldDrawHalo", GAMEMODE, self.Player )
		if self.Equiped and self:GetColor() and self.ShouldDraw then
			if IsValid( self.Player:GetRagdollEntity() ) then
				halo.Add( {self.Player:GetRagdollEntity()}, self:GetColor(),5,5 )
			elseif self.Player:Alive() then
				halo.Add( {self.Player}, self:GetColor(),5,5 )
			end
		end
	end
end

function ITEM:OnHolister( _Player )
	self.Equiped = false
	self.Player = false
end