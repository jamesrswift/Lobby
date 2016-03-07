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
local blur = Material("pp/blurscreen")

AccessorFunc( PANEL, "m_Color", "Color" )

function PANEL:Init( )

	self:SetColor( Color( 50, 50, 50, 100 ) )
	
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
	
	self.Chatbox:SetPos( 1, 1 )
	self.Chatbox:SetSize( w - 2, h - 2 - 20 - 2 )
	
	if ( IsValid( self.TextBox ) ) then
	
		self.TextBox:SetPos( 2, h - 20 - 2)
		self.TextBox:SetSize( w - 4, 20 )
	
	end

end

function PANEL:PaintBackground( w, h )

	local color = self:GetColor( )
	local x, y = self:GetPos( )
	
	DisableClipping( true )
	surface.SetDrawColor(255,255,255, 100)
	surface.SetMaterial(blur)

	for i = 1, 5 do
	
		blur:SetFloat("$blur", (i / 3) * (5))
		blur:Recompute()

		render.UpdateScreenEffectTexture()
		
		render.SetScissorRect(x, y, x+w, y+h, true)
			surface.DrawTexturedRect(-x, -y, ScrW(), ScrH())
		render.SetScissorRect(0, 0, 0, 0, false)
		
	end
	DisableClipping( false )
	
	surface.SetDrawColor( color.r, color.g, color.b, 100 )
	surface.DrawRect( 0, 0, w, h )
	
	surface.SetTexture( mat_Grad )
	surface.SetDrawColor( 10, 10, 10, 100 )
	surface.DrawTexturedRect( 0, 0, w, h )
	
	--draw.RoundedBox(0,0,0,w,h,Color(0,0,0,205))
	surface.SetDrawColor(0,0,0, 255)
	surface.DrawOutlinedRect(0,0,w,h)

end

function PANEL:Paint( w, h )

	self:PaintBackground( w, h )

end

function PANEL:Think( )
	
end

vgui.Register( "lobby_chatbox", PANEL, "EditablePanel" )
