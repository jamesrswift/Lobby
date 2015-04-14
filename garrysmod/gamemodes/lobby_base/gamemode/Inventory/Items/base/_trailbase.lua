-- Test Item

ITEM.ShopID 		= 0

ITEM.Name 			= "Trail base"
ITEM.UniqueName 	= "_trailbase"
ITEM.Description 	= "Item base for trails"
ITEM.Price			= 200

ITEM.Player			= false
ITEM.Color			= Color( 255,255,255 )
ITEM.Material		= "tools/toolsblack.vmt"
ITEM.Hooks			= {"PlayerSpawn","PlayerDeath"}
ITEM.Trail			= false
ITEM.ShouldDraw		= true

function ITEM:GetColor()
	return self.Color or Color(255,255,255)
end

function ITEM:GetMaterial()
	return self.Material .. ".vmt" or "tools/toolsblack.vmt"
end

function ITEM:OnEquip( _Player )
	self.ShouldDraw = hook.Call( "InventoryShouldDrawTrail", GAMEMODE, _Player )
	self.Equiped = true
	self.Player = _Player
	if (not self.Trail and self.ShouldDraw and SERVER) then
		self.Trail = util.SpriteTrail( self.Player, 0, self:GetColor(), false, 15, 1, 0.5, 1/(15+1)*0.5, self:GetMaterial() )
	end
end

function ITEM:PlayerSpawn(ply )
	if ( ply == self.Player ) then
		self.ShouldDraw = hook.Call( "InventoryShouldDrawTrail", GAMEMODE, ply)
		if IsValid(self.Trail) then self.Trail:Remove() end
		if ( self.ShouldDraw and SERVER) then
			self.Trail = util.SpriteTrail( self.Player, 0, self:GetColor(), false, 15, 1, 0.5, 1/(15+1)*0.5, self:GetMaterial() )
		end
	end
end

function ITEM:PlayerDeath(ply)
	if (ply == self.Player and IsValid(self.Trail) and SERVER) then
		self.Trail:Remove()
		self.Trail = false;
	end
end

function ITEM:OnHolister( _Player )
	self.Equiped = false
	self.Player = false
	if self.Trail and SERVER then
		self.Trail:Remove()
		self.Trail = false;
	end
end