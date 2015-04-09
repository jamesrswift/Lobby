include( "shared.lua" )

local function Positive( X )

	return ( (X>0) and X or ( X*-1 ) )

end

function ENT:UpdateTranslate( )

	self.text = T( self.Entity:GetNWString( "Text" ) )

end

function ENT:Initialize()
	
	self:UpdateTranslate( )
	
end

function ENT:Draw()

        self.Entity:SetRenderBounds( Vector(-1000,-1000,-1000), Vector(1000,1000,1000) )

        local pos = self.Entity:GetPos() + Vector( 0 , 0 , Positive(math.cos(CurTime()*2)*15) )  // Removed because it was shit
        local ang = self.Entity:GetAngles() + Angle(0,90,90)

        cam.Start3D2D(pos, ang, 0.75)
			draw.SimpleTextOutlined(self.text, "Trebuchet24", 0, 0, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,255))
        cam.End3D2D()


        return true
end

function ENT:Think()
        return true
end

function ENT:OnRemove()

end
