--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, 2015
	
-----------------------------------------------------------]]--

GM.Adverts = GM.Adverts or { }
GM.Adverts.RT = GM.Adverts.RT or { }

function GM:DrawAdvert( AdvertID, RT )
	draw.RoundedBox( 2, 0, 0, ScrW(), ScrH(), Color( 125, 246, 23 ) )
	draw.DrawText( "WOOOOO this mother fucking works", "DermaLarge", 0, math.sin( CurTime() * 3 ) * 40 + 120, color_white, TEXT_ALIGN_LEFT )
end



matproxy.Add( {
	name = "LobbyAdvert",
	
	init = function( self, mat, values )
		
		local GM = GM or gmod.GetGamemode( )
		
		if ( not GM.Adverts.RT[ values.advert ] ) then
			GM.Adverts.RT[ values.advert ] = GetRenderTarget( "LobbyAdvert" .. values.advert , 1024, 1024, false )
		end
		
		self.AdvertID = values.advert
		self.RT = GM.Adverts.RT[ values.advert ]
		mat:SetTexture( "$basetexture", self.RT )
	
	end,
	
	bind = function( self, mat, ent )
		
	end
} )

hook.Add( "Think", "UpdateRenderTargets", function( )

	local GM = GM or gmod.GetGamemode()
	
	for k,v in pairs( GM.Adverts.RT ) do
	
		local oldw, oldh = ScrW(), ScrH()
		local oldrt = render.GetRenderTarget( )
		
		cam.Start2D( )
		render.SetRenderTarget( v )
			render.SetViewPort( 0, 0, 1024, 1024 )
			render.Clear( 0, 0, 0, 255 )
		
				hook.Run( "DrawAdvert", k, v )
		
			render.SetViewPort( 0, 0, oldw, oldh )
		render.SetRenderTarget( oldrt )
		cam.End2D( )
	
	end

end)
