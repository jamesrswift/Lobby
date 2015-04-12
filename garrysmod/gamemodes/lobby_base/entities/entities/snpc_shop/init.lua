AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

 
function ENT:Initialize()
 
	self:SetSolid( SOLID_BBOX ) 
	self:SetModel( "models/Humans/Group01/Male_01.mdl" )
	self:SetUseType(SIMPLE_USE)
	
	self.ShopID = 0
 
end

function ENT:Use( Activator )
	print ("pressing enter in snpc")
	if ( Activator:IsPlayer() ) then
		umsg.Start( "ShopOpen" ) umsg.Short( self:GetShopID() ) umsg.End()
	end
end

function ENT:SelectSchedule()
 
	--self:StartSchedule( schdChase )
 
end

function ENT:SetShopID( iShopID )
	self.ShopID = iShopID
end

function ENT:GetShopID( )
	return self.ShopID
end