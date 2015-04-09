

local function GetScoreboardColors()
	HIGHLIGHT ,BGCOLOR ,SLBLOGOMAT ,CELLALPHA, BUTTONTEXT, BUTTONBG, BUTTONBORD = hook.Call( "ScoreboardColors" , GAMEMODE );
end

hook.Add( "Initialize" , "ScoreboardColors" , GetScoreboardColors )

function SetDrawColor( colort, alphaoverwrite )
	alphaoverwrite = alphaoverwrite or colort.a
	surface.SetDrawColor( colort.r, colort.g, colort.b, alphaoverwrite )
end

function SetTextColor( colort, alphaoverwrite )
	alphaoverwrite = alphaoverwrite or colort.a
	surface.SetTextColor( colort.r, colort.g, colort.b, alphaoverwrite )
end


function DrawLogoBox( x, y, w, h )
	local xCenter = math.floor( x + ( w / 2 ) )
	local yCenter = math.floor( y + ( h / 2 ) )
	
	surface.SetMaterial( SLBLOGOMAT )
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

TAB_SCORES = 1
TAB_HELP = 2
TAB_ADMIN = 3

include( 'cl_scoreboard.lua' )
include( 'cl_helpscreen.lua' )
include( 'cl_mbuttons.lua' )

CurrentTab = TAB_SCORES

function GM:ScoreboardShow()
	self.ShowMenu = true
	gui.EnableScreenClicker( true )
end

function GM:ScoreboardHide()
	self.ShowMenu = false
	gui.EnableScreenClicker( false )
end

function GM:HUDDrawScoreBoard()
	if ( self.ShowMenu ) then
		local bWidth = math.floor( math.Clamp( ScrW() - ( ScrW()/5 ), 600, 900 ) )
		local startX = math.floor( ( ScrW() - bWidth ) / 2 )
		local startY = 32
		DrawLogoBox( startX, startY, bWidth, 130 )
		startY = startY + 130
		
		Buttons_Render( startX, startY, bWidth, 32 )
		startY = startY +32
		
		if CurrentTab == TAB_SCORES then
			HUDDrawScoreBoard( startX, startY, bWidth )
		elseif CurrentTab == TAB_HELP then
			HUDDrawHelpScreen( startX, startY, bWidth )
		elseif CurrentTab == TAB_ADMIN then
			HUDDrawAdminScreen( startX, startY, bWidth )
		end
	end
end
