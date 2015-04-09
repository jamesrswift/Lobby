----------------------------------------------
-----------Chat by JohnnyThunders------------ 
----------------------------------------------

Chat = {} --Let's prevent any breaking.
--Various data 

Chat.ScrollSpeed = 3.52
Chat.ChatFont = "ChatFont"
Chat.UseIcons = true

if SERVER then

	AddCSLuaFile( "cl_vgui.lua" )
	AddCSLuaFile( "cl_hooks.lua" )
	
	util.AddNetworkString("Player.PrintMessage");
	
	local PlayerMeta = FindMetaTable("Player")
	local old_pm = PlayerMeta.PrintMessage
	function PlayerMeta:PrintMessage( type, message )
		if type == HUD_PRINTTALK then
			net.Start( "Player.PrintMessage")
			net.WriteString( message )
			net.Send(self)
			return
		end
		old_pm(self, type, message )
	end
	return
	
end

net.Receive( "Player.PrintMessage", function(len, ply)
	chat.AddText( Color(130, 178, 255), net.ReadString() )
end)


include( "cl_vgui.lua" )
include( "cl_hooks.lua" )

do
	surface.SetFont(Chat.ChatFont)
	local w, h = surface.GetTextSize("0")
	Chat.LineSpacing = h + 2
end

Chat.SentChatPrintLine = Chat
Chat.MaxLines = 6
Chat.FadeTime = 0.25

Chat.ChatColors = {
	[":red:"] = Color(255, 0, 0),
	[":green:"] = Color(0, 255, 0),
	[":blue:"] = Color(0, 0, 255),
	[":yellow:"] = Color(255, 255, 0),
	[":black:"]= Color(0, 0, 0),
	[":white:"] = Color(255, 255, 255),
	[":grey:"] = Color(115, 115, 115),
	[":gray:"] = Color(115, 115, 115), -- for the american spelling
	[":lightblue:"] = Color(152, 245, 255),
	[":aqua:"] = Color(127, 255, 212),
	[":orange:"] = Color(205, 127, 50),
	[":purple:"] = Color(127, 0, 255),
	[":lightgreen:"] = Color(202, 255, 112),
	[":pink:"] = Color(255, 20, 147),
	[":darkred:"] = Color(139, 26, 26)
}
Chat.SentChatPrintLine = Chat

local function IsColor(color)
	return (type(color) == "table" and color.r and color.g and color.b)
end

function Chat.GetLastColor(linedata)
	local color = color_white
	for k, v in pairs(linedata.textdata) do
		if IsColor(v) then
			color = v
		end
	end
	return color
end

