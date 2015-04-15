
if CLIENT then

	VarTable = { }

	net.Receive( "PlayerSpawn", function( )
		pl = net.ReadEntity()
		if pl and IsValid(pl) then	
			local PrevMins, PrevMaxs = pl:GetRenderBounds()
			VarTable[ pl ] = { true, 0 , PrevMaxs.z - PrevMins.z }
		else
			print( "Invalid player!", pl )
		end
	end)
	
	local alreadyClipping
	
	hook.Add( "Think", "WireframeSpawn", function()
		for k,pl in pairs( player.GetAll() ) do
			if VarTable[pl] then
				if VarTable[pl][1] then
					VarTable[pl][2] = math.Clamp( VarTable[pl][2] + ( 70 * FrameTime() ), 0 , 100 )
					if VarTable[pl][2]  == 100 then
						VarTable[pl][1] = false
						return
					end
				end
			end
		end
	end)
	
	hook.Add( "PrePlayerDraw", "WireframeSpawn", function( pl )
		if VarTable[pl] then
		
			if VarTable[pl][1] then
				
				local normal = Vector( 0, 0, -1 );
				local distance = normal:Dot( pl:GetPos() + Vector( 0 , 0 , (VarTable[pl][2]/100) * VarTable[pl][3]) );
				 
				alreadyClipping = render.EnableClipping( true );
				render.PushCustomClipPlane( normal, distance );
				
			end
			
		end
	
	end)
	
	hook.Add( "PostPlayerDraw", "WireframeSpawn", function( pl )
		if VarTable[pl] then
			if VarTable[pl][1] then
				render.PopCustomClipPlane();
				render.EnableClipping( alreadyClipping );
				
			end
		end
	end)
	
	local mat1 =  Material( "models/debug/debugwhite", "unlitgeneric" )

	hook.Add( "PostDrawOpaqueRenderables", "PostDrawing", function()

		for _, pl in pairs(player.GetAll()) do
			if VarTable[pl] then
				if VarTable[pl][1] then
					render.ClearStencil() --Clear stencil
					render.SetStencilEnable( true ) --Enable stencil
					
					render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_NEVER ) --We don't actually draw the weapon, we just want it on our stencil
					render.SetStencilFailOperation( STENCILOPERATION_INCR ) --If we fail, do nothing
					render.SetStencilPassOperation( STENCILOPERATION_KEEP ) --If we pass (we see it) increase the pixels value by 1
					render.SetStencilZFailOperation( STENCILOPERATION_KEEP ) --If it's behind something, dont do anything

					pl:DrawModel()
						
					render.SetStencilReferenceValue( 1 ) --Reference value 1
					render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_LESSEQUAL ) --Only draw if pixel value == reference value
						
					render.SetMaterial( mat1 )
					render.DrawScreenQuad() --Draw over whole screen (the pixels outside the players weapons won't be rendered anyways.
					
					render.ClearStencil()
					render.SetStencilEnable( false )
				end
			end
		end
	end)

else

	util.AddNetworkString( "PlayerSpawn" )

	hook.Add( "PlayerSpawn", "WireframeSpawn", function( pl )
		timer.Simple( 0.1, function()
			net.Start( "PlayerSpawn" )
			net.WriteEntity( pl )
			net.Broadcast()
		end)
	end)
end
