
include( "hateditor_modelviewer.lua" )

function OpenHatEditor()
	local dFrame = vgui.Create("DFrame")
	dFrame:SetPos( 100, 100 )
	dFrame:SetSize( 1000, 600)
	dFrame:SetTitle( "Hat Editor" )
	dFrame:SetDraggable( true )
	dFrame:MakePopup()
	dFrame:Center()

	local ModelList = vgui.Create( "DTree", dFrame )
	ModelList:SetSize( 200, 600 )
	ModelList:Dock( LEFT )
	ModelList:DockMargin( 5,5,5,5 )
	
	-- controls
	
	local controls = vgui.Create( "DPanel", dFrame )
	controls:SetSize( 300, 600 )
	controls:Dock( RIGHT )
	controls:DockMargin( 5,5,5,5 )
	
	local hatchooser = vgui.Create( "DComboBox", controls )
	hatchooser:SetSize( 300, 20 )
	hatchooser:Dock( TOP )
	hatchooser:DockMargin( 5,5,5,5 )
	hatchooser:SetValue( "hats" )
	
	
	-- Vector Sliders
	
	local VectorXSlider = vgui.Create( "DNumberScratch", controls )	
	VectorXSlider:SetSize( 300, 20 )	
	VectorXSlider:SetText( "Vector X" )
	VectorXSlider:SetMin( -50 )
	VectorXSlider:SetMax( 50 )
	VectorXSlider:SetDecimals( 5 )
	VectorXSlider:Dock( TOP )
	VectorXSlider:DockMargin( 5,5,5,5 )
	VectorXSlider:SetValue( 0 )
	
	local VectorYSlider = vgui.Create( "DNumberScratch", controls )	
	VectorYSlider:SetSize( 300, 20 )	
	VectorYSlider:SetText( "Vector Y" )
	VectorYSlider:SetMin( -50 )
	VectorYSlider:SetMax( 50 )
	VectorYSlider:SetDecimals( 5 )
	VectorYSlider:Dock( TOP )
	VectorYSlider:DockMargin( 5,5,5,5 )
	VectorYSlider:SetValue( 0 )
	
	local VectorZSlider = vgui.Create( "DNumberScratch", controls )	
	VectorZSlider:SetSize( 300, 20 )	
	VectorZSlider:SetText( "Vector Z" )
	VectorZSlider:SetMin( -50 )
	VectorZSlider:SetMax( 50 )
	VectorZSlider:SetDecimals( 5 )
	VectorZSlider:Dock( TOP )
	VectorZSlider:DockMargin( 5,5,5,5 )
	VectorZSlider:SetValue( 0 )
	
	local AnglePSlider = vgui.Create( "DNumberScratch", controls )	
	AnglePSlider:SetSize( 300, 20 )	
	AnglePSlider:SetText( "Angle Pitch" )
	AnglePSlider:SetMin( -180 )
	AnglePSlider:SetMax( 180 )
	AnglePSlider:SetDecimals( 5 )
	AnglePSlider:Dock( TOP )
	AnglePSlider:DockMargin( 5,5,5,5 )
	AnglePSlider:SetValue( 0 )
	
	local AngleYSlider = vgui.Create( "DNumberScratch", controls )	
	AngleYSlider:SetSize( 300, 20 )	
	AngleYSlider:SetText( "Angle Yaw" )
	AngleYSlider:SetMin( -180 )
	AngleYSlider:SetMax( 180 )
	AngleYSlider:SetDecimals( 5 )
	AngleYSlider:Dock( TOP )
	AngleYSlider:DockMargin( 5,5,5,5 )
	AngleYSlider:SetValue( 0 )
	
	local AngleRSlider = vgui.Create( "DNumberScratch", controls )	
	AngleRSlider:SetSize( 300, 20 )	
	AngleRSlider:SetText( "Angle Roll" )
	AngleRSlider:SetMin( -180 )
	AngleRSlider:SetMax( 180 )
	AngleRSlider:SetDecimals( 5 )
	AngleRSlider:Dock( TOP )
	AngleRSlider:DockMargin( 5,5,5,5 )
	AngleRSlider:SetValue( 0 )
	
	local ScaleSlider = vgui.Create( "DNumberScratch", controls )	
	ScaleSlider:SetSize( 300, 20 )	
	ScaleSlider:SetText( "Scale" )
	ScaleSlider:SetMin( 0 )
	ScaleSlider:SetMax( 5 )
	ScaleSlider:SetDecimals( 2 )
	ScaleSlider:Dock( TOP )
	ScaleSlider:DockMargin( 5,5,5,5 )
	ScaleSlider:SetValue( 0 )
	
	local OutputButton = vgui.Create( "DButton", controls )	
	OutputButton:SetSize( 300, 40 )	
	OutputButton:SetText( "Print values in console" )
	OutputButton:Dock( TOP )
	OutputButton:DockMargin( 5,5,5,5 )
	
	-- hateditor_modelviewer
	
	local hateditor_modelviewer = vgui.Create( "lobby.HatEditor.ModelViewer", dFrame )
	hateditor_modelviewer:Dock( FILL )
	hateditor_modelviewer:DockMargin( 5,5,5,5 )
	
	local models = {}
	local hats = {}
	
	
	models["Default"] = {"models/player/kleiner.mdl"}
	ModelList:AddNode( "Default" )
	-- Build List
	for k,v in pairs( LobbyItem.Items ) do
		if v.Base == "_playermodelbase" then
			ModelList:AddNode( v.Name )
			models[v.Name] = { v.Model, v.BodyGroups }
		elseif v.Base == "_hatbase" then
			hatchooser:AddChoice( v.Name )
			hats[v.Name] = { v.Model, v.Offset}
		end
	end
	
	-- methods
	
	VectorXSlider.OnValueChanged = function(selfs)
		local value = selfs:GetFloatValue()
		local v = hateditor_modelviewer:GetOffsetVector()
		v.x = value
		hateditor_modelviewer:SetOffsetVector(v)
	end
	
	VectorYSlider.OnValueChanged = function(selfs)
		local value = selfs:GetFloatValue()
		local v = hateditor_modelviewer:GetOffsetVector()
		v.y = value
		hateditor_modelviewer:SetOffsetVector(v)
	end
	
	VectorZSlider.OnValueChanged = function(selfs)
		local value = selfs:GetFloatValue()
		local v = hateditor_modelviewer:GetOffsetVector()
		v.z = value
		hateditor_modelviewer:SetOffsetVector(v)
	end
	
	AnglePSlider.OnValueChanged = function(selfs)
		local value = selfs:GetFloatValue()
		local v = hateditor_modelviewer:GetOffsetAngle()
		v.p = value
		hateditor_modelviewer:SetOffsetAngle(v)
	end
	
	AngleYSlider.OnValueChanged = function(selfs)
		local value = selfs:GetFloatValue()
		local v = hateditor_modelviewer:GetOffsetAngle()
		v.y = value
		hateditor_modelviewer:SetOffsetAngle(v)
	end
	
	AngleRSlider.OnValueChanged = function(selfs)
		local value = selfs:GetFloatValue()
		local v = hateditor_modelviewer:GetOffsetAngle()
		v.r = value
		hateditor_modelviewer:SetOffsetAngle(v)
	end
	
	ScaleSlider.OnValueChanged = function(selfs)
		local value = selfs:GetFloatValue()
		hateditor_modelviewer:SetHatScale(value)
	end
	
	ModelList.OnNodeSelected = function(self)
		local item = self:GetSelectedItem()
		local model = item:GetText()
		hateditor_modelviewer:SetModel( models[model][1] )
		if models[model][2] then
			for k,v in pairs( models[model][2] ) do
				hateditor_modelviewer.Entity:SetBodygroup( unpack(v) )
			end
		end
		
		local value = false
		for k,v in pairs( hats ) do if v[1] == hateditor_modelviewer:GetHatModel() then value = k end end
		if value then
			if hats[value][2][hateditor_modelviewer:GetModel()] then
				hateditor_modelviewer:SetHatModel( hats[value][hateditor_modelviewer:GetModel()] )
				hateditor_modelviewer:SetOffsetVector( hats[value][2][hateditor_modelviewer:GetModel()].Vector )
				hateditor_modelviewer:SetOffsetAngle( hats[value][2][hateditor_modelviewer:GetModel()].Angle )
				hateditor_modelviewer:SetHatScale( hats[value][2][hateditor_modelviewer:GetModel()].Scale )
				
				VectorXSlider:SetFloatValue( hats[value][2][hateditor_modelviewer:GetModel()].Vector.x )
				VectorYSlider:SetFloatValue( hats[value][2][hateditor_modelviewer:GetModel()].Vector.y )
				VectorZSlider:SetFloatValue( hats[value][2][hateditor_modelviewer:GetModel()].Vector.z )
				
				AnglePSlider:SetFloatValue( hats[value][2][hateditor_modelviewer:GetModel()].Angle.p )
				AngleYSlider:SetFloatValue( hats[value][2][hateditor_modelviewer:GetModel()].Angle.y )
				AngleRSlider:SetFloatValue( hats[value][2][hateditor_modelviewer:GetModel()].Angle.r )
				
				ScaleSlider:SetFloatValue( hats[value][2][hateditor_modelviewer:GetModel()].Scale )
			end
		else
			hateditor_modelviewer:SetHatModel( hats[value][1] )
			hateditor_modelviewer:SetOffsetVector( hats[value][2][1].Vector )
			hateditor_modelviewer:SetOffsetAngle( hats[value][2][1].Angle )
			hateditor_modelviewer:SetHatScale( hats[value][2][1].Scale )
			
			VectorXSlider:SetFloatValue( hats[value][2][1].Vector.x )
			VectorYSlider:SetFloatValue( hats[value][2][1].Vector.y )
			VectorZSlider:SetFloatValue( hats[value][2][1].Vector.z )
			
			AnglePSlider:SetFloatValue( hats[value][2][1].Angle.p )
			AngleYSlider:SetFloatValue( hats[value][2][1].Angle.y )
			AngleRSlider:SetFloatValue( hats[value][2][1].Angle.r )
			
			ScaleSlider:SetFloatValue( hats[value][2][1].Scale )
		end
	end
	
	hatchooser.OnSelect = function( panel, index, value )
		if hats[value][2][hateditor_modelviewer:GetModel()] then
			hateditor_modelviewer:SetHatModel( hats[value][hateditor_modelviewer:GetModel()] )
			hateditor_modelviewer:SetOffsetVector( hats[value][2][hateditor_modelviewer:GetModel()].Vector )
			hateditor_modelviewer:SetOffsetAngle( hats[value][2][hateditor_modelviewer:GetModel()].Angle )
			hateditor_modelviewer:SetHatScale( hats[value][2][hateditor_modelviewer:GetModel()].Scale )
			
			local value = false
			for k,v in pairs( hats ) do if v[1] == hateditor_modelviewer:GetHatModel() then value = k end end
			if value then
				VectorXSlider:SetFloatValue( hats[value][2][hateditor_modelviewer:GetModel()].Vector.x )
				VectorYSlider:SetFloatValue( hats[value][2][hateditor_modelviewer:GetModel()].Vector.y )
				VectorZSlider:SetFloatValue( hats[value][2][hateditor_modelviewer:GetModel()].Vector.z )
				
				AnglePSlider:SetFloatValue( hats[value][2][hateditor_modelviewer:GetModel()].Angle.p )
				AngleYSlider:SetFloatValue( hats[value][2][hateditor_modelviewer:GetModel()].Angle.y )
				AngleRSlider:SetFloatValue( hats[value][2][hateditor_modelviewer:GetModel()].Angle.r )
				
				ScaleSlider:SetFloatValue( hats[value][2][hateditor_modelviewer:GetModel()].Scale )
			end
		else
			hateditor_modelviewer:SetHatModel( hats[value][1] )
			hateditor_modelviewer:SetOffsetVector( hats[value][2][1].Vector )
			hateditor_modelviewer:SetOffsetAngle( hats[value][2][1].Angle )
			hateditor_modelviewer:SetHatScale( hats[value][2][1].Scale )
			
			VectorXSlider:SetFloatValue( hats[value][2][1].Vector.x )
			VectorYSlider:SetFloatValue( hats[value][2][1].Vector.y )
			VectorZSlider:SetFloatValue( hats[value][2][1].Vector.z )
			
			AnglePSlider:SetFloatValue( hats[value][2][1].Angle.p )
			AngleYSlider:SetFloatValue( hats[value][2][1].Angle.y )
			AngleRSlider:SetFloatValue( hats[value][2][1].Angle.r )
			
			ScaleSlider:SetFloatValue( hats[value][2][1].Scale )
		end
	end
	
	OutputButton.OnPressed = function() hateditor_modelviewer:Output() end
	
	
	hateditor_modelviewer:SetModel( "models/player/alyx.mdl" )
	hateditor_modelviewer:SetHatModel( "models/props_2fort/hardhat001.mdl" )
	hateditor_modelviewer:SetOffsetVector( Vector( 3.5,0,0 ) )
	hateditor_modelviewer:SetOffsetAngle( Angle(90,0,-90) )
	hateditor_modelviewer:SetHatScale( 0.65 )

end

concommand.Add( "lobby_hateditor", OpenHatEditor )