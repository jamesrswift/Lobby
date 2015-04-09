-- cl_init.lua

include( "scoreboard.lua" )
include( "vgui/user.lua" )
include( "vgui/user_container.lua" )

local g_grds, g_wgrd, g_sz
function draw.GradientBox(x, y, w, h, al, ...)
	g_grds = {...}
	al = math.Clamp(math.floor(al), 0, 1)
	if(al == 1) then
		local t = w
		w, h = h, t
	end
	g_wgrd = w / (#g_grds - 1)
	local n
	for i = 1, w do
		for c = 1, #g_grds do
			n = c
			if(i <= g_wgrd * c) then break end
		end
		g_sz = i - (g_wgrd * (n - 1))
		surface.SetDrawColor(
			Lerp(g_sz/g_wgrd, g_grds[n].r, g_grds[n + 1].r),
			Lerp(g_sz/g_wgrd, g_grds[n].g, g_grds[n + 1].g),
			Lerp(g_sz/g_wgrd, g_grds[n].b, g_grds[n + 1].b),
			Lerp(g_sz/g_wgrd, g_grds[n].a, g_grds[n + 1].a))
		if(al == 1) then surface.DrawRect(x, y + i, h, 1)
		else surface.DrawRect(x + i, y, 1, h) end
	end
end