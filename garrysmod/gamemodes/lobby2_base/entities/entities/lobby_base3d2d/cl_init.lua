--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, 2015
	
-----------------------------------------------------------]]--

include('shared.lua')

function ENT:Initialize( )

	self:DrawShadow( false )
	
	self.Panel = MeshPanel.New( self:GetPos( ), self:GetAngles( ), self.Scale, self.PrintName .. self:EntIndex( ) )
	self.Panel:SetEnableCursor( self.Cursor or false )
	self.Panel:SetWidth( self.Width or 100 )
	self.Panel:SetHeight( self.Height or 100 )

	self.Panel:SetUpdate( function( cursorx, cursory )
		self:RenderScreen( cursorx, cursory )
	end)
	
	local mins = Vector( self:GetPos( ).x + self.Width * self.Scale, 0, self:GetPos( ).z - self.Height * self.Scale )
	mins:Rotate( self:GetAngles() )
	
	self:SetRenderBounds( self:GetPos( ), mins )


end

function ENT:RenderScreen( cursorx, cursory )

	-- For override

	draw.RoundedBox( 0, 0, 0, self.Width, self.Height, Color( 255, 0, 0 ) )
	
	surface.SetFont("Trebuchet24")
	surface.SetTextColor(255, 255, 255, 255)
	surface.SetTextPos(20, 20)
	surface.DrawText("Override ENT:RenderScreen please!")

	if ( cursorx and cursory ) then

		draw.RoundedBox( 2, cursorx-10, cursory-10, 20, 20, Color( 255, 255, 255 ) )

	end

end

function ENT:Think( )

end
 
function ENT:Draw()

	if ( self.Panel ) then

		self.Panel:Draw( )
		
	end

end
