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

meta.Qualities 	= { Default = {} }
AccessorFunc( meta, "m_Quality", "Quality", FORCE_STRING )

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


function meta:RegisterQuality( UniqueName, traits )

	self.Qualities[ tostring(UniqueName) ] = traits

end

function meta:ManageTraits( TraitName, traits )


	-- Override for stuff

end

function meta:SetCustom( extra )

	if ( self.Qualities[ tostring(extra) ] ) then
	
		self:SetQuality( tostring(extra) )
		self:ManageTraits( self:GetQuality(), self.Qualities[ self:GetQuality() ] )
		
	else
	
		self:SetQuality( "Default" ) -- Default to no traits
		self:ManageTraits( self:GetQuality(), self.Qualities[ self:GetQuality() ] )
	
	end

end
