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
		GM.Chat.Chatbox:SetPos( 50, ScrH() - 175 )
		GM.Chat.Chatbox:SetSize( 400, 100 )
		
		-- Create chatbox textbox
		
		GM.Chat.TextBox = vgui.Create( "DTextEntry" )
		GM.Chat.TextBox:SetPos( 50, ScrH() - 75 )
		GM.Chat.TextBox:SetSize( 400, 20 )
		GM.Chat.TextBox:SetVisible( false )
	
	end

end

function GM:ChatText( index, name, text, type )

	if ( type == "joinleave" ) then
	
		self.Chat.Chatbox:AppendLine( {Type = "Text", Data = text } )
		
	elseif ( type == "none" ) then
	
		self.Chat.Chatbox:AppendLine( {Type = "Text", Data = text } )
	
	end

end

function GM:OnPlayerChat( Pl, sText, bTeam, bDead )

	if ( not IsValid( self.Chat.Chatbox ) ) then
	
		self.Chat.Initialize( )
		
	end

	if ( IsValid( self.Chat.Chatbox ) ) then
		
		local buffer = { }

		local icon = hook.Run( "GetPlayerChatIcon", Pl )
		if ( icon ) then
			table.insert( buffer, {Type="Image", Data=icon} )
			table.insert( buffer, {Type="Text", Data="  "} )
		end
		
		table.insert( buffer, {Type="Color", Data=Pl:GetDisplayTextColor( )} )
		table.insert( buffer, {Type="Text", Data=Pl:Nick( )} )
		
		table.insert( buffer, {Type="Color", Data=color_white} )
		table.insert( buffer, {Type="Text", Data=": "} )
		
		for k,v in pairs( self.Chat:ParseString( Pl, sText ) ) do
			table.insert( buffer, v )
		end
		
		self.Chat.Chatbox:AppendLine( unpack( buffer ) )
		
		MsgC( Pl:GetDisplayTextColor( ), Pl:Nick( ), color_white, ": ", sText, "\n" )
		
		return true
		
	end

end

function GM:StartChat( bTeam )

	if ( not IsValid( self.Chat.Chatbox ) ) then
	
		self.Chat.Initialize( )
		
	end

	if ( IsValid( self.Chat.Chatbox ) ) then
		
		self.Chat.Chatbox:Open()
		self.Chat.TextBox:SetVisible( true )
		
	end
	
	-- Hide default chatbox
	return true

end

function GM:FinishChat( )

	if ( IsValid( self.Chat.Chatbox ) ) then
		
		self.Chat.Chatbox:Close()
		self.Chat.TextBox:SetVisible( false )
		
	end

end

function chat.AddText( ... )

	local GM = GM or gmod.GetGamemode( )

	if ( not IsValid( GM.Chat.Chatbox ) ) then
	
		GM.Chat.Initialize( )
		
	end

	local buffer = { }

	for k,v in ipairs( {...} ) do
		if ( type(v) == "table" and v.r ) then -- Color
			table.insert( buffer, {Type="Color", Data=v} )
		elseif ( type( v ) == "string" ) then
			table.insert( buffer, {Type="Text", Data=v} )
		end
	end
	
	gmod.GetGamemode().Chat.Chatbox:AppendLine( unpack( buffer ) )
	MsgC( ... )

end

function GM.Chat.PlayerChatPrintNMsg( len )

	local str = net.ReadString( )
	if ( str ) then
		chat.AddText( color_white, str )
	end

end

net.Receive( "lobby.chat.PlayerChatPrint", GM.Chat.PlayerChatPrintNMsg )
