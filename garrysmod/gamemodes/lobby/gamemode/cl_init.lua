--[[

  __  __    ___ ___ _  _    ____ ___  __  __  __    ___  __ __ ___ 
 / _)/ _)  (   \  _) )( )  (_  _)  _)(  )(  \/  )  (__ \/  \  )__ \
( (_( (/\   ) ) ) _)\\//     )(  ) _)/__\ )    (   / __/ () )(/ __/
 \__)\__/  (___/___)(__)    (__)(___)_)(_)_/\/\_)  \___)\__/__)___)

	Copyright (c) James Swift, Alex Swift 2012
 
 --]]


include( "shared.lua" )
include("calcview.lua")

function GM:Scoreboard( )

	local r ={ 
		{"Location",300, function(pl) return pl:GetLocation() end},
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
