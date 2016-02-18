--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, 2015
	
-----------------------------------------------------------]]--


GM.Shops = {

	[1] = {
	
		Name = "Template Shop",
		Position = Vector( 1033, -432, 64 ),
		Angles = Angle(0, 270, 0 ),
		WorldModel = Model( "models/Humans/Group01/Male_01.mdl" )
	
	}

}

hook.Add( "InitPostEntity", "SpawnShops" , function( )

	if ( CLIENT ) then return end

	if ( SERVER ) then return end -- disable for the moment
	
	local GM = GM or gmod.GetGamemode( )

	for shop_id, shop_info in pairs( GM.Shops ) do
	
		local Shop = ents.Create( "snpc_shop" )
		Shop:SetAngles( shop_info.Angles )
		Shop:SetPos( shop_info.Position )
		if shop_info.WorldModel then
			Shop:SetModel( shop_info.WorldModel )
		end
		
		Shop:Spawn()
		Shop:SetShopID( shop_id )
		
	end

end)