
-- I'm crap at huds so this is gonna change soon

surface.CreateFont("akbar",{
	font = "akbar",
	size = 25,
	weight = 400,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})

local function surface_createfont_old(n1, size, weight, b1, b2, n2)
surface.CreateFont(n2,{
	font = n1,
	size = size,
	weight = weight,
	blursize = 0,
	scanlines = 0,
	antialias = b1,
	underline = b2,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})
end

local mat = Material( "lobby/hud.png" )
local h , w = 125 , 300
local x , y = ScrW() - ( w + 45 ) , ScrH( ) - ( h + 45 ) -- 45 px margins

local MoneyPosX , MoneyPosY = x + 138 , ( y + 50 ) -- for the font

local HealthBarX , HealthBarY = x + 106 , y + 75
local HealthBarH , HealthBarW = 24 , 0;
local HGradiant = Material( "lobby/gradiant_bw.png" )
local HTextX , HTextY = x + 191 , ( y + 86 ) -- for the font


hook.Add( "HUDPaint" , "HUD" , function()

	if GAMEMODE.RemoveDefaultHUD then hook.Remove( "HUDPaint" , "HUD" ) return end
	
	if (hook.Call("HUDShouldDraw",GAMEMODE,"lobby.defaulthud")) then
	
		-- Redo the HUD
	
		surface.SetDrawColor(Color(255, 255, 255, 255))
		surface.SetMaterial( mat )
		surface.DrawTexturedRect( x, y, w, h )
		
		draw.SimpleText(LocalPlayer():GetMoney(), "smalltitle", MoneyPosX, MoneyPosY , Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		
		HealthBarW = Lerp( 0.1, HealthBarW , ( LocalPlayer():Health() * 173 ) / 100 )
		
		//surface.SetDrawColor(Color(255 - ( LocalPlayer():Health() * 255 / 65 ), 0 + ( LocalPlayer():Health() * 255 / 100 ), 125, 255))
		local H = LocalPlayer():Health()
		if ( H > 30 ) then
			surface.SetDrawColor(Color(184, 255 , 52 , 255))
		elseif ( H > 20 ) then
			surface.SetDrawColor(Color(255 , 131 , 54 , 255))
		elseif ( H > 10 ) then
			surface.SetDrawColor(Color(242 , 0 , 0 , 255))
		else
			surface.SetDrawColor(Color(217 , 0 , 0 , 255))
		end
		
		surface.SetMaterial( HGradiant )
		surface.DrawTexturedRect( HealthBarX, HealthBarY, HealthBarW, HealthBarH )
		
		draw.SimpleText(LocalPlayer():Health() or 0, "smalltitle", HTextX , HTextY, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	
	end

end)

local function HideThings( name )
	if(name == "CHudHealth") or (name == "CHudBattery") or (name == "CHudAmmo")then
             return false
        end
        -- We don't return anything here otherwise it will overwrite all other 
        -- HUDShouldDraw hooks.
end
hook.Add( "HUDShouldDraw", "HideThings", HideThings )



function GM:GetTeamColor( ent )

	if IsValid( ent ) and ent:IsPlayer() then
		return ent:GetDisplayTextColor()
	else
		return color_default
	end

end



function GM:HUDDrawTargetID()
	local tr = util.GetPlayerTrace( LocalPlayer(), LocalPlayer():GetAimVector() )
	local trace = util.TraceLine( tr )
	if (!trace.Hit) then return end
	if (!trace.HitNonWorld) then return end
	
	local text = "ERROR"
	local font = "TargetID"
	local ply = trace.Entity

	if (trace.Entity:IsPlayer()) then
		text = ply:Nick()
	/*elseif trace.Entity:IsVehicle() then
		ply = trace.Entity:GetOwner()
		text = ply:Nick()*/
	else
		return
	end
	
	surface.SetFont( font )
	local w, h = surface.GetTextSize( text )
	
	local MouseX, MouseY = gui.MousePos()
	
	if ( MouseX == 0 && MouseY == 0 ) then
	
		MouseX = ScrW() / 2
		MouseY = ScrH() / 2
	
	end
	
	local x = MouseX
	local y = MouseY
	
	x = x - w / 2
	y = y + 30
	
	draw.SimpleText( text, font, x+1, y+1, Color(0,0,0,120) )
	draw.SimpleText( text, font, x+2, y+2, Color(0,0,0,50) )
	draw.SimpleText( text, font, x, y, ply:GetDisplayTextColor() )
end


hook.Add("Initialize", "LobbyInit", function() 
    local font = "CenterPrintText"
    
	surface_createfont_old("Arial",10,600,false,false,"tiny")
	surface_createfont_old("Arial",14,400,true,false,"small")
	surface_createfont_old("Arial",16,600,true,false,"smalltitle")

	surface_createfont_old(font,45,100,true,false,"Lobbyhuge")
	surface_createfont_old(font,45,1200,true,false,"Lobbyhugebold")
	surface_createfont_old(font,28,125,true,false,"Lobbybig")
	surface_createfont_old(font,20,1200,true,false,"Lobbybigbold")
	surface_createfont_old(font,28,125,true,false,"Lobbylocation")
	surface_createfont_old(font,18,125,true,false,"ScoreboardText")

    surface_createfont_old(font,16,1200,true,false,"Lobbymidbold")
end ) 
