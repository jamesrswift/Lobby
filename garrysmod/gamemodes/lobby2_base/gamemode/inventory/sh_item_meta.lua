--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, 2015
	
-----------------------------------------------------------]]--

local meta = GM.Item._itemmeta

function meta:Init( )

end

function meta:OnBuy( Pl )

end

function meta:OnSell( Pl )

end

function meta:OnRemove( Pl )

end

function meta:CanPlayerBuy( Pl )
	
	return not self.Base 
	
end

function meta:CanPlayerSell( Pl )

	return true

end

function meta:CanPlayerTrade( Pl )

	return true

end

function meta:CanPlayerEquip( Pl )

	return true

end

function meta:CanPlayerHolister( Pl )

	return true

end
