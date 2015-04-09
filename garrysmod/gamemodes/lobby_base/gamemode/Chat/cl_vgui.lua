Chat.ChatboxPanel = {} --Initialize our panel data


local LoadedIcons = {

	["icon16/star.png"] = Material( "icon16/star.png" ),
	["icon16/shield.png"] = Material( "icon16/shield.png" ),
	["icon16/user.png"] = Material( "icon16/user.png" ),
	["icon16/page.png"] = Material( "icon16/page.png" ),
	["icon16/heart.png"] = Material( "icon16/heart.png" ),
	["icon16/world_add.png"] = Material( "icon16/world_add.png" )

}

function Chat.ChatboxPanel:Init()
	self.ChatLines = {}
	self.ScrollY = 0
end

local a = 255

function Chat.ChatboxPanel:DrawLine(num, data)
	surface.SetFont(Chat.ChatFont)
	local linewidth = 0
	local num = num - 1
	local w, h = 0, 0
	h = h + Chat.LineSpacing * num
	data.alpha = math.Approach(data.alpha, 0, (self.TextEntry:IsVisible() and 0 or Chat.FadeTime))
	if self.TextEntry:IsVisible() then data.alpha = 255 end
	for _, elem in pairs(data.textdata) do
		if type(elem) == "table" and elem.r and elem.g and elem.b then
			surface.SetTextColor(Color(elem.r, elem.g, elem.b, (self.TextEntry:IsVisible() and 255 or data.alpha)))
		end
		if type(elem) == "string" then
			w, _ = surface.GetTextSize(elem)
			surface.SetTextPos((25) + linewidth, h + self.ScrollY * -1)
			surface.DrawText(elem)
			linewidth = linewidth + w
		end
	end --But our team of scientific trained ninja monkeys is working on this aspect
	if data.icon then
		surface.SetDrawColor(Color(255, 255, 255, (self.TextEntry:IsVisible() and 255 or data.alpha)))
		/*render.SetMaterial( Material( data.icon, "nocull" ) )
		surface.DrawTexturedRect(2, h + self.ScrollY * -1, Chat.LineSpacing - 2, Chat.LineSpacing - 2)*/

		if LoadedIcons[ data.icon ] then
			surface.SetMaterial(LoadedIcons[ data.icon ] )
			surface.DrawTexturedRect( 2, h + self.ScrollY * -1, Chat.LineSpacing - 2, Chat.LineSpacing - 2 )
		end
		
	end
	surface.SetTextColor(color_white) --Reset the color                                                                 
end                                                                                                                     

function Chat.ChatboxPanel:AddLine(linedata)
	local D = hook.Call( "AllowChatIcons" , GAMEMODE , linedata );
	if !D then
		linedata.icon = nil
	elseif ( type( D ) == "table" and D.icon ) then
		linedata.icon = D.icon
	end
	--linedata struct = {icon(optional), textdata(same format as chat.AddText), printedon = RealTime()}			        
	local wrapped = Chat.WrapString(linedata, self:GetWide())
	for k,v in pairs(wrapped) do                                                                                        
		v.alpha = 255
		table.insert(self.ChatLines, v)                                                                                 
	end
	if #self.ChatLines >= math.ceil(self:GetTall() / Chat.LineSpacing) then
		self.ScrollY = (#self.ChatLines - math.ceil(self:GetTall() / Chat.LineSpacing)) * Chat.LineSpacing
	end
	for k, v in pairs(self.ChatLines) do
		if k ~= #self.ChatLines then
			v.shouldfade = true
		end
		v.alpha = 255
	end
	
end

local Alpha = 0

function Chat.ChatboxPanel:Paint()
	if self.TextEntry then
		if self.TextEntry:IsVisible() then 
			if Alpha < 150 then Alpha = Alpha + 6 end
		else
			if Alpha > 0 then Alpha = Alpha - 6 end
		end
		
		surface.SetDrawColor(hook.Call( "ChatBoxColorPaint" , GAMEMODE , Alpha )) --blueish transparent grey
		surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
		
		for k, v in ipairs(self.ChatLines) do
			self:DrawLine(k, v)
		end
	end
end

vgui.Register("Chat.ChatBoxPanel", Chat.ChatboxPanel, "EditablePanel")