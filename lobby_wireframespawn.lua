
if CLIENT then

	VarTable = { }

	net.Receive( "PlayerSpawn", function( )
		pl = net.ReadEntity()
		if pl and IsValid(pl) then	
			local PrevMins, PrevMaxs = pl:GetRenderBounds()
			VarTable[ pl ] = { true, 0 , PrevMaxs.z - PrevMins.z, pl:GetMaterial() }
			pl:SetMaterial( "models/wireframe" )
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
						pl:SetMaterial( VarTable[pl][4] )
						return
					end
				end
			end
		end
	end)
	
	hook.Add( "PrePlayerDraw", "WireframeSpawn", function( pl )
		if VarTable[pl] then
			if VarTable[pl][1] then
				--render.SetBlend(0)
			end
		end
	end)
	
	hook.Add( "PostPlayerDraw", "WireframeSpawn", function( pl )
		if VarTable[pl] then
			if VarTable[pl][1] then
				--render.SetBlend(1)
			end
		end
	end)
	
	local mat1 =  Material( "models/debug/debugwhite", "unlitgeneric" )

	hook.Add( "PostDrawOpaqueRenderables", "PostDrawing", function()

		for _, pl in pairs(player.GetAll()) do
			local pos = LocalPlayer():EyePos()+LocalPlayer():EyeAngles():Forward()*-10
			local ang = LocalPlayer():EyeAngles()
			ang = Angle(ang.p+90,ang.y,0)
			
			if VarTable[pl] then
				if VarTable[pl][1] then
					render.ClearStencil() --Clear stencil
					render.SetStencilEnable( true ) --Enable stencil
						
						render.SetStencilWriteMask(255)
						render.SetStencilTestMask(255)
						render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_NEVER )
						render.SetStencilFailOperation( STENCILOPERATION_REPLACE )
						render.SetStencilPassOperation( STENCILOPERATION_KEEP )
						render.SetStencilZFailOperation( STENCILOPERATION_KEEP )
						render.SetStencilReferenceValue(2)
						
						local normal = Vector( 0, 0, -1 );
						local distance = normal:Dot( pl:GetPos() + Vector( 0 , 0 , (VarTable[pl][2]/100) * VarTable[pl][3]) );
						
						render.SetBlend(0)
						alreadyClipping = render.EnableClipping( true );
						render.PushCustomClipPlane( normal, distance );
						pl:DrawModel()
						render.PopCustomClipPlane();
						render.EnableClipping( alreadyClipping );
						render.SetBlend(1)
							
						render.SetStencilReferenceValue( 2 ) --Reference value 1
						render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_LESSEQUAL ) --Only draw if pixel value == reference value
							
						--[[cam.Start3D2D(pos,ang,1)
							render.SetMaterial( mat1 )
							render.DrawScreenQuad()
						cam.End3D2D()--]]
						
						--cam.Start3D2D(pos, ang,1)
							pl:SetMaterial(VarTable[pl][4])
							pl:DrawModel()
							pl:SetMaterial("models/wireframe" )
						--cam.End3D2D()
						
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
