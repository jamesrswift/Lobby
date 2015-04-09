AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include('shared.lua')
include('spawn.lua')

function ENT:Use( activator, caller )

end


function ENT:Initialize()
    self.Entity:PhysicsInit( SOLID_VPHYSICS )
    self.Entity:SetMoveType( MOVETYPE_NONE )
    self.Entity:SetSolid( SOLID_VPHYSICS )
    local phys = self:GetPhysicsObject()

    if (phys:IsValid()) then
        phys:EnableGravity(true)
        phys:SetMass(30)
        phys:Wake()
    end
    self.Entity:SetColor(255, 255, 255, 255)
    self:SetNotSolid(true)
end

function ENT:Think()
    self.BaseClass.Think(self)
    self.Entity:NextThink(CurTime()+0.04)
    return true
end
