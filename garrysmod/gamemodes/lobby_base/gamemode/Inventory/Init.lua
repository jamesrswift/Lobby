// inventory D:

LobbyInventory = { }

include( "HexSave.lua" )
include( "Item.lua" )
include( "Shops.lua" )

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "Shops.lua" )
AddCSLuaFile( "Item.lua" )

hook.Add( "InitPostEntity", "SpawnShops" , function( )

	print ("InitPostEntity")

	for k,v in pairs( Shops ) do
	
		print "Spawning shop"
		local Shop = ents.Create( "snpc_wanderingcitizen" )
		Shop:SetAngles( v.Angles )
		Shop:SetPos( v.Position )
		if v.WorldModel then
			Shop:SetModel( v.WorldModel )
		end
		Shop:SetUseType( SIMPLE_USE )
		function Shop:Use( Activator , Use_Type )
			if ( Activator:IsPlayer() ) then
				umsg.Start( "ShopOpen" ) umsg.Short( k ) umsg.End()
			end
		end
	
	end

end)