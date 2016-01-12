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

include( "vgui/richtext_scrollbar.lua" )
include( "vgui/richtext.lua" )
include( "vgui/lobby_frame.lua" )
include( "vgui/lobby_notification.lua" )

include( "shared.lua" )

function GM:Initialize( )
	
	self:CreateFonts( )
	self.Chat.Initialize( )

end

function GM:Think( )

	self.Notification.Think( )

end