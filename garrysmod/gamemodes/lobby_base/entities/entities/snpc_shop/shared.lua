

ENT.Base = "base_anim" 
ENT.Type = "anim"
 
ENT.PrintName		= ""
ENT.Author			= ""
ENT.Contact			= ""  //fill in these if you want it to be in the spawn menu
ENT.Purpose			= ""
ENT.Instructions	= ""
 
ENT.AutomaticFrameAdvance = true
 
 
function ENT:SetAutomaticFrameAdvance( bUsingAnim )
 
	self.AutomaticFrameAdvance = bUsingAnim
 
end
 