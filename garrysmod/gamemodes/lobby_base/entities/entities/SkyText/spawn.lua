

local Map = game.GetMap()

local Spawn = {
	
	["lobby_a3"] = {
	
		{ Vector( -432 , -1752 , 175 ) , Angle( 0 , 90, 0 ) , "infodesk" }
	
	}

}

function AddText( text , Vec , Ang, Map )
	Spawn[ Map ] = Spawn[ Map ] or { }
	Spawn[ Map ][ #Spawn[ Map ] + 1 ] = { Vec, Ang, text }
end


local function SpawnSkyText()

	if !Spawn[ string.lower( game.GetMap() ) ] then return end

	for k,v in pairs( Spawn[ string.lower( game.GetMap() ) ] ) do
	
		local ent = ents.Create( "SkyText" )
		ent:SetPos(v[1])
		ent:SetAngles(v[2])
		ent:SetNWString( "Text", v[3] )
		ent:Spawn()
		ent:DrawShadow( false )
		
		local ent = ents.Create( "SkyText" )
		ent:SetPos(v[1])
		ent:SetAngles(v[2] + Angle( 0 , 180 , 0 ))
		ent:SetNWString( "Text", v[3] )
		ent:Spawn() 
		ent:DrawShadow( false )

	end
	
end
hook.Add("InitPostEntity", "SpawnSkyTexts", SpawnSkyText)
