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
GM.Inventory.TrailManager.Players = GM.Inventory.TrailManager.Players or { }

function GM.Inventory.TrailManager:ManagePlayer( Pl, Material )

	if ( self.Players[ Pl ] ) then
		
		-- Update the material
		self.Players[ Pl ].Material = Material
		return
		
	end
	
	self.Players[ Pl ] = {
		Material = Material,
		Mesh = Mesh( Material ),
		Segments = { }
	}

end


function GM.Inventory.TrailManager:UnmanagePlayer( Pl )

	self.Players[ Pl ] = nil

end

function GM.Inventory.TrailManager:Think( )

	for Pl, Data in pairs( self.Players ) do
	
		local last_segment = data.Segments[ #data.Segments ]
		
		if ( Pl:GetPos():DistToSqr( last_segment ) > 1 ) then
		
			if ( #data.Segments >= 200 ) then
			
				table.remove( data.Segments, 1 )
			
			end
			
			table.insert( data.Segments, Pl:GetPos() )
		
		end
	
	end

end

function GM.Inventory.TrailManager:RebuildMesh( Pl )

	if ( not self.Players[ Pl ] ) then return end
	
	local lastpos
	local verts = { }

	for k, pos in ipairs( self.Players[ Pl ].Segments ) do
	
		if ( not lastpos ) then
		
			lastpos = pos
			continue
			
		end
	
		table.insert( verts, {
			lastpos,
			lastpos + Vector( 0, 0, 5 ),
			pos
		})
		
		table.insert( verts, {
			pos + Vector( 0, 0, 5 ),
			lastpos + Vector( 0, 0, 5 ),
			pos
		})
	
	end
	
	self.Players[ Pl ].Mesh:BuildFromTriangles( verts )

end

function GM.Inventory.TrailManager:Draw( Pl )

	if ( not self.Players[ Pl ] ) then return end

	render.SetMaterial( self.Players[ Pl ].Material )
	self.Players[ Pl ].Mesh:Draw()

end
