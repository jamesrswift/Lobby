// sv_player.lua

function GM:OnPlayerFirstJoin( Pl )


end

function GM:OnAwardMoney( Pl, Amount)

	if Pl:IsVip() then
	
		return math.ceil( Amount * 1.25 )
	
	end
	
	return Amount

end

function GM:OnGiveMoney( Pl , Amount )


end

function GM:OnTakeMoney( Pl , Amount )


end

function GM:OnSetMoney( Pl , Amount )


end

function GM:PlayerEnterVehicle( Pl, Seat )


end

function GM:PlayerExitVehicle( Pl, Seat )


end

function GM:PlayerStuck( Pl, Ent )


end