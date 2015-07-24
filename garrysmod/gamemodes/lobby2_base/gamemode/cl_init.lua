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

include( "vgui/richtext_scrollbar.lua" )
include( "vgui/richtext.lua" )
include( "vgui/lobby_notification.lua" )

include( "shared.lua" )

function GM:Initialize( )
	
	self:CreateFonts( )
	self.Chat.Initialize( )

end

function GM:Think( )

	self.Notification.Think( )

end

function GM:TestRichText( )

	local notification = vgui.Create( "Chat_RichText" )
	notification:SetPos( 50, 50 )
	notification:SetSize( 400, 400 )
	notification:AppendLine( {Type="Text", Data="Hello World!"} )

end