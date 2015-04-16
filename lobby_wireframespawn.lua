
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
	local dont = false
	
	hook.Add( "Think", "WireframeSpawn", function()
		for k,pl in pairs( player.GetAll() ) do
			if VarTable[pl] then
				if VarTable[pl][1] then
					VarTable[pl][2] = math.Clamp( VarTable[pl][2] + ( 40 * FrameTime() ), 0 , 100 )
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
				if not dont then
				local normal = Vector( 0, 0, 1 );
						local distance = normal:Dot( pl:GetPos() + Vector( 0 , 0 , (VarTable[pl][2]/100) * VarTable[pl][3]) );
						
						alreadyClipping = render.EnableClipping( true );
						render.PushCustomClipPlane( normal, distance );
				end
			end
		end
	end)
	
	hook.Add( "PostPlayerDraw", "WireframeSpawn", function( pl )
		if VarTable[pl] then
			if VarTable[pl][1] then
				--render.SetBlend(1)
				if not dont then
				render.PopCustomClipPlane();
						render.EnableClipping( alreadyClipping );
				end
			end
		end
	end)

	hook.Add( "PostDrawOpaqueRenderables", "PostDrawing", function()

		for _, pl in pairs(player.GetAll()) do
			local pos = LocalPlayer():EyePos()+LocalPlayer():EyeAngles():Forward()*-10
			local ang = LocalPlayer():EyeAngles()
			ang = Angle(ang.p+90,ang.y,0)
			
			if VarTable[pl] then
				if VarTable[pl][1] then
						
					local normal = Vector( 0, 0, -1 );
					local distance = normal:Dot( pl:GetPos() + Vector( 0 , 0 , (VarTable[pl][2]/100) * VarTable[pl][3]) );
					
					alreadyClipping = render.EnableClipping( true );
					render.PushCustomClipPlane( normal, distance );
					dont = true
					pl:SetMaterial(VarTable[pl][4])
					pl:DrawModel()
					pl:SetMaterial("models/wireframe" )
					dont = false
					render.PopCustomClipPlane();
					render.EnableClipping( alreadyClipping );
					
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
