-- Test Item

ITEM.ShopID 		= 1

ITEM.Name 			= "Alyx Player Model"
ITEM.UniqueName 	= "AlyxPlayerModel"
ITEM.Description 	= "This is just a test"
ITEM.Price			= 200

ITEM.Model 			= "models/player/alyx.mdl"

function ITEM:OnBuy( _Player )


end

function ITEM:OnSell( _Player )


end

function ITEM:OnEquip( _Player )
	_Player:SetModel( self.Model )
end

function ITEM:OnHolister( _Player )


end

function ITEM:CanPlayerBuy( _Player )


end

function ITEM:CanPlayerSell( _Player )


end

function ITEM:CanPlayerTrade( _Player )


end

function ITEM:CanPlayerEquip( _Player )


end

function ITEM:CanPlayerHolister( _Player )


end

