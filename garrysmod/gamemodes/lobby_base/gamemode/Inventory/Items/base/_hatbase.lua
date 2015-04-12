-- Test Item

ITEM.ShopID 		= 0

ITEM.Name 			= "Hat Base"
ITEM.UniqueName 	= "_hatbase"
ITEM.Description 	= "Item base for hats"
ITEM.Price			= 200

ITEM.Player			= false
ITEM.Model 			= "models/props_interiors/pot02a.mdl"
ITEM.Hat			= false
ITEM.Hooks			= {"PostDrawOpaqueRenderables"}
ITEM.Offset			= {Vector = Vector( 0,0,0 ), Angle = Angle(0,0,0), Scale = 1}

function ITEM:CreateHat( )
	self.Hat = ClientsideModel( self.Model , RENDERGROUP_OPAQUE )
	self.Hat:SetNoDraw( true )
	self.Hat:SetModelScale( self.Offset.Scale, 0 )
end

function ITEM:OnEquip( _Player )
	self.Equiped = true
	self.Player = _Player
	
	if not self.Hat and CLIENT then
		self:CreateHat()
	end
end

function ITEM:OnHolister( _Player )
	self.Equiped = false
	self.Player = false
	
	if self.Hat and CLIENT then
		SafeRemoveEntity( self.Hat )
	end
end

function ITEM:CalculateOffset( pos, ang )

	local Aoffset = Angle( self.Offset.Angle.p, self.Offset.Angle.y, self.Offset.Angle.r )
	local Voffset = Vector( self.Offset.Vector.x, self.Offset.Vector.y, self.Offset.Vector.z);
	
	Voffset:Rotate( ang )
	
	ang:RotateAroundAxis(ang:Right(), 	self.Offset.Angle.r); --Rotate around the axis (to the right) -90 degree's
	ang:RotateAroundAxis(ang:Up(), 		self.Offset.Angle.p); --Rotate around the axis (upwards) 90
	ang:RotateAroundAxis(ang:Forward(), self.Offset.Angle.y);
	pos = pos + Voffset

	return pos, ang
end

function ITEM:PostDrawOpaqueRenderables( )
	if self.Player == LocalPlayer() and not self.Player:ShouldDrawLocalPlayer() then return end
	local Ent = self.Player
	if not self.Player:Alive() then Ent = self.Player:GetRagdollEntity() end

	local pos, ang = self:CalculateOffset( Ent:GetBonePosition( 6 ) )

	self.Hat:SetPos( pos )
	self.Hat:SetAngles( ang )
	self.Hat:DrawModel( )
end