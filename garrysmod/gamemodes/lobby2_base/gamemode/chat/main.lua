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
	
		GM.Chat.Chatbox = vgui.Create( "Chat_RichText", self )
		GM.Chat.Chatbox:SetPos( 50 + 2 , ScrH() - 225 + 2)
		GM.Chat.Chatbox:SetSize( 400, 100 )
	
	end

end

function GM:ChatText( index, name, text, type )

	if ( type == "joinleave" ) then
	
		self.Chat.Chatbox:AppendLine( {Type = "Text", Data = text } )
		
	elseif ( type == "none" ) then
	
		self.Chat.Chatbox:AppendLine( {Type = "Text", Data = text } )
	
	end
	
	return true

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

	if ( not IsValid( self.Chat.ChatboxVGUI ) and IsValid( self.Chat.Chatbox ) ) then
		
		hook.Run( "OpenChat", bTeam )
		
		return true
		
	end

end

function GM:FinishChat( )

	if ( IsValid( self.Chat.ChatboxVGUI ) and IsValid( self.Chat.Chatbox ) ) then

		self.Chat.Chatbox:SetParent( nil )
		self.Chat.Chatbox:Close( )
		self.Chat.Chatbox:SetPos( 50 + 2 , ScrH() - 225 + 2)
		
		self.Chat.ChatboxVGUI.TextBox:KillFocus( )
		self.Chat.ChatboxVGUI:KillFocus( )
		self.Chat.ChatboxVGUI:Remove( )
		
		return true
		
	end

end

function GM:OpenChat( bTeam )

	self.Chat.ChatboxVGUI = vgui.Create( "lobby_chatbox" )
	self.Chat.ChatboxVGUI:SetPos( 50, ScrH() - 225 )
	self.Chat.ChatboxVGUI:SetSize( 400, 150 )
	
	self.Chat.ChatboxVGUI.Chatbox = self.Chat.Chatbox
	self.Chat.Chatbox:SetParent( self.Chat.ChatboxVGUI )
	self.Chat.Chatbox:SetPos( 2, 2 )
	
	self.Chat.ChatboxVGUI:InvalidateLayout( )
	
	self.Chat.ChatboxVGUI:MakePopup( )
	self.Chat.ChatboxVGUI.TextBox:RequestFocus( )
	
	self.Chat.Chatbox:Open( )

end

hook.Add("PlayerBindPress", "OpenChatCheck", function( ply, bind, pressed )

	if ( pressed and string.find( bind, "messagemode" ) ) then
	
		local teamchat = string.find( bind, "messagemode2" ) ~= nil
		hook.Run( "OpenChat", bTeam )
		
		return true
	end
	
end)

function chat.AddText( ... )

	local GM = GM or gmod.GetGamemode( )

	if ( not IsValid( GM.Chat.Chatbox ) ) then
	
		GM.Chat.Initialize( )
		
	end
	
	local LastColor = Color( 255, 255, 255 )
	local buffer = { }

	for k,v in ipairs( {...} ) do
		if ( type(v) == "table" and v.r ) then -- Color
			table.insert( buffer, {Type = "Color", Data = v} )
			LastColor = v
		elseif ( type( v ) == "string" ) then
			table.insert( buffer, {Type = "Text", Data = v} )
		elseif ( type( v ) == "Player" ) then
			table.insert( buffer, {Type = "Color", Data = v:GetDisplayTextColor( )} )
			table.insert( buffer, {Type = "Text", Data = v:Nick()} )
			table.insert( buffer, {Type = "Color", Data = LastColor} )
		end
	end
	
	GM.Chat.Chatbox:AppendLine( unpack( buffer ) )
	MsgC( ..., "\n" )

end

function GM.Chat.PlayerChatPrintNMsg( len )

	local str = net.ReadString( )
	if ( str ) then
		chat.AddText( color_white, str )
	end

end

net.Receive( "lobby.chat.PlayerChatPrint", GM.Chat.PlayerChatPrintNMsg )
