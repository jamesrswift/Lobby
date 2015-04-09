
local ScoreBoardInfo = { }
local ScoreBoardColums = { }

local function GetThatInformation( )

	local returned = hook.Call( "Scoreboard", GAMEMODE )
	
	for k,v in ipairs( returned ) do
		ScoreBoardColums[ k ] = { v[1], v[2] }
		ScoreBoardInfo[ k ] = v[3]
	end

end

hook.Add( "Initialize" , "GetScoreboardInformation" , GetThatInformation )

local function CreatePlayerInfo( pl )
	local pinfo = { }
	for k,v in pairs( ScoreBoardInfo ) do
		pinfo[ k ] = v( pl );
	end
	
	return pinfo
end

local function GetScoreboardTable()
	local STable = {}	

	for id, pl in ipairs( player.GetAll() ) do
		local tid = pl:Team()
		if !STable[tid] then
			STable[tid] = {}
			STable[tid].Color = team.GetColor( team ) --Set name as color of team
			STable[tid].Players = {}
		end
		
		local PlayerInfo = CreatePlayerInfo( pl )		
		local insertPos = #STable[tid].Players + 1
		
		for idx, info in pairs( STable[tid].Players ) do --Sorts the players
			if ( PlayerInfo[1] < info[1] ) then --Sorts by location
				insertPos = idx
				break
			end
		end		
		table.insert( STable[tid].Players, insertPos, PlayerInfo )
	end
	return STable
end

function HUDDrawScoreBoard( startX, startY, bWidth )
	local Captions = ScoreBoardColums;
	local STable = GetScoreboardTable()
	
	local bHeight = 0
	
	// Get the font height
	surface.SetFont( "Lobbymidbold" )
	local txWidth, txHeight = surface.GetTextSize( "W" )		
	local RowHeight = txHeight + 4
	txWidth, txHeight = nil, nil
			
	// Column width definitions
	local ColWidths = { }
	for k, v in pairs( Captions ) do
		local tcol = {}
		tcol.width = math.floor( ( v[2]/100 ) * ( bWidth ) )
		tcol.start = 0
		if #ColWidths > 0 then
			for _, i in pairs( ColWidths ) do
				tcol.start = tcol.start + i.width
			end
		end
		ColWidths[k] = tcol
	end
	
	// Scoreboard table creation	
	local SBT = {}
	
	// - The row with the captions
	local CaptionRow = {}
	CaptionRow.TYPE = "Captions"
	CaptionRow.Color = BGCOLOR
	CaptionRow.TColor = Color( 255, 255, 255, 255 )
	CaptionRow.Cols = {}
	for k, v in pairs( Captions ) do
		table.insert( CaptionRow.Cols, v[1] )
	end
	table.insert( SBT, #SBT+1, CaptionRow )
	CaptionRow = nil
	
	// - The rows with the players
	for tid, tinfo in pairs( STable ) do
		local tcolorn = Color( 84, 168, 222, CELLALPHA )
		local tcolorh = Color( 49, 138, 196, CELLALPHA )
		for pid, pinfo in pairs( tinfo.Players ) do
			local trow = {}
			trow.TYPE = "Player"
			trow.Color = tcolorn
			if ( ( #SBT % 2 ) == 0 ) then
				trow.Color = tcolorh
			end
			if tid == 2 then
				trow.TColor = Color(255,0,0,255)
			else
				trow.TColor = Color(255,255,255,255)
			end
			trow.Cols = pinfo
			table.insert( SBT, #SBT+1, trow )
		end
	end
	
	// Draw the Scoreboard table
	bHeight = #SBT * RowHeight + 10
	
	//surface.SetDrawColor( BGCOLOR )
	//surface.DrawRect( startX, startY, bWidth, bHeight )
	
	startY = startY + 5
	draw.RoundedBox( 6, startX - 4, startY - 4, bWidth + 10, bHeight + 10, BGCOLOR )
	
	local ry = 0
	for rid, row in pairs( SBT ) do
		ry = startY + (rid - 1) * RowHeight
		SetDrawColor( row.Color )
		surface.DrawRect( startX, ry, bWidth, RowHeight )
		for cid, col in pairs( row.Cols ) do
			local rx = startX + ColWidths[cid].start
			local rw = ColWidths[cid].width
			local txWidth, txHeight = surface.GetTextSize( tostring( col or "ERROR" ) )
			rx = rx + ( rw / 2 ) - ( txWidth / 2 )
			surface.SetFont( "ScoreboardText" )
			
			SetTextColor( row.TColor )
			surface.SetTextPos( math.floor( rx ), math.floor( ry ) + 2 )
			surface.DrawText( col  )
		end 
	end
	SetDrawColor( HIGHLIGHT )
	
	SetDrawColor( BGCOLOR )
	surface.DrawRect( startX, ry + RowHeight, bWidth, 10 )
	
	for _, col in pairs( ColWidths ) do
		if col.start > startX then
			surface.DrawLine( startX + col.start, startY, startX + col.start, startY + bHeight )
		end
	end
	
	SetDrawColor( BGCOLOR )
	surface.DrawOutlinedRect( startX, startY, bWidth, bHeight )
	
	surface.SetDrawColor( 45, 144, 208, 127 )
	surface.DrawOutlinedRect( startX-1, startY-1, bWidth+2, bHeight+2 )
end