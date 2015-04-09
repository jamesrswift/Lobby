local PANEL = { }

PANEL.ShopName = "Shop"

function PANEL:GetWidth( )

	return ( ScrW()/4 ) * 3

end

function PANEL:GetTall( )

	return ( ScrH()/4 ) * 3

end

function PANEL:Init( )

	self:SetSize( 350 , ScrH() * 0.75 )
	self:SetPos( ( ScrW() / 2 ) - self:GetWidth() / 2,  ( ScrH() / 2 ) - self:GetTall() / 2)
	self:SetTitle( self.ShopName )
	self:ShowCloseButton( true )
	
	self.List = vgui.Create( "lobby_shop_list" , self )
	self.List:SetPos( 2 , 26 )
	self.List:SetSize( self:GetWidth() - 4 , self:GetTall() - 30 )
	
	gui.EnableScreenClicker( true )
	RestoreCursorPosition( )

end

local oldc = PANEL.Close

function PANEL:Close( )

	gui.EnableScreenClicker( false )
	RememberCursorPosition( )
	
	
	self:SetVisible( false )
	//oldc( self )
	
end

function PANEL:SetShop( ID )

	local name = Shops[ ID ].Name
	PANEL.ShopName = name
	self:SetTitle( self.ShopName )
	
	for k,v in pairs( LobbyItem.Items ) do
	
		if v.ShopID and v.ShopID == ID then
		
			local Item = vgui.Create( "lobby_shop_item" )
			Item:SetModel( v.Model )
			Item:SetText( v.Description )
		
			self.List:AddShopItem( Item )
		
		end
		
	end

end

vgui.Register( "lobby_shop", PANEL, "DFrame" )