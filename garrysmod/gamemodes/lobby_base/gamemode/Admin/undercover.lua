// Undercover

local PlayerMeta = FindMetaTable("Player")

function PlayerMeta:SetUndercover( bool )

	if !self:IsPrivAdmin() then return end

	self:SetNWBool( "bIsUndercover" , bool )
	
end

LobbyCommand.AddCommand( "undercover" , function( pl , command, arguments )

	local bool = tobool( arguments[1] );
	if !pl:IsPrivAdmin() then return end
	
	pl:SetUndercover( bool );
	
end)
