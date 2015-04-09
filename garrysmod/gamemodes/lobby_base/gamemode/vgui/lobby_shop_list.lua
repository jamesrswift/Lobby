
local PANEL = { }


function PANEL:Init( )

	self:SetSpacing( 1 )
	
	self:EnableHorizontal( false ) -- Only vertical items
	self:EnableVerticalScrollbar( true )

end

function PANEL:AddShopItem( Item )

	Item:SetSize( self:GetParent():GetWidth( ) , 100 )
	self:AddItem( Item )

end

vgui.Register( "lobby_shop_list", PANEL, "DPanelList" )