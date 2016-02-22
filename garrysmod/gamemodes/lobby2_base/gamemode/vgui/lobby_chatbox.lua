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

local mat_Grad = surface.GetTextureID("gui/gradient_up")

AccessorFunc( PANEL, "m_Color", "Color" )

function PANEL:Init( )

	self:SetColor( Color( 50, 175, 225, 100 ) )
	
	self.TextBox = vgui.Create( "DTextEntry", self )
	self.TextBox:SetPos( 2, 102 )
	self.TextBox:SetSize( 400, 20 )
	self.TextBox:SetFont( "LobbyChat" )
	
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
			
			timer.Simple(0, function()
				RunConsoleCommand("cancelselect")
			end)
			
		end
		
	end
	
	self.TextBox.OnEnter = function( self_textbox )
	
		if ( self_textbox:GetText():Trim() ~= "" ) then
			RunConsoleCommand("say", self_textbox:GetText():Trim() )
		end
		
		self:SafeClose( )
		
		timer.Simple(0, function()
			RunConsoleCommand("cancelselect")
		end)
		
	end

end

function PANEL:SafeClose( )

	gamemode.Call("FinishChat")
	
end

function PANEL:PerformLayout( )

	local w, h = self:GetSize()
	
	self.Chatbox:SetPos( 2, 2 )
	self.Chatbox:SetSize( w - 4, h - 2 - 20 - 2 )
	
	if ( IsValid( self.TextBox ) ) then
	
		self.TextBox:SetPos( 2, h - 20 - 2)
		self.TextBox:SetSize( w - 4, 20 )
	
	end

end

function PANEL:PaintBackground( w, h )

	local color = self:GetColor( )
	
	surface.SetDrawColor( color.r, color.g, color.b, 100 )
	surface.DrawRect( 0, 0, w, h )
	
	surface.SetTexture( mat_Grad )
	surface.SetDrawColor( 10, 10, 10, 100 )
	surface.DrawTexturedRect( 0, 0, w, h )

end

function PANEL:Paint( w, h )

	self:PaintBackground( w, h )

end

function PANEL:Think( )
	
end

vgui.Register( "lobby_chatbox", PANEL, "EditablePanel" )