function Chat.WrapString(linedata, maxwidth)
	surface.SetFont(Chat.ChatFont)
	local linewidth = 0
	local packedlines = {}
	local linenumber = 1
	table.insert(packedlines, {icon = linedata.icon, textdata = {}})
	for k, v in pairs(linedata.textdata) do
		if type(v) == "string" then
			local w, h = surface.GetTextSize(v)
			linewidth = linewidth + w
			if linewidth + ((linedata.icon and #packedlines == 1) and 22 or 0) >= maxwidth then
				local w, h = surface.GetTextSize(v)
				linewidth = w
				linenumber = linenumber + 1
				table.insert(packedlines, {textdata = {Chat.GetLastColor(packedlines[linenumber-1])}})
			end	
		end
		if IsColor(v) then
			table.insert(packedlines[linenumber].textdata, v)
		end
		if type(v) == "string" then
			table.insert(packedlines[linenumber].textdata, v)
		end
	end
	return packedlines		
end



function Chat.Initialize( )


	Chat.ChatBox = vgui.Create("Chat.ChatBoxPanel")
	Chat.ChatBox:SetSize(520, Chat.MaxLines * Chat.LineSpacing)
	Chat.ChatBox:SetPos(20, ScrH() * 0.90 - Chat.ChatBox:GetTall())
	Chat.ChatBox:SetVisible(false)

	Chat.FakePanel = vgui.Create("EditablePanel")
	Chat.FakePanel:SetPos(10, ScrH() * 0.90 - Chat.ChatBox:GetTall())
	Chat.FakePanel:SetSize(800, ScrH())
	Chat.FakePanel:SetVisible(false)
	Chat.FakePanel.Paint = function() end
	Chat.FakePanel.OnMouseWheeled = function(self, dir)
		if Chat.ChatBox then
			local maxlines = math.ceil(Chat.ChatBox:GetTall() / Chat.LineSpacing)
			if #Chat.ChatBox.ChatLines >= maxlines then
				Chat.ChatBox.ScrollY = math.Clamp(Chat.ChatBox.ScrollY + (dir * -1) * Chat.LineSpacing, 0, (#Chat.ChatBox.ChatLines - maxlines) * Chat.LineSpacing)
			end
		end
	end

	local chatx, chaty = Chat.ChatBox:GetPos()
	Chat.ChatBox.TextEntry = vgui.Create("DTextEntry", Chat.FakePanel)
	Chat.ChatBox.TextEntry:SetParent(Chat.FakePanel)
	Chat.ChatBox.TextEntry:SetPos(10, Chat.MaxLines * Chat.LineSpacing + 10)
	Chat.ChatBox.TextEntry:SetSize(Chat.ChatBox:GetWide(), 20)
	Chat.ChatBox.TextEntry:SetAllowNonAsciiCharacters(true)
	Chat.ChatBox.TextEntry:SetTextInset(0, 0)
	Chat.ChatBox.TextEntry:SetVisible(Chat)
	Chat.ChatBox.TextEntry.IsTeamChat = Chat
	Chat.ChatBox.TextEntry.OnMouseWheeled = function(self, dir)
		local maxlines = math.ceil(Chat.ChatBox:GetTall() / Chat.LineSpacing)
		if #Chat.ChatBox.ChatLines >= maxlines then
			Chat.ChatBox.ScrollY = math.Clamp(Chat.ChatBox.ScrollY + (dir * -1) * Chat.LineSpacing, 0, (#Chat.ChatBox.ChatLines - maxlines) * Chat.LineSpacing)
		end
	end
	
	Chat.ChatBox.TextEntry.OnKeyCodeTyped = function(self, key)
		if key == KEY_ESCAPE then
			Chat.ChatBox.TextEntry:SetVisible(false)
			Chat.FakePanel:SetVisible(false)
			Chat.ChatBox.TextEntry:KillFocus()
			self:SetText("")
			timer.Simple(0, function()
				RunConsoleCommand("cancelselect")
			end)
		end
		if key == KEY_ENTER then
			if self:GetText():Trim() ~= "" then
				RunConsoleCommand("say", self:GetText():Trim())
				Chat.ChatBox.TextEntry.IsTeamChat = Chat
			end
			self:SetText("")
			timer.Simple(0.001, function()
			Chat.ChatBox.TextEntry:SetVisible(false)
			Chat.FakePanel:SetVisible(false)
			Chat.ChatBox.TextEntry:KillFocus()
			end)
		end
	end
	
	Chat.ChatBox.TextEntry.Paint = function(self)
			surface.SetDrawColor(color_black)
			surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
			surface.SetDrawColor(color_white)
			surface.DrawRect(1, 1, self:GetWide() - 2, self:GetTall() - 2)
			self:DrawTextEntryText(Color(0, 0, 0), Color(255, 255, 255), Color(0, 0, 0))
	end
	
	Chat.ChatBox.TextEntry.OnEnter = function(self)
		if self:GetText():Trim() ~= "" then
			RunConsoleCommand("say", self:GetText():Trim())
			Chat.ChatBox.TextEntry.IsTeamChat = Chat
		end
		self:SetText("")
		Chat.ChatBox.TextEntry:SetVisible(false)
		Chat.FakePanel:SetVisible(false)
		Chat.ChatBox.TextEntry:KillFocus()
	end
	
	Chat.ChatBox.TextEntry.OnTextChanged = function(self)
		hook.Call("ChatTextChanged", GAMEMODE, self:GetText():Trim())
	end

end

hook.Add( "Initialize" , "Chat" , Chat.Initialize )

Chat.isplayerchat = Chat

function chat.AddText(...)
	local pargs = {...}
	local colorsparsed = Chat
	timer.Simple(0, function()
		local ind = 1
		local args = {}
		table.insert(args, Color(200,200,200))
		for k, v in pairs(pargs) do
			if IsColor(v) then
				local fixedcolor = Color(v.r, v.g, v.b, 255)
				table.insert(args, fixedcolor)
			end
			if type(v) == "Player" then
				Chat.isplayerchat = true
				table.insert(args, v:GetDisplayTextColor( false ))
				table.insert(args, v:Nick())
			end
			if type(v) == "string" then
			--else
				v = tostring( v)
				for s in string.gmatch(v, "%s?[(%S)]+[^.]?") do --HEIL MEIN PATTERN
				local start = 0 --credit to Divran
					for startpos, center, endpos in string.gmatch(s, "()(%b::)()" ) do
						--print(startpos, center, endpos)
						if Chat.ChatColors[center] then
							colorsparsed = true
							table.insert(args, string.sub(s, start, startpos - 1))
							table.insert(args, Chat.ChatColors[center])
							start = endpos
						end
					end
					if colorsparsed then
						table.insert(args, string.sub(s, start))
						s = ""
					end
					surface.SetFont(Chat.ChatFont)
					local w, _ = surface.GetTextSize(s)
					local singlew, _ = surface.GetTextSize("O")
					if w >= Chat.ChatBox:GetWide() then
						local lastchar = 0
						local maxchars = Chat.ChatBox:GetWide() / singlew
						for i = 0, math.ceil(w / Chat.ChatBox:GetWide()) do
							local cutstr = string.sub(s, lastchar + 1, lastchar + maxchars)
							table.insert(args, cutstr)
							lastchar = lastchar + string.len(cutstr)
						end
					else
						table.insert(args, s)
					end
				end
			end
		end
		Chat.ChatBox:AddLine({icon = Chat.PlayerChatIcon, textdata = args, printedon = CurTime()})
		Chat.PlayerChatIcon = nil
		
		--Chat.ChatBox:SetVisible(true)
		--Chat.FakePanel:SetVisible(true)
		--Chat.FakePanel:MakePopup()
	end)
end

Chat.AddText = chat.AddText;
