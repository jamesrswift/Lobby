--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, Chewgum, 2015
	
-----------------------------------------------------------]]--

local ProgressHud = surface.GetTextureID( "models/clannv/nvincoming/hud/progress_bar" )

function GM:HUDPaint()

	self.BaseClass:HUDPaint()
	
	surface.SetTexture( ProgressHud )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawTexturedRect( 0, ScrH() - 45, 256, 64 )
	
	if ( self.WinnerSpots[ game.GetMap() ] and LocalPlayer():Team() == 1 ) then
	
		local Dist = math.floor( LocalPlayer():GetPos():Distance( self.WinnerSpots[ game.GetMap() ].Spot ) )
		
		surface.SetDrawColor( 0, 200, 0, 240 )
		surface.DrawRect( 3, ScrH() - 35, 245 - math.Clamp( 245 * ( Dist / self.WinnerSpots[ game.GetMap() ].Distance ) - 1, 0, 245 ), 25 )
		
	end
	
end

function GM:HUDDrawTargetID()

	return

end