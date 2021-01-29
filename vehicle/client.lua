local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end
local Dialog = ImportPackage("dialogui")

local vehicleMenu
local vehicleInventory
local vehicleKeys

AddEvent("OnTranslationReady", function()
    -- vehicleMenu = Dialog.create("Vehicle", nil, _("trunk"), _("unflip"), _("unlock_lock"), _("keys"), _("cancel"))
    vehicleMenu = Dialog.create("Vehicle", nil, _("unlock_lock"), _("keys"), _("cancel"))

    vehicleKeys = Dialog.create(_("keys"), nil, _("give_key"), _("remove_key"), _("cancel"))
    Dialog.addSelect(vehicleKeys, 1, _("player"), 5)
    Dialog.addSelect(vehicleKeys, 1, _("player"), 1)
end)

function OnPlayerStartEnterVehicle(vehicle, seat)
    if GetVehiclePropertyValue(vehicle, "locked") then 
        MakeNotification(_("this_vehicle_locked"), "linear-gradient(to right, #ff5f6d, #ffc371)")
        return false 
    end
    if seat == 1 then
        MakeNotification("Appuyer sur X pour démarrer", "#5DADE2", 5000)
    end
end
AddEvent("OnPlayerStartEnterVehicle", OnPlayerStartEnterVehicle)

function OnPlayerStartExitVehicle(vehicle)
    if GetVehiclePropertyValue(vehicle, "locked") then 
        MakeNotification(_("this_vehicle_locked"), "linear-gradient(to right, #ff5f6d, #ffc371)")
        return false 
    end 
end
AddEvent("OnPlayerStartExitVehicle", OnPlayerStartExitVehicle)

function getNearestVehicle()
    local x, y, z = GetPlayerLocation()
    
    for k,v in pairs(GetStreamedVehicles()) do
        local x2, y2, z2 = GetVehicleLocation(v)
        local dist = GetDistance3D(x, y, z, x2, y2, z2)

		if dist < 300.0 then
			return v
		end
    end
    return 0
end

function OnKeyPress(key)
    if key == VEHICLE_LOCK_KEY and not GetPlayerBusy() then
        CallRemoteEvent("unlockVehicle")
    end
    
    local nearestVehicle = getNearestVehicle()

    if key == VEHICLE_MENU_KEY and not GetPlayerBusy() and not IsPlayerInVehicle()  then
        if nearestVehicle ~= 0 then
            CallRemoteEvent("ServerVehicleMenu", nearestVehicle)
        end
    end

    if key == VEHICLE_ENGINE_KEY and not onSpawn and not onCharacterCreation and IsPlayerInVehicle() then
        local player = GetPlayerId()
        local veh = GetPlayerVehicle(player)
        if veh ~= 0 then
            CallRemoteEvent("ToggleEngine", veh)
        end
    end

    if key == VEHICLE_TRUNK_KEY and not onSpawn and not onCharacterCreation and IsPlayerInVehicle() then
        local player = GetPlayerId()
        if GetPlayerVehicle(player) ~= 0 then
            CallRemoteEvent("ToggleTrunk")
        end
    end

    if key == VEHICLE_HOOD_KEY and not onSpawn and not onCharacterCreation and IsPlayerInVehicle() then
        local player = GetPlayerId()
        if GetPlayerVehicle(player) ~= 0 then
            CallRemoteEvent("ToggleHood")
        end
    end
end
AddEvent("OnKeyPress", OnKeyPress)


AddRemoteEvent("OpenVehicleMenu", function()
    Dialog.show(vehicleMenu)
end)

AddRemoteEvent("OpenVehicleKeys", function(keyslist, playerlist)
    Dialog.setSelectLabeledOptions(vehicleKeys, 1, 1, keyslist)
    Dialog.setSelectLabeledOptions(vehicleKeys, 1, 2, playerlist)
    Dialog.show(vehicleKeys)
end)

AddEvent("OnDialogSubmit", function(dialog, button, ...)
    local args = { ... }
	if dialog == vehicleMenu then
        if button == 1 then
            CallRemoteEvent("unlockVehicle")
        end
        if button == 2 then
            CallRemoteEvent("VehicleKeys")
        end
    end

    if dialog == vehicleKeys then
        if button == 1 then
            if args[2] == "" then
                MakeNotification(_("select_player"), "linear-gradient(to right, #ff5f6d, #ffc371)")
            else
                AddPlayerChat("Player:"..args[2])
                CallRemoteEvent("VehicleGiveKey", args[2])
            end
        end

        if button == 2 then
            if args[1] == "" then
                MakeNotification(_("select_player"), "linear-gradient(to right, #ff5f6d, #ffc371)")
            else
                CallRemoteEvent("VehicleRemoveKey", args[1])
            end
        end
    end
end)