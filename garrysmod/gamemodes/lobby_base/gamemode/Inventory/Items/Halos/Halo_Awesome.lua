-- Awesome halo Item

ITEM.ShopID 		= 1
ITEM.Base			= "_halobase"

ITEM.Name 			= "Awesome Halo"
ITEM.UniqueName 	= "AwesomeHalo"
ITEM.Description 	= "Adds an awesome halo to your player model"
ITEM.Price			= 200000

function ITEM:GetColor()
	return Color( math.random(0,255),math.random(0,255),math.random(0,255))
end