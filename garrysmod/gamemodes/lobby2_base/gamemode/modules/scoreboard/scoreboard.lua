--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, 2015
	
-----------------------------------------------------------]]--

local PANEL = { }

function PANEL:Init( )

	self.Header = self:Add( "Panel" )
	self.Header:Dock( TOP )
	self.Header:SetHeight( 100 )

	self.Name = self.Header:Add( "DLabel" )
	self.Name:SetFont( "ScoreboardDefaultTitle" )
	self.Name:SetTextColor( Color( 255, 255, 255, 255 ) )
	self.Name:Dock( TOP )
	self.Name:SetHeight( 40 )
	self.Name:SetContentAlignment( 5 )
	self.Name:SetExpensiveShadow( 2, Color( 0, 0, 0, 200 ) )

	--self.NumPlayers = self.Header:Add( "DLabel" )
	--self.NumPlayers:SetFont( "ScoreboardDefault" )
	--self.NumPlayers:SetTextColor( Color( 255, 255, 255, 255 ) )
	--self.NumPlayers:SetPos( 0, 100 - 30 )
	--self.NumPlayers:SetSize( 300, 30 )
	--self.NumPlayers:SetContentAlignment( 4 )

	self.Scores = self:Add( "DScrollPanel" )
	self.Scores:Dock( FILL )

end

function PANEL:PerformLayout()

	self:SetSize( 700, ScrH() - 200 )
	self:SetPos( ScrW() / 2 - 350, 100 )

end

function PANEL:Think( w, h )

	self.Name:SetText( GetHostName() )

	for id, pl in pairs( player.GetAll() ) do
	
		if ( IsValid( pl.ScoreEntry ) ) then continue end

		pl.ScoreEntry = vgui.Create( "lobby_scoreboard_player" )
		pl.ScoreEntry:Setup( pl )
		
		pl.ScoreEntry:SetupColumns( hook.Run( "LobbyScoreboard", pl ) or {} )

		self.Scores:AddItem( pl.ScoreEntry )

	end

end

vgui.Register( "lobby_scoreboard", PANEL, "Panel" )
