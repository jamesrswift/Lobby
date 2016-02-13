--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, 2015
	
-----------------------------------------------------------]]--

function GM:AddPlanePart( pl, pos, ang, mdl )
	
	pos = pos + Vector( 0, 0, -3 )
	
	local ent = ents.Create( "prop_dynamic" )

		ent:SetModel( mdl )
		ent:Spawn()
		
		ent:SetParent( pl )
		ent:SetPos( pos )
		ent:SetAngles( ang )
		
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

