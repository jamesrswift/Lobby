local PANEL = { } -- Based off a simple DPanel

function PANEL:Init( )
	
	self.ModelPanel = vgui.Create( "DModelPanel", self )
	self.ModelPanel:SetSize( 100, 100)
	
	function self.ModelPanel:LayoutEntity( Entity ) return end	-- Disable cam rotation
	
	--self.ModelPanel:Dock( LEFT )
	--self.ModelPanel:DockMargin(2,2,2,2 )
	
	self.Text = vgui.Create( "DLabel" , self )
	self.Text:Dock(LEFT)
	self.Text:DockMargin( 5,5,5,5 )
	self.Text:SetFont( "Lobbymidbold" )

end

function PANEL:SetModel( model )

	self.ModelPanel:SetModel( model )
	--local en = self.ModelPanel:GetEntity()
	--local PrevMins, PrevMaxs = en:GetRenderBounds()
	--self.ModelPanel:SetCamPos(PrevMins:Distance(PrevMaxs) * Vector(0.5, 0.5, 0.5))
	--self.ModelPanel:SetLookAt((PrevMaxs + PrevMins) / 2)

end

function PANEL:SetText( Text )

	self.Text:SetText( Text )
	self.Text:SizeToContents( )

end

function PANEL:OnBuy( )


end

vgui.Register( "lobby_shop_item", PANEL, "DPanel" )

