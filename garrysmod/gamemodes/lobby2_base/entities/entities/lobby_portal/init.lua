--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, 2015
	
-----------------------------------------------------------]]--

AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')
 
function ENT:Initialize()
	
	self:SetModel( "models/props_lab/blastdoor001b.mdl" )
	self:DrawShadow( false )
	
	if ( self.Target ) then
	
		local Ents = ents.FindByName( self.Target )
		
		timer.Simple( 0, function( )
			self:SetNWEntity( "eTarget", Ents[1] )
		
			self.TargetPortal = Ents[1]
		end)
	
	end
	
end

function ENT:GetTarget( )

	return self.TargetPortal
	
end
 
function ENT:KeyValue( key, value )

	print( key, value )

	if ( string.lower( key ) == "target" ) then
		self.Target = value
	end

end
