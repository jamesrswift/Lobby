--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, 2015
	
-----------------------------------------------------------]]--

local PANEL = {}

AccessorFunc( PANEL, "m_Custom", "Custom" )

function PANEL:Init()
	
	self.InfoHeight = 14
	self.BarColor = Color( 0, 0, 0, 100 )
	
	self:Droppable( 'LobbyInventoryItem' )
	
end

function PANEL:DoRightClick( )

	-- Setup menu
	if ( data.SetupMenu ) then
	
		local Menu = DermaMenu()
		Menu:SetDrawColumn( true )
		Menu:SetDrawBorder( true )
		
		data.SetupMenu( data.Instance, Menu )
		
		Menu:Open( )
		
	end
	
end

function PANEL:SetData( data )

	self.Data = data
	
	if data.Model then
		
		self:SetupModel( )

	else
	
		self:SetupImage( )
		
	end
	
	if data.Description then
		self:SetTooltip(data.Description)
	end
	
end

function PANEL:SetupModel( )

	local DModelPanel = vgui.Create('DModelPanel', self)
	DModelPanel:SetModel(data.Model)
	DModelPanel:Dock(FILL)
	DModelPanel:SetMouseInputEnabled( false )
	
	if data.Skin then
		DModelPanel:SetSkin(data.Skin)
	end
	
	local PrevMins, PrevMaxs = DModelPanel.Entity:GetRenderBounds()
	DModelPanel:SetCamPos(PrevMins:Distance(PrevMaxs) * Vector(0.5, 0.5, 0.5))
	DModelPanel:SetLookAt((PrevMaxs + PrevMins) / 2)
	
	function DModelPanel:LayoutEntity(ent)
		if self:GetParent().Hovered then
			ent:SetAngles(Angle(0, ent:GetAngles().y + 2, 0))
		end
	end

end

function PANEL:SetupImage( )

	local DImageButton = vgui.Create('DImageButton', self)
	DImageButton:SetMaterial(data.Material)
	DImageButton.m_Image.FrameTime = 0
	DImageButton:Dock(FILL)
	DImageButton:SetMouseInputEnabled( false )

	function DImageButton.m_Image:Paint(w, h)
		if not self:GetParent():GetParent().Data.NoScroll and self:GetParent():GetParent().Hovered then
			self.FrameTime = self.FrameTime + 1
		end

		self:PaintAt( 0, self.FrameTime % self:GetTall() - self:GetTall() , self:GetWide(), self:GetTall() )
		self:PaintAt( 0, self.FrameTime % self:GetTall(), 					self:GetWide(), self:GetTall() )
	end
	
end

function PANEL:PaintOver()

	surface.SetDrawColor( self.BarColor )
	surface.DrawRect(0, self:GetTall() - self.InfoHeight, self:GetWide(), self.InfoHeight)
	draw.SimpleText( self.Data.Name , "DefaultSmall", self:GetWide() / 2, self:GetTall() - (self.InfoHeight / 2), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	
end

function PANEL:OnCursorEntered()

	self.Hovered = true

end

function PANEL:OnCursorExited()

	self.Hovered = false

end

vgui.Register( "Lobby.InventoryItem", PANEL, "DPanel" )
