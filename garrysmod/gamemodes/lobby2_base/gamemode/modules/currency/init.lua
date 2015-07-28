--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, 2015
	
-----------------------------------------------------------]]--

Module.Hooks = {
	"PlayerInformationLoaded"
}

local PlayerMeta = FindMetaTable("Player")

function Module:UpdatePlayerOnStates( Pl )

	Pl:SetNWInt( "fMoney" , Pl:GetData().money or 0 )
	Pl:SaveData()

end

function Module:PlayerInformationLoaded( Pl )

	self:UpdatePlayerOnStates( Pl )

end

function PlayerMeta:AwardMoney( Amount )

	self:GiveMoney( hook.Run( "OnAwardMoney", self, Amount ) or Amount )

end

function PlayerMeta:GiveMoney( Amount, NoHook )

	local data = self:GetData()
	data.money = (data.money or 0) + Amount
	Module:UpdatePlayerOnStates( self )
	
	if ( not NoHook ) then
		hook.Run( "OnGiveMoney", self, Amount )
	end
	
end

function PlayerMeta:TakeMoney( Amount )

	self:GiveMoney( -Amount, true )
	hook.Run( "OnTakeMoney", self, Amount )
	
end

function PlayerMeta:SetMoney( Amount )

	local data = self:GetData()
	data.money = Amount
	Module:UpdatePlayerOnStates( self )

	hook.Run( "OnSetMoney", self, Amount )
	
end
