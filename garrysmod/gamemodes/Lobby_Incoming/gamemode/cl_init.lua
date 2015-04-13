include( "shared.lua" )
include( "sh_config.lua" )
include( "cl_deathnotice.lua" )
include( "cl_hud.lua" )

function GM:Scoreboard( )

	local r ={ 
		{"Location",300, function(pl) return "Incoming" end},
		{"Tokens",150, function(pl) return pl:GetMoney() end},
		{"Ping",30, function( pl ) return pl:Ping() end}
	}
	
	return r
	
end

function GM:ScoreboardColors( )

	local Highlight = Color( 255, 255, 255, 255 )
	local bg = Color( 18, 89, 148, 255 )
	local mat = Material( "Lobby/logo.png" )
	local A = 200

	local ButtonText = Color( 240,240,240,255 )
	local ButtonBG = Color( 20, 140, 230, 255 )
	local ButtonBorder = Color( 45, 144, 208, 255 )
	
	
	return Highlight,bg, mat, A,ButtonText,ButtonBG,ButtonBorder;
	
end

function GM:AllowChatIcons( linedata )
	--linedata struct = {icon(optional), textdata(same format as chat.AddText), printedon = RealTime()}	

	return true
	
end

function GM:ChatBoxColorPaint( Alpha )

	return Color( 0 , 130 , 220, Alpha )
	
end

function GM:GetTeamColor( Entity )

	if Entity:IsPlayer() then
		local teamID = Entity:Team()
		return team.GetColor( teamID )
	end
end