--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, 2015
	
-----------------------------------------------------------]]--

ITEM.ShopID 		= 0

ITEM.Name 			= "Playermodel Base"
ITEM.UniqueName 	= "_playermodelbase"
ITEM.Description 	= "Item base for playermodels"
ITEM.Price			= 200

ITEM.Player			= false
ITEM.Model 			= "models/player/alyx.mdl"
ITEM.Hands			= {}
ITEM.BodyGroups		= {}
ITEM.Skin			= 0

function ITEM:Init( )

	local GM = GM or gmod.GetGamemode( )
	GM.BannedPlayerModels[ self.Model ] = true

	player_manager.AddValidModel( string.lower(self.Name), self.Model )
	if #self.Hands > 0 then
		player_manager.AddValidHands( string.lower(self.Name), unpack(self.Hands) )
	end
	
end

function ITEM:OnEquip( Pl )

	self.Equiped = true
	self.Player = Pl
	
	_Player:SetModel( self.Model )
	self:UpdateBodyGroups( Pl )
	self:UpdateSkin( Pl )
	
	if ( Pl:GetData().model ~= self.Name ) then
		Pl:GetData().model = self.Name
		Pl:SaveData()
	end
	
end

function ITEM:UpdateBodyGroups( Pl )

	if self.Equiped then
	
		for k,v in pairs(self.BodyGroups) do
		
			Pl:SetBodygroup( v[1], v[2] )
			
		end
		
	end
	
end

function ITEM:UpdateSkin( Pl )

	if self.Equiped then
	
		Pl:SetSkin( self.Skin )
		
	end
	
end

function ITEM:PlayerSetModelPost( Pl, model, skin )

	if self.Player == Pl then
	
		Pl:SetModel( self.Model )
		self:UpdateBodyGroups()
		self:UpdateSkin()
		
	end
	
end

function ITEM:OnHolister( _Player )

	self.Equiped = false
	
end