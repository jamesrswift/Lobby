-- vgui/user_container.lua


local PANEL = {}
AccessorFunc( PANEL, "_Player", "Player" )
AccessorFunc( PANEL, "Color", "Color" )

function PANEL:Init()
	self.Color = false;
	self.Players = {};
	
	local sbar = self:GetVBar()
	function sbar:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
	end
	function sbar.btnUp:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0,0,0,50))
	end
	function sbar.btnDown:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0,0,0,100))
	end
	function sbar.btnGrip:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0,0,0,50))
	end
end

function PANEL:Paint( w, h )
	draw.RoundedBox( 4, 0, 0, w, h, self.Color or Color(0,0,0,100))
end

function PANEL:AddPlayer( _Player )
	self.Players[_Player] = vgui.Create("scoreboard.user", self)
	self.Players[_Player]:SetPlayer( _Player )
	
	for order, _column in ipairs( Scoreboard.Columns ) do
		self.Players[_Player]:AddColumn( order, _column[1],_column[2], _column[3] )
	end
	
	self.Players[_Player]:Update()
	--self.Players[_Player]:Dock(FILL)
	--self.Players[_Player]:DockMargin(5,5,5,5);
	
	-- Update size
	local w,h = self:GetSize()
	self:SetSize( w, 38 * table.Count(self.Players) + 1)

end


vgui.Register( "scoreboard.user_container", PANEL, "DScrollPanel" )