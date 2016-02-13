--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, 2015
	
-----------------------------------------------------------]]--

--[[---------------------------------------------------------
	Name: gamemode:ScoreboardShow( )
	Desc: Sets the scoreboard to visible
-----------------------------------------------------------]]
function Module:ScoreboardShow()

	if ( !IsValid( self.Scoreboard ) ) then
		self.Scoreboard = vgui.Create( "lobby_scoreboard" )
	end

	if ( IsValid( self.Scoreboard ) ) then
		self.Scoreboard:Show()
		self.Scoreboard:MakePopup()
		self.Scoreboard:SetKeyboardInputEnabled( false )
	end

	return true
	
end

--[[---------------------------------------------------------
	Name: gamemode:ScoreboardHide( )
	Desc: Hides the scoreboard
-----------------------------------------------------------]]
function Module:ScoreboardHide()

	if ( IsValid( self.Scoreboard ) ) then
		self.Scoreboard:Hide()
	end

	return true
	
end

--[[---------------------------------------------------------
	Name: gamemode:HUDDrawScoreBoard( )
	Desc: If you prefer to draw your scoreboard the stupid way (without vgui)
-----------------------------------------------------------]]
function Module:HUDDrawScoreBoard()

end