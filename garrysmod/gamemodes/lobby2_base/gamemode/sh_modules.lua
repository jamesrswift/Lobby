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

if ( SERVER ) then
	util.AddNetworkString( "lobby_loadmodule" )
end

function GM.Modules.LoadModule( name, conf )

	local GM = GM or gmod.GetGamemode();
	local ModuleDir = GM.Modules.ModulesFolder .. name .. "/"

	Module = {}
	
	local configuration = ( SERVER and GM.Modules.LoadConfiguration( ModuleDir, string.lower( name ) .. ".conf" ) ) or conf
	if ( configuration ) then
	
		Module.Configuration = configuration
		local r = GM.Modules.ManageConfiguration( ModuleDir, configuration )
		
		-- configuration prevented module from loading
		if ( r == false ) then
			GM:Print( "Module \'%s\' did not load due to configuration", name)
			return false
		end
		
	else
	
		GM:Print( "Module folder %s not found!", name)
		return
		
	end
	
	if ( Module.InitializeModule ) then
		Module:InitializeModule( SERVER )
	end

	if !GM.Modules.LoadedModules[ name ] then
		GM.Modules.LoadedModules[ name ] = Module
	end
	
	Module = nil
	
	if ( SERVER ) then
		GM:Print( "Module Loaded: %s", name)
	end
	
end

function GM.Modules.RunHook( Hook, ... )

	local GM = GM or gmod.GetGamemode( )
	local Return = { }

	for name, Module in pairs( GM.Modules.LoadedModules ) do
	
		if ( Module.Hooks and Module.Hooks[Hook] ) then
		
			Return = { Module[ Hook ]( Module, ... ) }
		
		end
	
	end
	
	return unpack( Return )

end

function GM.Modules.LoadConfiguration( path, name )

	local configuration = file.Read( path .. name, "LUA" )
	if ( configuration and string.len( configuration ) > 0 ) then
	
		if ( SERVER ) then
		
			resource.AddFile( "gamemodes/" .. path .. name )
			
		end
		
		return util.KeyValuesToTable( configuration )
	
	end

	(GM and GM or GAMEMODE):Print( "[module] Failed to load configuration for %s" , name )
	
	return false
	
end

function GM.Modules.ManageConfiguration( path, config )

	local GM = GM or gmod.GetGamemode()

	if ( config ) then
	
		-- Allow module to be disabled from the configuration
		if ( config.disable and config.disable == 1 ) then
			return false
		end
	
		-- Load modules required for this one to work
		if ( config.dependences ) then
			GM.Modules.ManageDependences( path, config )
		end
		
		-- Include the files
		if ( config.includes ) then
			GM.Modules.ManageFiles( path, config )
		end
		
		-- Send the resources
		if ( config.resources ) then
			GM.Modules.ManageResources( path, config )
		end
		
		return true
		
	end
	
	return false

end

function GM.Modules.ManageDependences( path, config )

	local _module = Module

	for key, dependency in pairs( config.dependences ) do
	
		if ( not GM.Modules.ModuleIsLoaded( dependency ) ) then
			GM.Modules.LoadModule( dependency )
		end
		
	end
	
	Module = _module
	
end

function GM.Modules.ManageFiles( path, config )

	for Filename, Realm in pairs( config.includes ) do
	
		if ( SERVER and string.lower( Realm ) == "server" ) then
		
			include( path .. Filename )
			
		elseif ( string.lower( Realm ) == "client" or string.lower( Realm ) == "shared" ) then
		
		
			if ( SERVER ) then
				AddCSLuaFile( path .. Filename )
			end
			
			if ( CLIENT or string.lower( Realm ) == "shared") then
				include ( path .. Filename )
			end
			
		end
		
	end

end

function GM.Modules.ManageResources( path, config )

	for key, resources in pairs( config.resources ) do
		resource.AddFile( resources )
	end

end

function GM:LoadModules( list )

	-- Only run on server, now that we send through net
	if ( CLIENT ) then return end

	self:Print( "Loading Modules ... " )
	
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

function GM.Modules.SendToClient( Pl )

	for name, Module in pairs( (GM or GAMEMODE).Modules.LoadedModules ) do
	
		net.Start( "lobby_loadmodule" )
			net.WriteString( name )
			net.WriteTable( Module.Configuration or {} )
		net.Send( Pl )
	
	end

end

if ( CLIENT ) then

	net.Receive( "lobby_loadmodule", function( len )
	
		local name = net.ReadString( )
		local conf = net.ReadTable( )
	
		GAMEMODE.Modules.LoadModule( name, conf )
	
	end)

end