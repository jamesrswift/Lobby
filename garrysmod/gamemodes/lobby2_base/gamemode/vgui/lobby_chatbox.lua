--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, 2015
	
-----------------------------------------------------------]]--

local PANEL = { }

AccessorFunc( PANEL, "m_Color", "Color" )
AccessorFunc( PANEL, "m_Displayed", "Displayed", FORCE_BOOL  )

function PANEL:Init( )

	self:SetColor( Color( 100, 100, 100 ) )
	self:SetDisplayed( false )

	self.Chatbox = vgui.Create( "Chat_RichText", self )
	self.Chatbox:SetPos( 2, 2 )
	self.Chatbox:SetSize( 400, 100 )
	
	self.TextBox = vgui.Create( "DTextEntry", self )
	self.TextBox:SetPos( 2, 102 )
	self.TextBox:SetSize( 400, 20 )
	self.TextBox:SetVisible( false )
	
	self.TextBox.OnKeyCodeTyped = function(self_textbox, key)
	
		if ( key == KEY_ESCAPE ) then
		
			self:SafeClose( )
			
			timer.Simple(0, function()
				RunConsoleCommand("cancelselect")
			end)
			
		end
		
		if ( key == KEY_ENTER ) then
		
			if ( self_textbox:GetText():Trim() ~= "" ) then
				RunConsoleCommand("say", self_textbox:GetText():Trim() )
			end
			
			self:SafeClose( )
			
		end
		
	end
	
	self.TextBox.OnEnter = function( self_textbox )
	
		if ( self_textbox:GetText():Trim() ~= "" ) then
			RunConsoleCommand("say", self_textbox:GetText():Trim() )
		end
		
		self:SafeClose( )
		
	end

end

function PANEL:SafeClose( )

	self:SetDisplayed(false)
	self.Chatbox:Close()
	self.TextBox:KillFocus()
	self:SetText("")
	
end

function PANEL:PerformLayout( )

	local w, h = self:GetSize()
	
	self.Chatbox:SetPos( 2, 2 )
	self.Chatbox:SetSize( w - 4, h - 2 - 20 - 2 )
	
	self.TextBox:SetPos( 2, h - 20 - 2)
	self.TextBox:SetSize( w - 4, 20 )

end

function PANEL:PaintBackground( w, h )

	local color = self:GetColor( )
	
	surface.SetDrawColor( color.r, color.g, color.b, 100 )
	surface.DrawRect( 0, 0, w, h )

end

function PANEL:Paint( w, h )

	if ( not self:GetDisplayed( ) ) then return end

	self:PaintBackground( w, h )

end

function PANEL:Think( )

	if ( IsValid( self.TextBox ) ) then
		if ( self:GetDisplayed( ) ) then
			self.TextBox:SetVisible( true )
		else
			self.TextBox:SetVisible( false )
		end
	end
	
end

vgui.Register( "lobby_chatbox", PANEL, "EditablePanel" )
