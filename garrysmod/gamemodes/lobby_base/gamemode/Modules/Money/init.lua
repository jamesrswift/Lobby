
Currency = {}
Currency.Cache ={}
Currency.DefaultMoney = 0;

include( "shared.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )

function Currency:UpdatePlayerOnStates( Pl )
	Pl:SetNWInt( "fMoney" , Currency.Cache[ Pl:UniqueID() ][1] )
end


hook.Add( "DatabaseConnect" , "Currency", function()
	mysql.SelectFromTable( "gm_user" , { "ID" , "Money" , "LastJoined" },  function(data) for k,v in pairs( data ) do Currency.Cache[ v[1] ] = { v[2] , v[3] } end end )
end)

hook.Add( "PlayerInitialSpawn" , "Currency", function( Pl )

	if !Currency.Cache[ Pl:UniqueID() ] and !Pl:IsBot() then
	
		mysql.Insert( "gm_user" , { "ID" , "Money" , "LastJoined", "Name" , "SteamID" } , { Pl:UniqueID() or 1 , Currency.DefaultMoney , os.time(), Pl:Nick(), Pl:SteamID() } )
		Currency.Cache[ Pl:UniqueID() ] = { Currency.DefaultMoney , os.time() }
			
		hook.Call( "OnPlayerFirstJoined" , GAMEMODE , Pl )
		
	end
	
	if Pl:IsBot() then
		Currency.Cache[ Pl:UniqueID() ] = { 0 , os.time() }
	end
	
	mysql.Query( "UPDATE gm_user SET LastJoined="..os.time().." WHERE ID='"..Pl:UniqueID().."'" )
	
	Currency:UpdatePlayerOnStates( Pl )

end)

local PlayerMeta = FindMetaTable("Player")

function PlayerMeta:AwardMoney( Amount )

	Amount = hook.Call( "OnAwardMoney" , GAMEMODE , self, Amount ) or Amount
	
	self:GiveMoney( Amount )

end

function PlayerMeta:GiveMoney( Amount, NoHook )

	Currency.Cache[ self:UniqueID() ][1] = Currency.Cache[ self:UniqueID() ][1] + Amount
	if (!self:IsBot()) then
		mysql.Query( "UPDATE gm_user SET Money="..Currency.Cache[ self:UniqueID() ][1].." WHERE ID='"..self:UniqueID().."'" )
	end
	Currency:UpdatePlayerOnStates( self )
	
	if NoHook then return end

	hook.Call( "OnGiveMoney" , GAMEMODE , Pl, Amount )
	
end

function PlayerMeta:TakeMoney( Amount )

	self:GiveMoney( -Amount, true )
	
	hook.Call( "OnTakeMoney" , GAMEMODE , self, Amount )
	
end

function PlayerMeta:SetMoney( Amount )

	Currency.Cache[ self:UniqueID() ][1] = Amount
	if !self:IsBot() then
		mysql.Query( "UPDATE gm_user SET Money="..Currency.Cache[ self:UniqueID() ][1].." WHERE ID='"..self:UniqueID().."'" )
	end
	Currency:UpdatePlayerOnStates( self )

	hook.Call( "OnSetMoney" , GAMEMODE , self, Amount )
	
end
