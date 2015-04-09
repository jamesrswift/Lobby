
hook.Add("OnPlayerChat", "CAHR", function(ply)
	Chat.PlayerChatIcon = hook.Call( "SetPlayerChatIcon" , GAMEMODE , ply )
end)

hook.Add( "PlayerInitialSpawn" , "mein_chat" , function( Pl )
	local args = {Color( 217 , 217 , 217 ) , Pl:Nick() .. " has joined the game!" }
	Chat.ChatBox:AddLine({icon = "icon16/world_add.png", textdata = args})
end)

hook.Add("ChatText","mein_chat", function(index, nick, text, messagetype)
	--:?[^(:.-:)]+:?
	timer.Simple(0, function()
		if Chat.ChatBox and nick ~= text then
			local args = {}
			local color = Color( 217 , 217 , 217 )
			table.insert(args, color)
			if messagetype == "joinleave" then
				args = {}
				local color = Color( 217 , 217 , 217 )
				table.insert(args, color)
				for s in string.gmatch(text, "%s?[(%S)]+[^.]?") do --HEIL PATTERN
					table.insert(args, s)
				end
				Chat.ChatBox:AddLine({icon = "gui/silkicons/world.vmt", textdata = args})
				return 
			end
			if messagetype == "none" then
				args = {}
				for s in string.gmatch(text, "%S+") do
					if s == "cvar" then
						table.insert(args, Color(130, 178, 255))
					end
				end
				for s in string.gmatch(text, "%s?[(%S)]+[^.]?") do
					table.insert(args, s)
				end
			Chat.ChatBox:AddLine({icon = "gui/silkicons/world.vmt", textdata = args})
			end
		end
	end)
end)

hook.Add("StartChat", "Chat.HideChat", function() return true end)

local OpenChat = function(pl, bind, pressed)
	if(pressed and string.find(bind, "messagemode")) then
		Chat.ChatBox:SetVisible(true)
		Chat.ChatBox.TextEntry:SetVisible(true)
		Chat.FakePanel:SetVisible(true)
		Chat.FakePanel:MakePopup()
		Chat.ChatBox.TextEntry:RequestFocus()
		return true 
	end
end
hook.Add("PlayerBindPress", "Chat.PlayerBindPress", OpenChat)


hook.Add("HUDShouldDraw", "Chat.HUDShouldDraw", function(elem)
	if elem == "CHudChat" then
		return false
	end
end)

function Chat.MakeVisibleFromSpawn(ply)
	if ply != LocalPlayer() then return end
	Chat.ChatBox:SetVisible(true)
	Chat.FakePanel:SetVisible(true)
	
	Chat.ChatBox.TextEntry:SetVisible(true)
	Chat.FakePanel:SetVisible(false)
	Chat.ChatBox.TextEntry:KillFocus()
end

hook.Add( "PlayerInitialSpawn", "MakeVisibleFromSpawn", Chat.MakeVisibleFromSpawn )


	