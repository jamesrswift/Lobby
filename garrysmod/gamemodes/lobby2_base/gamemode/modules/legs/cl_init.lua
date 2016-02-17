--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, 2015
	
-----------------------------------------------------------]]--


Module.LegEnt = nil
Module.PlaybackRate = 1
Module.Sequence = nil
Module.Velocity = 0
Module.OldWeapon = nil
Module.HoldType = nil

Module.BonesToRemove = {}
Module.BoneMatrix = nil

Module.BreathScale = 0.5
Module.NextBreath = 0

Module.RenderAngle = nil
Module.BiaisAngle = nil
Module.RadAngle = nil
Module.RenderPos = nil
Module.RenderColor = {}
Module.ClipVector = vector_up * -1
Module.ForwardOffset = -24

Module.BoneHoldTypes = {

	["none"] = {
		"ValveBiped.Bip01_Head1",
		"ValveBiped.Bip01_Neck1"
	},
	
	["default"] = {
		"ValveBiped.Bip01_Head1",
		"ValveBiped.Bip01_Neck1"
	},
	
	["vehicle"] = {
		"ValveBiped.Bip01_Head1",
		"ValveBiped.Bip01_Neck1"
	},
	
	["crouched"] = {
		"ValveBiped.Bip01_L_Hand",
		"ValveBiped.Bip01_L_Forearm",
		"ValveBiped.Bip01_L_Upperarm",
		"ValveBiped.Bip01_L_Clavicle",
		"ValveBiped.Bip01_R_Hand",
		"ValveBiped.Bip01_R_Forearm",
		"ValveBiped.Bip01_R_Upperarm",
		"ValveBiped.Bip01_R_Clavicle",
		"ValveBiped.Bip01_L_Finger4", "ValveBiped.Bip01_L_Finger41", "ValveBiped.Bip01_L_Finger42",
		"ValveBiped.Bip01_L_Finger3", "ValveBiped.Bip01_L_Finger31", "ValveBiped.Bip01_L_Finger32",
		"ValveBiped.Bip01_L_Finger2", "ValveBiped.Bip01_L_Finger21", "ValveBiped.Bip01_L_Finger22",
		"ValveBiped.Bip01_L_Finger1", "ValveBiped.Bip01_L_Finger11", "ValveBiped.Bip01_L_Finger12",
		"ValveBiped.Bip01_L_Finger0", "ValveBiped.Bip01_L_Finger01", "ValveBiped.Bip01_L_Finger02",
		"ValveBiped.Bip01_R_Finger4", "ValveBiped.Bip01_R_Finger41", "ValveBiped.Bip01_R_Finger42",
		"ValveBiped.Bip01_R_Finger3", "ValveBiped.Bip01_R_Finger31", "ValveBiped.Bip01_R_Finger32",
		"ValveBiped.Bip01_R_Finger2", "ValveBiped.Bip01_R_Finger21", "ValveBiped.Bip01_R_Finger22",
		"ValveBiped.Bip01_R_Finger1", "ValveBiped.Bip01_R_Finger11", "ValveBiped.Bip01_R_Finger12",
		"ValveBiped.Bip01_R_Finger0", "ValveBiped.Bip01_R_Finger01", "ValveBiped.Bip01_R_Finger02"
	}
	
}

function Module:ShouldDrawLegs( )
	return ( IsValid( self.LegEnt ) and ( LocalPlayer():Alive() ) and GetViewEntity() == LocalPlayer() and not LocalPlayer():ShouldDrawLocalPlayer() and not LocalPlayer():GetObserverTarget() )
end

function Module:GetPlayerLegs( ply )
	return ( ply and ply ~= LocalPlayer() and ply or ( self:ShouldDrawLegs() and self.LegEnt or LocalPlayer() ) )
end

function Module:SetUpLegs( )

	self.LegEnt = ClientsideModel( player_manager.TranslatePlayerModel( LocalPlayer():GetModel( ) ), RENDER_GROUP_OPAQUE_ENTITY )
	self.LegEnt:SetNoDraw( true )
	self.LegEnt.LastTick = 0
	
	self.LegEnt.GetPlayerColor = function( )
		return LocalPlayer( ):GetPlayerColor( )
	end

