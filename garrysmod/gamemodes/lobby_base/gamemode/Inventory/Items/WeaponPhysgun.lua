-- Blue halo Item

ITEM.ShopID 		= 1

ITEM.Name 			= "Physgun"
ITEM.UniqueName 	= "WeaponPhysgun"
ITEM.Description 	= "Admin weapon"
ITEM.Price			= -1

ITEM.Hooks			= {"PlayerLoadout"}
ITEM.Player			= false
ITEM.Weapon			= "weapon_physgun"

function ITEM:CanPlayerBuy() return false end

function ITEM:OnEquip( _Player )
	self.Equiped = true
	self.Player = _Player
	if SERVER then
		self.Player:Give( self.Weapon )
	end
end

function ITEM:PlayerLoadout()
	if self.Equiped and self.Player and SERVER then
		self.Player:Give( self.Weapon )
	end
end

function ITEM:OnHolister( _Player )
	self.Equiped = false
	self.Player = false
	if SERVER then
		_Player:StripWeapon( self.Weapon )
	end
end