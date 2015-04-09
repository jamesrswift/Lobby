// shared.lua

local PlayerMeta = FindMetaTable("Player")

function PlayerMeta:GetMoney( )

	return tonumber( self:GetNWInt( "fMoney" ) )
	
end