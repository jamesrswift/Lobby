// cl_init

include( "Item.lua" )
include( "shops.lua" )

usermessage.Hook( "ShopOpen" , function( um )

	local ShopID = um:ReadShort()

	local ShopWindow = vgui.Create( "lobby_shop" )
	ShopWindow:SetShop( ShopID )

end)

function debugshops( )

	local ShopWindow = vgui.Create( "lobby_shop" )
	ShopWindow:SetSize( ( ScrW()/4 ) * 3 , ( ScrH()/4 ) * 3 )
	ShopWindow:SetShop( 1 )
	
end