end

function Module:PlayerSwitchWeapon( Pl, old_weap, weap )

	if ( Pl ~= LocalPlayer() ) then return end

	if IsValid( self.LegEnt ) then
	
		if IsValid( weap ) then
			self.HoldType = weap:GetHoldType()
		else
			self.HoldType = "none"
		end

		for boneId = 0, self.LegEnt:GetBoneCount() do
			self.LegEnt:ManipulateBoneScale(boneId, Vector(1,1,1))
			self.LegEnt:ManipulateBonePosition(boneId, Vector(0,0,0))
		end

		self.BonesToRemove = {
			"ValveBiped.Bip01_Head1"
		}
		
		if ( not LocalPlayer():InVehicle() ) then
		
			self.BonesToRemove = self.BoneHoldTypes[ self.HoldType ] or self.BoneHoldTypes[ "default" ]

			if ( LocalPlayer():KeyDown( IN_DUCK ) ) then
				self.BonesToRemove = self.BoneHoldTypes[ "crouched" ]
			end

		else
		
			self.BonesToRemove = self.BoneHoldTypes[ "vehicle" ]
			
		end

		for _, v in pairs( self.BonesToRemove ) do
		
			local boneId = self.LegEnt:LookupBone(v)
			
			if boneId then
				self.LegEnt:ManipulateBoneScale(boneId, vector_origin)
				self.LegEnt:ManipulateBonePosition(boneId, Vector(-10,-10,0))
			end
			
		end
	end
	
end

function Module:UpdateAnimation( Pl, Velocity, maxseqgroundspeed )

	if ( Pl ~= LocalPlayer() ) then return end
	
	if ( not IsValid( self.LegEnt ) ) then
		self:SetUpLegs( )
	end

	if ( IsValid( self.LegEnt ) ) then
		
		if ( self.LegEnt:GetModel() ~= player_manager.TranslatePlayerModel( LocalPlayer():GetModel( ) ) ) then
			self.LegEnt:SetModel( player_manager.TranslatePlayerModel( LocalPlayer():GetModel( ) ) )
		end

		for boneId = 0, self.LegEnt:GetBoneCount() do
			self.LegEnt:ManipulateBoneScale(boneId, Vector(1,1,1))
			self.LegEnt:ManipulateBonePosition(boneId, Vector(0,0,0))
		end
		
		self.BonesToRemove = {
			"ValveBiped.Bip01_Head1"
		}
		
		if ( not LocalPlayer():InVehicle() ) then
			self.BonesToRemove = self.BoneHoldTypes[ self.HoldType ] or self.BoneHoldTypes[ "default" ]

			if LocalPlayer():KeyDown( IN_DUCK ) then
				self.BonesToRemove = self.BoneHoldTypes[ "crouched" ]
			end

		else
			self.BonesToRemove = self.BoneHoldTypes[ "vehicle" ]
		end
		

		for _, v in pairs( self.BonesToRemove ) do
		
			local boneId = self.LegEnt:LookupBone(v)
			
			if boneId then
				self.LegEnt:ManipulateBoneScale(boneId, vector_origin)
				self.LegEnt:ManipulateBonePosition(boneId, Vector(-10,-10,0))
			end
			
		end
		
		self.LegEnt:SetMaterial( LocalPlayer():GetMaterial() )
		self.LegEnt:SetSkin( LocalPlayer():GetSkin() )
		
		for _, group in pairs(LocalPlayer():GetBodyGroups()) do
			self.LegEnt:SetBodygroup(group["id"], LocalPlayer():GetBodygroup(group["id"]))
		end

		self.Velocity = LocalPlayer():GetVelocity():Length2D()
		
		self.PlaybackRate = 1

		if self.Velocity > 0.5 then
			if maxseqgroundspeed < 0.001 then
				self.PlaybackRate = 0.01
			else
				self.PlaybackRate = self.Velocity / maxseqgroundspeed
				self.PlaybackRate = math.Clamp( self.PlaybackRate, 0.01, 10 )
			end
		end
		
		self.LegEnt:SetPlaybackRate( self.PlaybackRate )
		
		self.Sequence = LocalPlayer():GetSequence()
		
		if ( self.LegEnt.Anim ~= self.Sequence ) then
			self.LegEnt.Anim = self.Sequence
			self.LegEnt:ResetSequence( self.Sequence )
		end
		
		self.LegEnt:FrameAdvance( CurTime() - self.LegEnt.LastTick )
		self.LegEnt.LastTick = CurTime()
		
		self.BreathScale = 0.5
		
		if self.NextBreath <= CurTime() then
			self.NextBreath = CurTime() + 1.95 / self.BreathScale
			self.LegEnt:SetPoseParameter( "breathing", self.BreathScale )
		end
		
		self.LegEnt:SetPoseParameter( "move_x", ( LocalPlayer():GetPoseParameter( "move_x" ) * 2 ) - 1 )
		self.LegEnt:SetPoseParameter( "move_y", ( LocalPlayer():GetPoseParameter( "move_y" ) * 2 ) - 1 )
		self.LegEnt:SetPoseParameter( "move_yaw", ( LocalPlayer():GetPoseParameter( "move_yaw" ) * 360 ) - 180 )
		self.LegEnt:SetPoseParameter( "body_yaw", ( LocalPlayer():GetPoseParameter( "body_yaw" ) * 180 ) - 90 )
		self.LegEnt:SetPoseParameter( "spine_yaw",( LocalPlayer():GetPoseParameter( "spine_yaw" ) * 180 ) - 90 )
		
		if ( LocalPlayer():InVehicle() ) then
			self.LegEnt:SetColor( color_transparent )
			self.LegEnt:SetRenderMode( RENDERMODE_TRANSALPHA )
			self.LegEnt:SetPoseParameter( "vehicle_steer", ( LocalPlayer():GetVehicle():GetPoseParameter( "vehicle_steer" ) * 2 ) - 1 )
		end
		
	end
	
