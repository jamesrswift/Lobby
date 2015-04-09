--[[module("LobbyModules", package.seeall )]]--

LobbyModules = {}
LobbyModules.LoadedModules = {}
LobbyModules.ModulesFolder = "Lobby_Base/gamemode/modules/"

function LobbyModules.LoadModule( name )

	local FileName = SERVER && "init.lua" || "cl_init.lua"	
	
	local ModuleDir = LobbyModules.ModulesFolder .. name .. "/"
	local ModuleFiles = file.Find( ModuleDir .. "*" , "LUA" )
	
	if table.Count( ModuleFiles ) == 0 then
		ErrorNoHalt( "Module folder: " .. name .. " not found!\n")
		return
	end
	
	if table.HasValue( ModuleFiles, FileName ) then
		include( ModuleDir .. FileName )
	else
		ErrorNoHalt( "Could not find file to load in " .. name .. "!\n")
		return
	end
	
	if !table.HasValue( LobbyModules.LoadedModules, name ) then
		table.insert( LobbyModules.LoadedModules, name )
	end
	
	if ( SERVER ) then Msg( "Module Loaded: " .. name .. "\n" ) end
end

function LobbyModules.LoadModules( list )
	for _, name in pairs( list ) do
		LobbyModules.LoadModule( name )
	end
end


function LobbyModules.ModuleIsLoaded( Name )
	return ( LobbyModules.LoadedModules[Name] != nil )
end