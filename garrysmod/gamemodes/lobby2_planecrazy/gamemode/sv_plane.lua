--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, 2015
	
-----------------------------------------------------------]]--

function GM:BuildPlane( pl )

	self:AddPlanePart( pl, Vector( 0, 0, -10 ), Angle( 0, 0, 0 ), "models/maxofs2d/companion_doll.mdl", 0.75 )
	--self:AddPlanePart( pl, Vector( 0, 0, 0 ), Angle( 0, 0, 0 ), "models/props_fairgrounds/elephant.mdl" )
	--self:AddPlanePart( pl, Vector( 0, 0, 0 ), Angle( 0, 0, 0 ), "models/props_fairgrounds/giraffe.mdl" )
	
	self:AddPlanePart( pl, Vector( 0, 0, -7 ), Angle( 0, 92, 0 ), "models/props_junk/plasticcrate01a.mdl" )
	self:AddPlanePart( pl, Vector( 0, 19, -9 ), Angle( -1.682, 120.148, 10.0717 ), "models/props_c17/playground_swingset_seat01a.mdl" )
	self:AddPlanePart( pl, Vector( 0, -19, -9 ), Angle( -1.682, 70.648, 10.0717 ), "models/props_c17/playground_swingset_seat01a.mdl" )
	self:AddPlanePart( pl, Vector( 21, 0, -9 ), Angle( -90, 270 , -90 ), "models/props_junk/trafficcone001a.mdl" )
	self:AddPlanePart( pl, Vector( -18, -1, -7 ), Angle( -90, 90 + 180, -90 ), "models/props_lab/powerbox02d.mdl" )

end

function GM:AddPlanePart( pl, pos, ang, mdl, scale )
	
	scale = scale or 1
	pos = pos + Vector( 0, 0, -3 )
	
	local ent = ents.Create( "prop_dynamic" )

		ent:SetModel( mdl )
		ent:Spawn()
		
		ent:SetParent( pl )
		--ent:SetMoveType( MOVETYPE_NONE )
		ent:SetPos( pos )
		ent:SetAngles( ang )
		ent:SetModelScale( scale, 0 )
		
	pl.parts = pl.parts or {}
	table.insert( pl.parts, ent )
	
end

function GM:ExplodePlaneParts( pl )

	if ( !pl.parts ) then return end
	
	for k, v in pairs( pl.parts ) do
		
		if ( IsValid( v ) ) then
		
			v:SetParent( NULL )
			
			local ent = ents.Create( "prop_physics" )

			ent:SetModel( v:GetModel() )
			ent:SetPos( v:GetPos() )
			ent:SetAngles( v:GetAngles() )
			ent:Spawn()
			ent:Ignite( 60 )
			
			timer.Simple( math.random( 5, 10 ), function() 
					if ( IsValid( ent ) ) then 
						--local effectdata = EffectData()
						--effectdata:SetOrigin( ent:GetPos() )
						--util.Effect( "Explosion", effectdata, true, true )
						ent:Remove() 
					end 
				end )
			v:Remove()
		end
	end
	
	pl.parts = {}

end

