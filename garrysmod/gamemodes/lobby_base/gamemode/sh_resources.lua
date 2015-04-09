-- sh_resources.lua


GM.Precached			= {}
GM.Precached["Models"]	= {}
GM.Precached["Sounds"]	= {}

GM.DisallowedPModels	= {}

function AddResourceDirectory(Directory,Types)
	if !GM.AllowDownload then return end
	local files = file.Find(Directory.."/*", "GAME")
	for k,v in pairs(files) do
		local File = Directory.."/"..v
		if table.HasValue(Type, string.GetExtensionFromFilename(v)) then continue end
		if file.IsDir(GM.ContentPrefix.."/"..File) then
			AddResourceDirectory(File,Types)
		else
			resource.AddFile(File)
		end
	end
end

if (SERVER and GM.AllowDownload) then
	AddResourceDirectory("maps", {"bsp"})
	AddResourceDirectory("materials", {"vmt", "vtf", "png"})
	AddResourceDirectory("models", {"mdl", "vtx", "phy", "vvd"})
	AddResourceDirectory("particles", {"pcf"})
	AddResourceDirectory("sound", {"wav", "mp3"})
end

function LobbyPrecacheModel(Model)
	if !Model then return end
	if !util.IsValidModel(Model) then return end
	util.PrecacheModel(Model)
	GM.Precached["Models"][Model] = true
end

function LobbyPrecacheSound(Sound)
	if !Sound then return end
	util.PrecacheSound(Sound)
	GM.Precached["Sounds"][Sound] = true
end

function LobbyPrecacheModelTable(Table)
	for k,v in pairs(Table) do
		LobbyPrecacheModel(v)
	end
end

function LobbyPrecacheSoundTable(Table)
	for k,v in pairs(Table) do
		LobbyPrecacheSound(v)
	end
end

function DisAllowPModel(Model)
	GM.DisallowedPModels[Model] = true
end

DisAllowPModel("american_assault")
DisAllowPModel("german_assault")
DisAllowPModel("scientist")
DisAllowPModel("gina")
DisAllowPModel("magnusson")

function DisAllowPModels2()
	local PlayerModels = player_manager.AllValidModels()
	for k,v in pairs(PlayerModels) do
		if GM.DisallowedPModels[k] == true then
			v = nil
		end
	end
	LobbyPrecacheModelTable(PlayerModels)	
end

HumanGibs = {
	"models/gibs/antlion_gib_medium_2.mdl",
	"models/gibs/Antlion_gib_Large_1.mdl",
	"models/gibs/Strider_Gib4.mdl",
	"models/gibs/HGIBS.mdl",
	"models/gibs/HGIBS_rib.mdl",
	"models/gibs/HGIBS_scapula.mdl",
	"models/gibs/HGIBS_spine.mdl"
}

LobbyPrecacheModelTable(HumanGibs)