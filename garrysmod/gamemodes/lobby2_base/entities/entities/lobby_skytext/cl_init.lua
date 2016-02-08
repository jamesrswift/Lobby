--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, 2015
	
-----------------------------------------------------------]]--

include( "shared.lua" )

function ENT:GetDrawText( )

	return self:GetNWString( "DisplayText", "<No Display Text>" )

end

function ENT:GetDrawTextSize( )

	return self:GetNWFloat( "DisplaySize", 1 )

end

function ENT:GetDrawTextStatic( )

	return self:GetNWBool( "DisplayStatic", true )

end


function ENT:DrawText( pos, ang )
	
	cam.Start3D2D(pos, ang, (0.75/4) * self:GetDrawTextSize( ) )
		draw.SimpleTextOutlined(self:GetDrawText( ), "LobbySkyText", 0, 0, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,255))
	cam.End3D2D()

end

function ENT:Draw()

	self:SetRenderBounds( Vector(-1000,-1000,-1000),  Vector(1000,1000,1000) )
	
	local pos = self:GetPos()
	if ( not self:GetDrawTextStatic( ) ) then
		pos = self:GetPos() + Vector( 0 , 0 , math.abs(math.cos(CurTime()*2)*15) )
	end
	
	local ang = self:GetAngles() + Angle(0,90,90)
	
	self:DrawText( pos, ang )
	self:DrawText( pos, ang + Angle( 0, 180, 0) )
	
	return true
	
end
