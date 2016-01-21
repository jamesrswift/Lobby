--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, 2015
	
-----------------------------------------------------------]]--

include( "extensions/utf8.lua" )

include( "sh_util.lua" )
include( "cl_notification.lua" )
include( "cl_fonts.lua" )
include( "sh_modules.lua" )
include( "sh_usergroups.lua" )

include( "chat/main.lua" )
include( "chat/cl_smilies.lua" )
include( "chat/cl_icons.lua" )

include( "inventory/cl_init.lua" )

include( "vgui/richtext_scrollbar.lua" )
include( "vgui/richtext.lua" )
include( "vgui/lobby_chatbox.lua" )
include( "vgui/lobby_frame.lua" )
include( "vgui/lobby_notification.lua" )

include( "shared.lua" )

GM.HideElements = { "CHudChat" }

function GM:Initialize( )
	
	self:CreateFonts( )
	self.Chat.Initialize( )

end

function GM:Think( )

	self.Notification.Think( )
	self.Inventory:Think( )

end

function GM:CreateMove( cmd )

	self.Inventory.Ghost:Move( cmd )
	
	if ( drive.CreateMove( cmd ) ) then return true end
	if ( player_manager.RunClass( LocalPlayer(), "CreateMove", cmd ) ) then return true end

end

function GM:HUDShouldDraw( name )

	return not table.HasValue( self.HideElements, name )
	
end
