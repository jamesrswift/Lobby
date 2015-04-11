-- scoreboard.lua

TAB_SCORES = 1
TAB_HELP = 2
TAB_ADMIN = 3

Scoreboard = {}
Scoreboard.Columns = { }
Scoreboard.CurrentTab = TAB_SCORES

function GM:ScoreboardShow()
	self.ShowMenu = true
	gui.EnableScreenClicker( true )
	
	Scoreboard.Scores = vgui.Create("scoreboard.user_container" )
	Scoreboard.Scores:SetSize( ScrW() * 3/4, ScrH() - 180 )
	Scoreboard.Scores:SetPos( ScrW() * 1/8, 162 )

	for k,v in pairs ( player.GetAll() ) do
		Scoreboard.Scores:AddPlayer(v)
	end
	
	

end

function GM:ScoreboardHide()
	self.ShowMenu = false
	gui.EnableScreenClicker( false )
	
	if Scoreboard.Scores then
		Scoreboard.Scores:Remove()
	end
end

-----------------------------------------
--	Get information from GAMEMODE
-----------------------------------------

local function GetThatInformation( )
	local returned = hook.Call( "Scoreboard", GAMEMODE )
	for k,v in ipairs( returned ) do
		Scoreboard.Columns[ k ] = { v[1], v[2], v[3] }
	end
end
hook.Add( "Initialize" , "GetScoreboardInformation" , GetThatInformation )


local function GetScoreboardColors()
	Scoreboard.HIGHLIGHT ,Scoreboard.BGCOLOR ,Scoreboard.SLBLOGOMAT ,Scoreboard.CELLALPHA, Scoreboard.BUTTONTEXT, Scoreboard.BUTTONBG, Scoreboard.BUTTONBORD = hook.Call( "ScoreboardColors" , GAMEMODE );
end

hook.Add( "Initialize" , "ScoreboardColors" , GetScoreboardColors )

-----------------------------------------
-- Draw functions
-----------------------------------------

function Scoreboard.DrawLogoBox( x, y, w, h )
	local xCenter = math.floor( x + ( w / 2 ) )
	local yCenter = math.floor( y + ( h / 2 ) )
	
	surface.SetMaterial( Scoreboard.SLBLOGOMAT )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawTexturedRect( xCenter-64, yCenter-63, 128, 128 )
	
	local Add = 0
	if #GAMEMODE.ScoreboardName > 5 then -- The hud was designed for the "Lobby" word only. Retrospect is nice :)
		do
			surface.SetFont( "Lobbyhugebold" )
			Add = surface.GetTextSize( string.sub( GAMEMODE.ScoreboardName , 6 , #GAMEMODE.ScoreboardName ) )
		end
	end

	draw.SimpleTextOutlined(GAMEMODE.ScoreboardName, "Lobbyhugebold", xCenter - ( 200 + Add ), yCenter - 31, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 1, Color(0,0,0,255))
	draw.SimpleTextOutlined(GAMEMODE.Community, "Lobbyhugebold", xCenter + 80, yCenter - 31, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 1, Color(0,0,0,255))
	draw.SimpleTextOutlined(GAMEMODE.Website, "Lobbybigbold", xCenter + 90, yCenter + 21, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 1, Color(0,0,0,255))
end

function GM:HUDDrawScoreBoard()
	if ( self.ShowMenu ) then
		local bWidth = math.floor( math.Clamp( ScrW() - ( ScrW()/5 ), 600, 900 ) )
		local startX = math.floor( ( ScrW() - bWidth ) / 2 )
		local startY = 32
		Scoreboard.DrawLogoBox( startX, startY, bWidth, 130 )
		startY = startY + 130
		
		--Buttons_Render( startX, startY, bWidth, 32 )
		startY = startY +32
		
		--if CurrentTab == TAB_SCORES then
		--	HUDDrawScoreBoard( startX, startY, bWidth )
		--elseif CurrentTab == TAB_HELP then
		--	HUDDrawHelpScreen( startX, startY, bWidth )
		--elseif CurrentTab == TAB_ADMIN then
		--	HUDDrawAdminScreen( startX, startY, bWidth )
		--end
	end
end