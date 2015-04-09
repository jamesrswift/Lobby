local PANEL = { } -- Based off a simple DPanel

function PANEL:Init( )
	
	self.ModelPanel = vgui.Create( "DModelPanel", self )
	self.ModelPanel:SetSize( 100, 100 )
	self.ModelPanel:SetPos( 2 , 2 ) -- 2 px margins
	self.ModelPanel:SetCamPos( Vector( 7, 7, 10 ) )
	self.ModelPanel:SetLookAt( Vector( 0, 0, 0 ) )
	
	self.Text = vgui.Create( "DLabel" , self )
	self.Text:SetPos( 105 , 2 )

end

function PANEL:SetModel( model )

	self.ModelPanel:SetModel( model )

end

function PANEL:SetText( Text )

	self.Text:SetText( Text )
	self.Text:SizeToContents( )

end

function PANEL:OnBuy( )


end

vgui.Register( "lobby_shop_item", PANEL, "DPanel" )

