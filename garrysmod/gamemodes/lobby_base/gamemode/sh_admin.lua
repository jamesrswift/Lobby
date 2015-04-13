-- SH_Admin


AdminCommands = {}


function GM:AddAdminCommand( name, number_args, check, func, menu)
	AdminCommands[name] = {nargs = number_args, check = check, _func = func, menu=menu }
end

function GM:CallAdminCommand( name, args, ply )
	if (AdminCommands[name]) then
		if (AdminCommands[name].check(ply) && !hook.Call("DisableAdminCommand", self, name, ply)) then
			if (table.Count( args ) >= AdminCommands[name].nargs ) then
				if SERVER then
					AdminCommands[name]._func( args, ply )
				end
			end
		end
	end
end

function GM:DisableAdminCommand( Command, Player )
	return false
end

function GM:AdminCommand( Arguments, Player, Target )


end

local PlayerMeta = FindMetaTable("Player")

GM:AddAdminCommand( "addent", 1, PlayerMeta.IsPrivAdmin, function(args, ply)
	local EntName = args[1]
	local EntTable = scripted_ents.GetList()[ EntName ]
	
	if !EntTable || EntTable.t.Spawnable != true then
		return
	end
	
	if EntTable.t.SpawnFunction then
		local DropEnt = EntTable.t:SpawnFunction( ply, ply:GetEyeTrace() )
	end
end)

GM:AddAdminCommand( "rement", 0, PlayerMeta.IsPrivAdmin, function(args, ply)
	local Ent = ply:GetEyeTrace().Entity
	
	if IsValid( Ent ) && Ent:GetClass() != "player" && Ent:GetClass() != "func_brush" then
		Ent:Remove()		
	end
	
end)

GM:AddAdminCommand( "physgun", 0, PlayerMeta.IsPrivAdmin, function(args, ply)
	if !ply:HasWeapon("weapon_physgun") then
		ply:Give("weapon_physgun")
	end
end, {display="Give Physgun"})

GM:AddAdminCommand( "slay", 1, PlayerMeta.IsPrivAdmin, function(args, ply)
	local TargetPly = Entity( tonumber( args[1] ) )
	if TargetPly == nil then return end
	if !TargetPly:IsPlayer() then return end
	
	TargetPly:Kill()
end, {display="Slay", icon="icon16/cross.png"})

GM:AddAdminCommand( "slap", 1, PlayerMeta.IsPrivAdmin, function(args, ply)
	local TargetPly = Entity( tonumber( args[1] ) )
	if TargetPly == nil then return end
	if !TargetPly:IsPlayer() then return end
	
	TargetPly:TakeDamage( tonumber(args[2] or 5), ply, ply )
	
	if TargetPly:Alive() then
		 TargetPly:SetVelocity( VectorRand() * 2048 )
	end
end, {display="Slap", options={5,10,25,50,100}, icon="icon16/wand.png"})

GM:AddAdminCommand( "money", 1, PlayerMeta.IsAdmin, function(args, ply)
	local TargetPly = Entity( tonumber( args[1] ) )
	if TargetPly == nil then return end
	if !TargetPly:IsPlayer() then return end
	
	local Amount = tonumber( args[2] )
	if Amount == nil then Amount = 0 end
	
	TargetPly:SetMoney( Amount )
end, {display="Set Money", options={50,100,250,500,1000}, icon="icon16/coins.png"})


local items = {}
for k,v in pairs( LobbyItem.Items ) do
	if (string.sub( v.UniqueName, 1,1 ) != "_" ) then
		items[#items+1] = v.UniqueName
	end
end

GM:AddAdminCommand( "giveitem", 1, PlayerMeta.IsAdmin, function(args, ply)
	local TargetPly = Entity( tonumber( args[1] ) )
	if TargetPly == nil then return end
	if !TargetPly:IsPlayer() then return end
	
	local itemname = tostring( args[2] )
	if itemname then
		TargetPly:GiveItem( itemname )
	end
end, {display="Give Item", options=items, icon="icon16/map.png"})

if SERVER then

include( "Admin/noclip.lua" )
include( "Admin/alltalk.lua" )
include( "Admin/undercover.lua" )
include( "Admin/unfreeze.lua" )

LobbyCommand.AddCommand( "admin",function(ply,_,args)

	local name = args[1]
	for i=2, #args do args[i-1] = args[i] end
	args[#args] = nil

	GAMEMODE:CallAdminCommand( name, args, ply )
	hook.Call("AdminCommand", GAMEMODE, args, ply, TargetPly )

end )


else -- Client


function GM.CreateAdminMenu(_Player) -- Focused around a player
	if LocalPlayer():IsPrivAdmin() then
		
		local AMenu = DermaMenu();
		local a = AMenu:AddOption( "Administrate " .. _Player:Nick() )
		a:SetIcon("icon16/comment.png" )
		a:SetDisabled(true)
		AMenu:AddSpacer()
		
		
		for k,v in pairs( AdminCommands ) do
			if v.menu then
				if !(v.check(LocalPlayer())) then return end
				local o;
				
				local options = v.menu.options
				if type (options) == "function" then options = v.menu.options() end
				
				if options then
					o = AMenu:AddSubMenu( v.menu.display )
					for k2,v2 in pairs( options ) do
						local sm = o:AddOption( v2, function() RunConsoleCommand("lobby", "admin", k, _Player:EntIndex(), v2 ) end )
						--if v.menu.icon then
						--	sm:SetIcon( v.menu.icon )
						--end		
					end
				else
					o = AMenu:AddOption( v.menu.display, function() RunConsoleCommand("lobby", "admin", k, _Player:EntIndex() ) end )
				end
				if v.menu.icon then
					if options then o = o:GetParent() end
					o:SetIcon( v.menu.icon )
				end
			end
		end
		AMenu:Open()
	end

end


end