--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, Alex Swift, ULX, 2015
	
-----------------------------------------------------------]]--

local Module = Module

function Module:NetResize( )
	
	local Pl = net.ReadEntity()
	local pscale = net.ReadFloat() or 1
	
	-- Scale the player model
	local ScaleVector = pscale * Vector(1,1,1)
	Pl:SetModelScale( pscale, 0 )
	Pl:SetRenderBounds( pscale * self.Sizing.Default.StandingHull.Minimum, pscale * self.Sizing.Default.StandingHull.Maximum )			
	
	-- Scale the player view offset
	local vsc = Pl:GetNetworkedFloat("PlViewOffset")
	Pl:SetViewOffset( vsc * self.Sizing.Default.ViewOffset )
	Pl:SetViewOffsetDucked( vsc * self.Sizing.Default.ViewOffsetDuck )
	
	-- Scale the player hull
	local hsc = Pl:GetNetworkedFloat("PlHullScale", 1 )
	Pl:SetHull( hsc * self.Sizing.Default.StandingHull.Minimum , hsc * self.Sizing.Default.StandingHull.Maximum )
	Pl:SetHullDuck( hsc * self.Sizing.Default.DuckingHull.Minimum , hsc * self.Sizing.Default.DuckingHull.Maximum )
	
end

net.Receive( "lobby2.resize", function() Module:NetResize() end )