// cl_init.lua

include( "cl_panels.lua" )
include( "cl_settings.lua" )

function GM:OnSpawnMenuOpen( )
	if MENU == nil or not MENU:IsValid( ) then
		MENU = vgui.Create( "lobby_menu" )
		MENU:SetSkin( "Lobby" )
	else
		MENU:SetVisible( true )
	end
	gui.EnableScreenClicker( true )
	RestoreCursorPosition( )
end

function GM:OnSpawnMenuClose( )
	if MENU and MENU:IsValid( ) and MENU:IsVisible( ) then
		MENU:SetVisible( false )
	end
	RememberCursorPosition( )
	gui.EnableScreenClicker( false )
end
