-- Test Item

ITEM.ShopID 		= 1
ITEM.Base			= "_playermodelbase"

ITEM.Name 			= "Doberman"
ITEM.UniqueName 	= "DobermanPlayerModel"
ITEM.Description 	= "This is just a test"
ITEM.Price			= 200

ITEM.Model 			= "models/player/doberman/doberman5.mdl"
ITEM.Hands			= {"models/weapons/doberarms.mdl", 0, "00000000"}
ITEM.BodyGroups		= {{3,1},{4,1}}

function ITEM:SetCustom( extra )
	if extra == "naked" then
		self.BodyGroups = {{2,1},{3,0},{4,0}}
		self:UpdateBodyGroups()
	else
		self.BodyGroups		= {{3,1},{4,1}}
		self:UpdateBodyGroups()
	end
end