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

	self.AvatarButton = self:Add( "DButton" )
	self.AvatarButton:Dock( LEFT )
	self.AvatarButton:SetSize( 32, 32 )
	self.AvatarButton.DoClick = function() self.Player:ShowProfile() end

	self.Avatar = vgui.Create( "AvatarImage", self.AvatarButton )
	self.Avatar:SetSize( 32, 32 )
	self.Avatar:SetMouseInputEnabled( false )

	self.Name = self:Add( "DLabel" )
	self.Name:Dock( FILL )
	self.Name:SetFont( "ScoreboardDefault" )
	self.Name:SetTextColor( Color( 93, 93, 93 ) )
	self.Name:DockMargin( 8, 0, 0, 0 )

	self:Dock( TOP )
	self:DockPadding( 3, 3, 3, 3 )
	self:SetHeight( 32 + 3 * 2 )
	self:DockMargin( 2, 0, 2, 2 )
	
	self.Columns = self.Columns or { }

end

function PANEL:SetupColumns( Columns )

	for i=#Columns, 1 do
	
		local Col = Columns[ i ]
		if ( Col ) then
		
			local Element = self:Add( Col.Element )
			Element:Dock( RIGHT )
			
			if ( Col.Width ) then
				Element:SetWidth( Col.Width )
			end
			
			if ( Col.Size ) then
				Element:SetSize( col.Size.x, Col.Size.y )
			end
			
			if ( Col.Font ) then
				Element:SetFont( Col.Font )
			end
			
			if ( Col.TextColor ) then
				Element:SetTextColor( Col.TextColor )
			end
			
			if ( Col.ContentAlignment ) then
				Element:SetContentAlignment( Col.ContentAlignment )
			end
			
			Element.UpdateFunction = Col.Update
			
			self.Columns[ Col.Name ] = Element
			
		end
		
	end

end

function PANEL:Setup( pl )

	self.Player = pl
	self.Avatar:SetPlayer( pl )
	self:Think( )

end

function PANEL:Think( )

	if ( !IsValid( self.Player ) ) then
		self:SetZPos( 9999 ) -- Causes a rebuild
		self:Remove()
		return
	end

	if ( self.PName == nil || self.PName != self.Player:Nick() ) then
		self.PName = self.Player:Nick()
		self.Name:SetText( self.PName )
	end
	
	for k, column in pairs( self.Columns ) do
	
		if ( column.UpdateFunction ) then
		
			column:UpdateFunction( self.Player )
		
		end
	
	end
	
	--
	-- Connecting players go at the very bottom
	--
	if ( self.Player:Team() == TEAM_CONNECTING ) then
		self:SetZPos( 2000 + self.Player:EntIndex() )
		return
	end

	--
	-- This is what sorts the list. The panels are docked in the z order,
	-- so if we set the z order according to kills they'll be ordered that way!
	-- Careful though, it's a signed short internally, so needs to range between -32,768k and +32,767
	--
	self:SetZPos( ( self.Player:Frags() * -50 ) + self.Player:EntIndex() )

end


function PANEL:DrawBackground( w, h )

	if ( !IsValid( self.Player ) ) then
		return
	end

	--
	-- We draw our background a different colour based on the status of the player
	--

	if ( self.Player:Team() == TEAM_CONNECTING ) then
		draw.RoundedBox( 4, 0, 0, w, h, Color( 200, 200, 200, 200 ) )
		return
	end

	if ( !self.Player:Alive() ) then
		draw.RoundedBox( 4, 0, 0, w, h, Color( 230, 200, 200, 255 ) )
		return
	end

	if ( self.Player:IsAdmin() ) then
		draw.RoundedBox( 4, 0, 0, w, h, Color( 230, 255, 230, 255 ) )
		return
	end

	draw.RoundedBox( 4, 0, 0, w, h, Color( 230, 230, 230, 255 ) )

end

function PANEL:Paint( w, h )

	self:DrawBackground( w, h )

end

vgui.Register( "lobby_scoreboard_player", PANEL, "Panel" )