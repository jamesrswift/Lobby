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
ITEM.Offset			= {{Vector = Vector( 0,0,0 ), Angle = Angle(0,0,0), Scale = 1}}
ITEM.BoneIndex		= 6

function ITEM:CreateHat( )
	self.Hat = ClientsideModel( self.Model , RENDERGROUP_OPAQUE )
	self.Hat:SetNoDraw( true )
	
	local index = 1
	if ( self.Offset[self.Player:GetModel()] ) then index = self.Player:GetModel() end
	self.Hat:SetModelScale( self.Offset[index].Scale, 0 )
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

	local index = 1
	if ( self.Offset[self.Player:GetModel()] ) then index = self.Player:GetModel() end
	local Voffset = Vector( self.Offset[index].Vector.x, self.Offset[index].Vector.y, self.Offset[index].Vector.z) * ( self.Player:GetModelScale() or 1 );
	
	Voffset:Rotate( ang )
	
	ang:RotateAroundAxis(ang:Right(), 	self.Offset[index].Angle.r); --Rotate around the axis (to the right) -90 degree's
	ang:RotateAroundAxis(ang:Up(), 		self.Offset[index].Angle.p); --Rotate around the axis (upwards) 90
	ang:RotateAroundAxis(ang:Forward(), self.Offset[index].Angle.y);
	pos = pos + Voffset

	return pos, ang
end

function ITEM:PostDrawOpaqueRenderables( )
	if not self.Player or not self.Equiped then return end
	if self.Player == LocalPlayer() and not self.Player:ShouldDrawLocalPlayer() then return end
	local Ent = self.Player
	if not self.Player:Alive() then Ent = self.Player:GetRagdollEntity() end

	if (IsValid(Ent) and hook.Call( "InventoryShouldDrawHats", GAMEMODE, self.Player )) then
		local pos, ang = self:CalculateOffset( Ent:GetBonePosition( self.BoneIndex ) )

		local index = 1
		if ( self.Offset[self.Player:GetModel()] ) then index = self.Player:GetModel() end
		self.Hat:SetPos( pos )
		self.Hat:SetAngles( ang )
		self.Hat:SetModelScale( self.Offset[index].Scale, 0 )
		self.Hat:DrawModel( )
	end
end