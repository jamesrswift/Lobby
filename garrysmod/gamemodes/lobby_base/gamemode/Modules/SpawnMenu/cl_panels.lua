local W, H = ScrW(), ScrH()

local PANEL = { }

function PANEL:Init( )

	MENU = self
	self:SetSize(360+256,750)
	self:SetPos(0,60)
	self:SetTitle( "Menu" )
	self.ContentPanel = vgui.Create( "DPropertySheet", self )
	self:ShowCloseButton( false )
	self.ContentPanel:AddSheet( "Settings", vgui.Create("lobby_settings", self), "gui/silkicons/wrench", true, true )
	
	--[[
	if LocalPlayer( ):IsAdmin( ) then
		self.ContentPanel:AddSheet( "Admin", vgui.Create( "lobby_admin", self ), "gui/silkicons/shield", true, true )
		self.ContentPanel:AddSheet( "Build", vgui.Create( "lobby_build", self ), "gui/silkicons/brick_add", true, true )
		self.ContentPanel:AddSheet( "Weapons", vgui.Create( "lobby_weapon", self ), "gui/silkicons/bomb", true, true )
	end
	
	--]]
	
end

function PANEL:Close( )
end

function PANEL:PerformLayout( )

	self.ContentPanel:StretchToParent( 4, 26, 4, 4 )
	
	DFrame.PerformLayout( self )

end

vgui.Register( "lobby_menu", PANEL, "DFrame" )