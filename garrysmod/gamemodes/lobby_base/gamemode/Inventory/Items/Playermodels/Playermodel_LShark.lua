
ITEM.ShopID 		= 1
ITEM.Base			= "_playermodelbase"

ITEM.Name 			= "Left Shark"
ITEM.UniqueName 	= "LSharkPlayerModel"
ITEM.Description 	= "This is just a test"
ITEM.Price			= 200

ITEM.Model 			= "models/freeman/player/left_shark.mdl"
ITEM.Skin			= 1

function ITEM:SetCustom( extra )
	if extra == "colorable" then
		self.Skin = 0
		self:UpdateSkin()
	else
		self.Skin = 1
		self:UpdateSkin()
	end
end