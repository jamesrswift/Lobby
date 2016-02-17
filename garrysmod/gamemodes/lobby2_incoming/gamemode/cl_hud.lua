--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, Chewgum, 2015
	
-----------------------------------------------------------]]--

local hud_bg = Material( "gui/hud_bg" )
local hud_fg = Material( "gui/hud_fg" )

function GM:HUDPaint()

	--self.BaseClass:HUDPaint()
	
	local base_x, base_y = 0, ScrH() - 105
	
	surface.SetMaterial( hud_bg )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawTexturedRect( base_x, base_y, 256, 256 )
	
	if ( self.WinnerSpots[ game.GetMap() ] and LocalPlayer():Team() == 1 ) then
	
		self:HUDPaintProgressBar( base_x, base_y, math.floor( LocalPlayer():GetPos():Distance( self.WinnerSpots[ game.GetMap() ].Spot ) ), self.WinnerSpots[ game.GetMap() ].Distance )
		
	end
	
	surface.SetMaterial( hud_fg )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawTexturedRect( base_x, base_y, 256, 256 )
	
end

function GM:HUDPaintProgressBar( base_x, base_y, Distance, TotalDistance )

	surface.SetDrawColor( 0, 200, 0, 240 )
	surface.DrawRect( base_x + 53 , base_y + 53, math.Clamp( 190 * ( 1 - Distance / TotalDistance ), 0, 192 ), 36 )

end

function GM:HUDDrawTargetID()

	return

end