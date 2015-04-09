// SteamAPI.lua

SteamAPI = { }

function SteamAPI.SteamTo32Bit( String )

	local Int = 0
	st = string.Explode( ":", string.gsub( String , "STEAM_", "" ) )
	Int = tonumber( st[3] ) * 2  + tonumber( st[2] )
	
	return Int

end

function SteamAPI.Bit23ToSteam( String )


end