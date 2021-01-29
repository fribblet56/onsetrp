local Dialog = ImportPackage("dialogui")
local _ = function(k, ...) return ImportPackage("i18n").t(GetPackageName(), k, ...) end

local PlayerIsRebel = 0

AddEvent("OnTranslationReady", function()

    CallRemoteEvent("rebel:GetLicense")
    rebelMenu = Dialog.create("Menu Rebelle", nil, "Menotter / Démenotter ", "Fouiller le joueur", _("put_player_in_vehicle"), _("remove_player_from_vehicle"), _("cancel"))

end)

AddRemoteEvent("rebel:Setup", function ( playerData )
	PlayerIsRebel = playerData
end)

AddEvent("OnKeyPress", function(key)
    
    if key == "F4" and not GetPlayerBusy() and PlayerIsRebel == 1 then
        Dialog.show(rebelMenu)
    end
    
    if key == "R" and IsCtrlPressed() and not GetPlayerBusy() and PlayerIsRebel == 1 then -- Fast handcuffing
        CallRemoteEvent("rebel:cuff")
    end
    
end)

AddEvent("OnDialogSubmit", function(dialog, button, ...)
    local args = {...}
    if dialog == rebelMenu then
        if button == 1 then
            CallRemoteEvent("rebel:cuff")
        end
        if button == 2 then
            CallRemoteEvent("rebel:friskplayer")
        end
        if button == 3 then
            CallRemoteEvent("rebel:playerincar", GetStreamedVehicles())
        end
        if button == 4 then
            CallRemoteEvent("rebel:removeplayerincar", GetStreamedVehicles())
        end
    end
end)