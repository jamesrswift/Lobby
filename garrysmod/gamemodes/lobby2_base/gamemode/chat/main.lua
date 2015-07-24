--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, 2015
	
-----------------------------------------------------------]]--

GM.Chat = GM.Chat or {}

function GM.Chat.Initialize( )

	local GM = GM or gmod.GetGamemode( )

	if ( not GM.Chat.Chatbox ) then
	
		GM.Chat.Chatbox = vgui.Create( "Chat_RichText" )
		GM.Chat.Chatbox:SetPos( 50, 50 )
		GM.Chat.Chatbox:SetSize( 400, 400 )
	
	end
		

end

function GM:OnPlayerChat( Pl, sText, bTeam, bDead )

	if ( IsValid( self.Chat.Chatbox ) ) then
		
		local buffer = { }

		local icon = hook.Run( "GetPlayerChatIcon", Pl )
		if ( icon ) then
			table.insert( buffer, {Type="Image", Data=icon} )
		end
		
		table.insert( buffer, {Type="Color", Data=Pl:GetDisplayTextColor( )} )
		table.insert( buffer, {Type="Text", Data=Pl:Nick( )} )
		
		table.insert( buffer, {Type="Color", Data=color_white} )
		table.insert( buffer, {Type="Text", Data=": "} )
		
		for k,v in pairs( self.Chat:ParseString( Pl, sText ) ) do
			table.insert( buffer, v )
		end
		
		self.Chat.Chatbox:AppendLine( unpack( buffer ) )
		
	end

end