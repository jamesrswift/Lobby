--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, 2015
	
-----------------------------------------------------------]]--

GM.Modules = GM.Modules or {}
GM.Modules.LoadedModules = GM.Modules.LoadedModules or {}
GM.Modules.ModulesFolder = GM.Modules.ModulesFolder or "lobby2_base/gamemode/modules/"

function GM.Modules.LoadModule( name )

	local GM = GM or gmod.GetGamemode();

	local FileName = SERVER and "init.lua" or "cl_init.lua"	
	
	local ModuleDir = GM.Modules.ModulesFolder .. name .. "/"
	local ModuleFiles = file.Find( ModuleDir .. "*" , "LUA" )
	
	if table.Count( ModuleFiles ) == 0 then
		GM:Print( "Module folder %s not found!", name)
		return
	end
	
	Module = {}
	
	if table.HasValue( ModuleFiles, FileName ) then
		include( ModuleDir .. FileName )
	else
		GM:Print( "Could not find file to load in %s!", name)
		return
	end
	
	if !GM.Modules.LoadedModules[ name ] then
		GM.Modules.LoadedModules[ name ] = table.Copy( Module )
	end
	
	GM.Modules.ManageHooks( GM.Modules.LoadedModules[ name ] )
	
	Module = nil
	
	if ( SERVER ) then
		GM:Print( "Module Loaded: %s", name)
	end
end

function GM.Modules.ManageHooks( Module )

	if ( Module.Hooks ) then
		for k,v in pairs( Module.Hooks ) do
			hook.Add( v, "Modules:" .. name .. ":" .. v, function( ... ) Module[v](Module, ... ) end)
		end
	end

end

function GM:LoadModules( list )
	for _, name in pairs( list ) do
		self.Modules.LoadModule( name )
	end
end

function GM:GetModules( )
	return self.Modules.LoadedModules
end

function GM.Modules.ModuleIsLoaded( Name )
	return ( gmod.GetGamemode().Modules.LoadedModules[Name] != nil )
end
