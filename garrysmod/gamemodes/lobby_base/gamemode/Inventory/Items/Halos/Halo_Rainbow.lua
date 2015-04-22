-- Awesome halo Item

ITEM.ShopID 		= 1
ITEM.Base			= "_halobase"

ITEM.Name 			= "Rainbow Halo"
ITEM.UniqueName 	= "RainbowHalo"
ITEM.Description 	= "Adds a rainbow halo to your player model"
ITEM.Price			= 200000

ITEM.Color			= Color(255,0,0)
ITEM.HSV			= { ColorToHSV( Color(255,0,0) ) }
ITEM.LastDraw		= 0

function ITEM:GetColor()
	if self.LastDraw < CurTime() then
		self.HSV[1] = ( self.HSV[1] + 40 * FrameTime() ) % 360
		self.LastDraw = CurTime()
	end
	self.Color = HSVToColor( unpack(self.HSV) )
	
	return self.Color
end