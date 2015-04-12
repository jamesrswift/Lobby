-- Test Item

ITEM.ShopID 		= 1
ITEM.Base			= "_playermodelbase"

ITEM.Name 			= "Doberman Player Model"
ITEM.UniqueName 	= "DobermanPlayerModel"
ITEM.Description 	= "This is just a test"
ITEM.Price			= 200

ITEM.Model 			= "models/player/doberman/doberman5.mdl"
ITEM.Hooks			= {"PlayerSetModelPost"}
ITEM.BodyGroups		= {{3,1},{4,1}}

function ITEM:Init()
	player_manager.AddValidModel( "Doberman5", "models/player/doberman/doberman5.mdl" )
	player_manager.AddValidHands( "Doberman5", "models/weapons/doberarms.mdl", 0, "00000000" )
end

function ITEM:SetCustom( extra )
	if extra == "naked" then
		self.BodyGroups = {{2,1},{3,0},{4,0}}
		self:UpdateBodyGroups()
	end
end