end

function Module:RenderScreenspaceEffects( )

	if ( not self:ShouldDrawLegs() ) then return end

	cam.Start3D( EyePos(), EyeAngles() )
		
		self.RenderPos = LocalPlayer():GetPos()
		if LocalPlayer():InVehicle() then
		
			self.RenderAngle = LocalPlayer():GetVehicle():GetAngles()
			self.RenderAngle:RotateAroundAxis( self.RenderAngle:Up(), 90 )
			
		else
		
			self.BiaisAngles = LocalPlayer():EyeAngles()
			self.RenderAngle = Angle( 0, self.BiaisAngles.y, 0 )
			self.RadAngle = math.rad( self.BiaisAngles.y )
			self.ForwardOffset = -22
			self.RenderPos.x = self.RenderPos.x + math.cos( self.RadAngle ) * self.ForwardOffset
			self.RenderPos.y = self.RenderPos.y + math.sin( self.RadAngle ) * self.ForwardOffset
			
			if LocalPlayer():GetGroundEntity() == NULL then
				self.RenderPos.z = self.RenderPos.z + 8
				if LocalPlayer():KeyDown( IN_DUCK ) then
					self.RenderPos.z = self.RenderPos.z - 28
				end
			end
			
		end
		
		self.RenderColor = LocalPlayer():GetColor()
		
		local bEnabled = render.EnableClipping( true )
			render.PushCustomClipPlane( self.ClipVector, self.ClipVector:Dot( EyePos() ) )
				render.SetColorModulation( self.RenderColor.r / 255, self.RenderColor.g / 255, self.RenderColor.b / 255 )
					render.SetBlend( self.RenderColor.a / 255 )
					
						hook.Run( "PreLegsDraw", self.LegEnt )
							self.LegEnt:SetRenderOrigin( self.RenderPos )
							self.LegEnt:SetRenderAngles( self.RenderAngle )
							self.LegEnt:SetupBones()
							self.LegEnt:DrawModel()
							self.LegEnt:SetRenderOrigin()
							self.LegEnt:SetRenderAngles()
						hook.Run( "PostLegsDraw", self.LegEnt )
						
					render.SetBlend( 1 )
				render.SetColorModulation( 1, 1, 1 )
			render.PopCustomClipPlane()
		render.EnableClipping( bEnabled )
		
	cam.End3D()
	
end
