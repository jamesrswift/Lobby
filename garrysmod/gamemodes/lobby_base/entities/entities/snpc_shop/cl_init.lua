include('shared.lua')
 
ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Draw()
	self.Entity:DrawModel()
end

function ENT:DrawTranslucent()
 
	self:Draw()
 
end


function ENT:SetRagdollBones( bIn )

	self.m_bRagdollSetup = bIn
 
end