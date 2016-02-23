--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, 2015
	
-----------------------------------------------------------]]--

GM.Inventory.TrailManager = GM.Inventory.TrailManager or { }
GM.Inventory.TrailManager.Players = GM.Inventory.TrailManager.Players or setmetatable( { }, {__mode="k"} )
GM.Inventory.TrailManager.Materials = GM.Inventory.TrailManager.Materials or { }
GM.Inventory.TrailManager.DieTime = 1

function GM.Inventory.TrailManager:ManagePlayer( Pl, Material )

	if ( not self.Materials[ Material ] ) then
		self:CreateMaterial( Material )
	end
	
	if ( self.Players[ Pl ] ) then
		
		-- Update the material
		self.Players[ Pl ].Material = self.Materials[ Material ]
		return
		
	end
	
	self.Players[ Pl ] = {
		Material = self.Materials[ Material ],
		--Mesh = Mesh( Material ),
		Segments = { }
	}

end


function GM.Inventory.TrailManager:UnmanagePlayer( Pl )

	self.Players[ Pl ] = nil

end

function GM.Inventory.TrailManager:CreateMaterial( Material )

	if ( self.Materials[ Material ] ) then
		return self.Materials[ Material ]
	end
	
	self.Materials[ Material ] = CreateMaterial( "TrailManager_" .. Material, "UnlitGeneric", {
		["$basetexture"] = Material,
		["$vertexcolor"] = 1,
		["$vertexalpha"] = 1,
		["$model"] = 1,
	
	})
	
	return self.Materials[ Material ]

end

function GM.Inventory.TrailManager:Think( )

	local Garbage = { }

	for Pl, data in pairs( self.Players ) do
	
		if ( IsValid( Pl ) ) then
		
			local last_segment = data.Segments[ #data.Segments ]
			
			if ( not last_segment ) then
				table.insert( data.Segments, { pos = Pl:GetPos(), time = CurTime( ) } )
				return
			end
			
			if ( Pl:GetPos():DistToSqr( last_segment.pos ) > 15 and Pl:Alive( ) ) then
			
				if ( #data.Segments >= 400 ) then
				
					table.remove( data.Segments, 1 )
				
				end
				
				table.insert( data.Segments, { pos = Pl:GetPos(), time = CurTime( ) } )
			
			end
			
		else
		
			table.insert( Garbage, Pl )
		
		end
	
	end
	
	for k,v in pairs( Garbage ) do self.Players[ v ] = nil end

end

function GM.Inventory.TrailManager:PruneOldSegments( Pl )

	local delete = { }

	for k, data in pairs( self.Players[ Pl ].Segments ) do
	
		if ( data.time + self.DieTime < CurTime() ) then
		
			table.insert( delete, k )
			
		end
	
	end
	
	for k, segment in pairs( delete ) do
		table.remove( self.Players[ Pl ].Segments, segment )
	end

end

function GM.Inventory.TrailManager:AddVertex( pos, u, v, color)

	mesh.Position( pos )
	mesh.TexCoord( 0, u, v )
	mesh.Color( color.r, color.g, color.b, color.a )
	mesh.AdvanceVertex()

end

function GM.Inventory.TrailManager:RebuildMesh( Pl )

	if ( not self.Players[ Pl ] ) then return end
	
	local lastpos
	local verts = { }

	mesh.Begin( MATERIAL_TRIANGLES, ( #self.Players[ Pl ].Segments - 1 ) * 4 )
	
	for k, data in ipairs( self.Players[ Pl ].Segments ) do
	
		if ( not lastpos ) then
			lastpos = data
			continue
		end
		
		local lastpos_up = Vector( 0, 0, 5 )
		lastpos_up:Rotate( ( lastpos.pos - EyePos() ):Angle() )
		
		local pos_up = Vector( 0, 0, 5 )
		pos_up:Rotate( ( data.pos - EyePos() ):Angle() )
		
		local last_color = Color( 255, 255, 255, math.max( 0, 255 * ( 1 - math.TimeFraction( lastpos.time , lastpos.time + self.DieTime, CurTime() ) ) ) )
		local cur_color = Color( 255, 255, 255, math.max( 0, 255 * ( 1 - math.TimeFraction( data.time , data.time + self.DieTime, CurTime() ) ) ) )
		
		-- First
		
		self:AddVertex( lastpos.pos, 1, 1, last_color)
		self:AddVertex( lastpos.pos + lastpos_up, 1, 0, last_color)
		self:AddVertex( data.pos, 0, 1, cur_color)
		
		self:AddVertex( lastpos.pos, 1, 1, last_color)
		self:AddVertex( data.pos, 0, 1, cur_color)
		self:AddVertex( lastpos.pos + lastpos_up, 1, 0, last_color)
		
		-- Second
		
		self:AddVertex( data.pos + pos_up, 0, 0, last_color)
		self:AddVertex( data.pos, 0, 1, cur_color)
		self:AddVertex( lastpos.pos + lastpos_up, 1, 0, last_color)
		
		self:AddVertex( data.pos + pos_up, 0, 0, last_color)
		self:AddVertex( lastpos.pos + lastpos_up, 1, 0, last_color)
		self:AddVertex( data.pos, 0, 1, cur_color)
	
		lastpos = data
	
	end
	
	mesh.End()

end

function GM.Inventory.TrailManager:Draw( Pl )

	if ( not self.Players[ Pl ] ) then return end

	self:PruneOldSegments( Pl )
	
	render.SetMaterial( self.Players[ Pl ].Material )
	self:RebuildMesh( Pl )

end

hook.Add( "PostDrawOpaqueRenderables", "Trails", function()

	--render.SuppressEngineLighting( true )

	for Pl, data in pairs( GAMEMODE.Inventory.TrailManager.Players ) do
	
		GAMEMODE.Inventory.TrailManager:Draw( Pl )
	
	end
	
	--render.SuppressEngineLighting( false )

end)
