-- Test Item

ITEM.ShopID 		= 1
ITEM.Base			= "_playercolourbase"

ITEM.Name 			= "Rainbow Player Colour"
ITEM.UniqueName 	= "RainbowPlayerColour"
ITEM.Description 	= "This is just a test"
ITEM.Price			= 200

ITEM.Color			= Vector( 1,0,0 ) -- Vector for SetPlayerColor
ITEM.HSV			= { ColorToHSV( Color(255,0,0) ) }
ITEM.Hooks			= {"Think","PlayerSetModelPost"} --For the base

function ITEM:GetColor()
	self.HSV[1] = ( self.HSV[1] + 3 ) % 360
	local c = HSVToColor( unpack(self.HSV) )
	self.Color = Vector( c.r / 255 , c.g / 255, c.b / 255 )
	
	return self.Color
end

function ITEM:Think()
	if self.Equiped and self.Player and SERVER then
		self.Player:SetPlayerColor( self:GetColor() )
	end
end