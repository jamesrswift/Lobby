Language = {}
Lang = 1

local LangTable = {}
local LangNames = {}


function Language.AddLang(id, Fullname)
    
    LangTable[id] = {}
    
    LangNames[id] = FullName

end


function Language.AddWord(id, key, word)
    
    LangTable[id][ key ] = word

end


function GetTranslation(name, ...)

    local str = LangTable[ Lang ][ name ]
    
    if str == nil then
        str = LangTable[ 1 ][ name ] // look for english
        
        if str == nil then
			
            Msg("Error: Translation of '".. name .."' not  found!")
            return ""
            
        end
    end
	
	local arg = {...}
    
    if #arg > 0 then
		
		str = string.gsub( str, "{(%d+)}", 
			function(s) return arg[ tonumber(s) ] or "{"..s.."}" end
		)
		
    end    
    
    return str

end

T = GetTranslation

do //Keep it off the global scope
	local LangFiles = {"English", "French"}
	for _, v in pairs( LangFiles ) do

		if SERVER then
			AddCSLuaFile(  v ..".lua" )
		end
		
		include(  v ..".lua" )

	end
end

