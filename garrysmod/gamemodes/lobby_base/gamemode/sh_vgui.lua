LoadedVgui= {}
VguiFolder = "Lobby_Base/gamemode/vgui"

function LoadVgui()
	for k,v in pairs(file.Find(VguiFolder.."/*", "LUA" )) do
		if SERVER then
			AddCSLuaFile(VguiFolder.."/"..v)
		else
			include(VguiFolder.."/"..v)
		end
		LoadedVgui[v] = true
	end
end

LoadVgui()

if ( CLIENT ) then 

	function GM:ForceDermaSkin()
		return "LobbyV2"
	end

	// in the chance that the above is being bypassed
	--[[local Lobbyskin = derma.GetNamedSkin("LobbyV2")

	function derma.GetDefaultSkin()
		return Lobbyskin
	end

	function derma.GetNamedSkin()
		return Lobbyskin
	end]]--
	
end