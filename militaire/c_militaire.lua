local Dialog = ImportPackage("dialogui")
local _ = function(k, ...) return ImportPackage("i18n").t(GetPackageName(), k, ...) end

local IsOnDuty = false

local militaireMenu
local militaireFineMenu
local militaireNpcGarageMenu
local militaireEquipmentMenu

local militaireNpcIds = {}
local militaireVehicleNpcIds = {}
local militaireGarageIds = {}
local militaireEquipmentNpcIds = {}

AddRemoteEvent("militaire:setup", function(_militaireNpcIds, _militaireGarageIds, _militaireVehicleNpcIds, _militaireEquipmentNpcIds)
    militaireNpcIds = _militaireNpcIds
    militaireGarageIds = _militaireGarageIds
    militaireVehicleNpcIds = _militaireVehicleNpcIds
    militaireEquipmentNpcIds = _militaireEquipmentNpcIds
end)

AddRemoteEvent("militaire:client:isonduty", function(isOnDuty)
    IsOnDuty = isOnDuty
end)

--AddRemoteEvent("militaire:SetClothers", function ( clother )
    --SetPlayerNetworkedCustomClothes(clother)
--end)

AddEvent("OnTranslationReady", function()
        -- militaire MENU
        militaireMenu = Dialog.create("Menu Militaire", nil, "Menotter / Démenotter ", _("put_player_in_vehicle"), _("remove_player_from_vehicle"), "Fouiller le Joueur",_("cancel"))
        
        -- FINE MENU
        militaireFineMenu = Dialog.create(_("finemilitaire"), nil, _("give_fine"), _("cancel"))
        Dialog.addTextInput(militaireFineMenu, 1, _("amount") .. " :")
        Dialog.addTextInput(militaireFineMenu, 1, _("reason") .. " :")
        
        -- SPAWN VEHICLE MENU
        militaireNpcGarageMenu = Dialog.create(_("militaire_garage_menu"), nil, _("spawn_despawn_patrol_car"), _("cancel"))

        -- militaire EQUIPMENT MENU
        militaireEquipmentMenu = Dialog.create(_("militaire_armory"), nil, _("police_check_my_equipment"), _("cancel"))
end)

AddEvent("OnKeyPress", function(key)
    
    if key == JOB_MENU_KEY and not GetPlayerBusy() and IsOnDuty then
        Dialog.show(militaireMenu)
    end
    
    if key == "R" and IsCtrlPressed() and not GetPlayerBusy() and IsOnDuty then -- Fast handcuffing
        CallRemoteEvent("militaire:cuff")
    end
    
    if key == INTERACT_KEY and not GetPlayerBusy() and IsOnDuty and IsNearbyNpc(GetPlayerId(), militaireVehicleNpcIds) ~= false then
        Dialog.show(militaireNpcGarageMenu)
    end
    
    if key == INTERACT_KEY and not GetPlayerBusy() and IsNearbyNpc(GetPlayerId(), militaireNpcIds) ~= false then
        AskForServiceMilitaire(IsNearbyNpc(GetPlayerId(), militaireNpcIds))
    end

    if key == INTERACT_KEY and not GetPlayerBusy() and IsOnDuty and IsNearbyNpc(GetPlayerId(), militaireEquipmentNpcIds) ~= false then
        Dialog.show(militaireEquipmentMenu)        
    end
end)

function AskForServiceMilitaire(npc)
    
    local message = (IsOnDuty and "C'est l'heure de retrouver sa femme et c'est enfant ?" or "C’est la fin de votre permission soldat ?")
    startCinematic({
        title = "Général d'armée Raoul Salan",
        message = message,
        actions = {
            {
                text = _("yes"),
                callback = "militaire:startstopcinematic"
            },
            {
                text = _("no"),
                close_on_click = true
            }
        }
    }, Nearestmilitaire, "SALUTE")
end

AddEvent("militaire:startstopcinematic", function()
    
    local message = (IsOnDuty and "Prenez soin de vous soldat !" or "Bien aller vous équiper le bataillon doit déjà vous attendre.")
    updateCinematic({
        message = message
    }, Nearestmilitaire, "WALLLEAN04")
    Delay(1500, function()
        stopCinematic()
    end)
    CallRemoteEvent("militaire:startstopservice")
end)

AddEvent("OnDialogSubmit", function(dialog, button, ...)
    local args = {...}
    if dialog == militaireMenu then
        if button == 1 then
            CallRemoteEvent("militaire:cuff")
        end
        if button == 2 then
            CallRemoteEvent("militaire:playerincar")
        end
        if button == 3 then
            CallRemoteEvent("militaire:removeplayerincar")
        end
        if button == 4 then
            CallRemoteEvent("militaire:friskplayer")            
        end
    end
    
    if dialog == militaireFineMenu then
        if button == 1 then
            if args[1] ~= "" then
                if tonumber(args[1]) > 0 then
                    CallRemoteEvent("militaire:fine", args[1], args[2])
                else
                    MakeNotification(_("enter_higher_number"), "linear-gradient(to right, #ff5f6d, #ffc371)")
                end
            else
                MakeNotification(_("valid_number"), "linear-gradient(to right, #ff5f6d, #ffc371)")
            end
        
        end
    end
    
    if dialog == militaireNpcGarageMenu then
        if button == 1 then
            CallRemoteEvent("militaire:spawnvehicle")
        end
    end

    if dialog == militaireEquipmentMenu then
        if button == 1 then
            CallRemoteEvent("militaire:checkmyequipment")
            MakeNotification(_("militaire_equipment_checked"), "linear-gradient(to right, #00b09b, #96c93d)")
        end
    end
end)

AddEvent("OnPlayerStartExitVehicle", function(vehicle)
    if (GetPlayerPropertyValue(GetPlayerId(), "cuffed")) then
        return false
    end
end)

AddEvent("OnPlayerStartEnterVehicle", function(vehicle)
    if (GetPlayerPropertyValue(GetPlayerId(), "cuffed")) then
        return false
    end
end)

function IsNearbyNpc(player, npcs)
    local x, y, z = GetPlayerLocation(player)
    for k, v in pairs(npcs) do
        local x2, y2, z2 = GetNPCLocation(v)
        if x2 ~= false and GetDistance3D(x, y, z, x2, y2, z2) <= 200 then return v end
    end
    return false
end

local wp = nil
AddRemoteEvent("militaire:waypoint", function(x,y,z)
    if wp ~= nil then DestroyWaypoint(wp) end    
    if tonumber(x) ~= nil and tonumber(y) ~= nil and tonumber(z) ~= nil then
        wp = CreateWaypoint(tonumber(x), tonumber(y), tonumber(z), _("militaire_robbery_in_progress"))    
    end
end)

AddRemoteEvent("militaire:delwaypoint", function()
    DestroyWaypoint(wp)
    wp = nil    
end)


