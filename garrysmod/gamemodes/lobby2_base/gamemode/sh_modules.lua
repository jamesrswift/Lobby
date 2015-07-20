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
	
	local ModuleDir = GM.Modules.ModulesFolder .. name .. "/"
	local ModuleFiles = file.Find( ModuleDir .. "*" , "LUA" )
	
	if table.Count( ModuleFiles ) == 0 then
		GM:Print( "Module folder %s not found!", name)
		return
	end
	
	Module = {}
	
	local configuration = GM.Modules.LoadConfiguration( ModuleDir, string.lower( name ) .. ".dat" )
	if ( configuration ) then
		GM.Modules.ManageConfiguration( ModuleDir, configuration )
	end

	if !GM.Modules.LoadedModules[ name ] then
		GM.Modules.LoadedModules[ name ] = Module
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

function GM.Modules.LoadConfiguration( path, name )

	local configuration = file.Read( path .. name, "LUA" )
	if ( configuration and string.len( configuration ) > 0 ) then
	
		resource.AddFile( "gamemodes/" .. path .. name )
		return util.KeyValuesToTable( configuration )
	
	end

	(GM and GM or GAMEMODE):Print( "[module] Failed to load configuration for %s" , name )
	
	return false
	
end

function GM.Modules.ManageConfiguration( path, config )

	if ( config ) then
		if ( config.includes ) then
			
			for Filename, Realm in ipairs( config.includes ) do
				if ( SERVER and string.lower( Realm ) == "server" ) then
					include( path .. Filename )
				elseif ( SERVER and ( string.lower( Realm ) == "client" or string.lower( Realm ) == "shared" ) ) then
					AddCSLuaFile( path .. Filename )
					if ( string.lower( Realm ) == "Shared" ) then
						include ( path .. Filename )
					end
				elseif ( CLIENT and ( string.lower( Realm ) == "client" or string.lower( Realm ) == "shared" ) ) then
					include( path .. Filename )
				end
			end
			
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
