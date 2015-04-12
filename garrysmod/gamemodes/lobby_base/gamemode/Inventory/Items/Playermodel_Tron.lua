-- Test Item

ITEM.ShopID 		= 1
ITEM.Base			= "_playermodelbase"

ITEM.Name 			= "Tron Player Model"
ITEM.UniqueName 	= "TronPlayerModel"
ITEM.Description 	= "This is just a test"
ITEM.Price			= 200

ITEM.Model 			= "models/player/anon/anon.mdl"
ITEM.Hooks			= {"PlayerSetModelPost"}
ITEM.BodyGroups		= {{3,1},{4,1}}

function ITEM:Init()
	player_manager.AddValidModel( "Tron Anon", 		"models/player/anon/anon.mdl" );
	player_manager.AddValidHands( "Tron Anon", "models/weapons/arms/anon_arms.mdl", 0, "00000000" )
end