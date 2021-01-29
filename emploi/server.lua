local _ = function(k, ...) return ImportPackage("i18n").t(GetPackageName(), k, ...) end

local EmploiNpcPos = { 200775, 183656, 1308, 72 }
local EmploiNpcCash = {}

AddEvent("OnPackageStart", function( )
	EmploiNpcCash = CreateNPC(EmploiNpcPos[1], EmploiNpcPos[2], EmploiNpcPos[3], EmploiNpcPos[4] )
    CreateText3D("Pole Emploi  \n".._("press_e"), 18, EmploiNpcPos[1], EmploiNpcPos[2], EmploiNpcPos[3]  + 120, 0, 0, 0)
end)

AddEvent("OnPlayerJoin", function( player )
	CallRemoteEvent(player, "emploi:Setup", EmploiNpcCash)
end)