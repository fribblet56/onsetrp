local _ = function(k, ...) return ImportPackage("i18n").t(GetPackageName(), k, ...) end
local Dialog = ImportPackage("dialogui")

local PickupMechanicCash = { }
local mechanicHelicoNpcIds_c = {}
local mechanicPickupGarageCash_c = {}
local mechanicVehiculNpcIds_c = {}

local IsOnDuty = false

local carSelect = nil
local Model = nil

AddEvent("OnPackageStart", function()
    mechanicUi = CreateWebUI(0.0, 0.0, 0.0, 0.0, 1, 60)
    SetWebAnchors(mechanicUi, 0.0, 0.0, 1.0, 1.0)
    LoadWebFile(mechanicUi, 'http://asset/' .. GetPackageName() .. '/mechanic/gui/index.html')
    SetWebVisibility(mechanicUi, WEB_HIDDEN)

    mechanicCarmenuUi = CreateWebUI(0.0, 0.0, 0.0, 0.0, 1, 60)
    SetWebAnchors(mechanicCarmenuUi, 0.0, 0.0, 1.0, 1.0)
    LoadWebFile(mechanicCarmenuUi, 'http://asset/' .. GetPackageName() .. '/mechanic/gui/carmenu.html')
    SetWebVisibility(mechanicCarmenuUi, WEB_HIDDEN)
end)

AddRemoteEvent("mechanic:setup", function ( _MechanicPickupCash, _isOnDuty, _mechanicHelicoNpcIds, MechanicPickupGarageCash, mechanicVehiculNpcIds )
	PickupMechanicCash = _MechanicPickupCash
	IsOnDuty = _isOnDuty
    mechanicHelicoNpcIds_c = _mechanicHelicoNpcIds
    mechanicPickupGarageCash_c = MechanicPickupGarageCash
    mechanicVehiculNpcIds_c = mechanicVehiculNpcIds

end)

AddEvent("OnTranslationReady", function()
        
    mechanicNpcHelicoMenu = Dialog.create("Dépanneur", nil, "Utiliser l'hélicoptère.", _("cancel"))

    mechanicNpcVehiculeMenu = Dialog.create("Dépanneur", nil, "Utiliser votre véhicule de fonction.", _("cancel"))
        
end)

AddRemoteEvent("mechanic:isonduty", function(isOnDuty)
    IsOnDuty = isOnDuty
end)

AddEvent("mechanic:Gui", function()
    SetWebVisibility(mechanicUi, WEB_HIDDEN)
    SetWebVisibility(mechanicCarmenuUi, WEB_HIDDEN)
    SetIgnoreLookInput(false)
    SetIgnoreMoveInput(false)
    ShowMouseCursor(false)
    SetInputMode(INPUT_GAME)
end)

AddRemoteEvent("mechanic:SetPlayerInfo", function ( value )
	ExecuteWebJS(mechanicUi, "Setup("..value..");")
end)

AddEvent("mechanic:changeStatut", function ( )
	SetWebVisibility(mechanicUi, WEB_HIDDEN)
    SetIgnoreLookInput(false)
    SetIgnoreMoveInput(false)
    ShowMouseCursor(false)
    SetInputMode(INPUT_GAME)
	CallRemoteEvent("mechanic:startstopservice")
end)

function OnKeyPress(key)
    if key == INTERACT_KEY and not GetPlayerBusy() then
        local nearestMechanic = GetNearestPickUpMechanic()
        if nearestMechanic ~= 0 then
        	CallRemoteEvent("mechanic:getJob")
            SetWebVisibility(mechanicUi, WEB_VISIBLE)
            SetIgnoreLookInput(true)
            SetIgnoreMoveInput(true)
            ShowMouseCursor(true)
        end
    end
    if key == JOB_MENU_KEY and not GetPlayerBusy() then
    	if IsOnDuty == true then
            if IsPlayerInVehicle(GetPlayerId()) ~= true then
                SetWebVisibility(mechanicCarmenuUi, WEB_VISIBLE)
                SetIgnoreLookInput(true)
                SetIgnoreMoveInput(true)
                ShowMouseCursor(true)
            end
        end
    end
    if key == INTERACT_KEY and not GetPlayerBusy() then
        local nearestMechanicHelico = GetNearestMechanicNpc()
        if nearestMechanicHelico ~= 0 and IsOnDuty == true then
            Dialog.show(mechanicNpcHelicoMenu)
        end
    end
    if key == INTERACT_KEY and not GetPlayerBusy() then
        local nearestMechanicVehicule = GetNearestMechanicVehiculeNpc()
        if nearestMechanicVehicule ~= 0 and IsOnDuty == true then
            Dialog.show(mechanicNpcVehiculeMenu)
        end
    end
end
AddEvent("OnKeyPress", OnKeyPress)

AddEvent("OnDialogSubmit", function(dialog, button)

    if dialog == mechanicNpcHelicoMenu then
        if button == 1 then
            CallRemoteEvent("mechanic:spawnhelico")
        end
    end

    if dialog == mechanicNpcVehiculeMenu then
        if button == 1 then
            CallRemoteEvent("mechanic:spawnvehicule")
        end
    end
    
end)

function GetNearestMechanicNpc()
    local x, y, z = GetPlayerLocation()
    for k, npcId in pairs(GetStreamedNPC()) do
        local x2, y2, z2 = GetNPCLocation(npcId)
        local dist = GetDistance3D(x, y, z, x2, y2, z2)

        if dist < 250.0 then
            if npcId == mechanicHelicoNpcIds_c then
                return npcId
            end
        end
    end
    return 0
end

function GetNearestMechanicVehiculeNpc()
    local x, y, z = GetPlayerLocation()
    for k, npcId in pairs(GetStreamedNPC()) do
        local x2, y2, z2 = GetNPCLocation(npcId)
        local dist = GetDistance3D(x, y, z, x2, y2, z2)

        if dist < 250.0 then
            if npcId == mechanicVehiculNpcIds_c then
                return npcId
            end
        end
    end
    return 0
end

function GetNearestPickUpMechanic()
	local x, y, z = GetPlayerLocation()

	for k,v in pairs(GetStreamedPickups()) do
		local x2, y2, z2 = GetPickupLocation(v)

		local dist = GetDistance3D(x, y, z, x2, y2, z2)

		if dist < 400.0 then
            for k,i in pairs(PickupMechanicCash) do
				if v == i then
					return v
				end
			end
		end
	end

	return 0
end



AddEvent("mechanic:repaireCar",function ( )
	CallRemoteEvent("mechanic:repaireCar_s")
end)

AddEvent("mechanic:selectCar",function ( )
    carSelect, Model = GetNearestCar()
    CallRemoteEvent("mechanic:MakeNotification:selectCar", Model)
end)

AddEvent("mechanic:mouveCar",function ( )
    CallRemoteEvent("mechanic:mouveCar_s", carSelect)
    selectCar = nil
end)

AddEvent("mechanic:openCar",function ( )
	CallRemoteEvent("mechanic:openCar_s")
end)

AddEvent("mechanic:unFlip",function ( )
    CallRemoteEvent("mechanic:unFlip_s", carSelect)
end)

function GetNearestCar()
	local x, y, z = GetPlayerLocation()

	for k,v in pairs(GetStreamedVehicles()) do
		local x2, y2, z2 = GetVehicleLocation(v)

		local dist = GetDistance3D(x, y, z, x2, y2, z2)

		if dist < 400.0 then
			return v, GetVehicleModel(k)
		end
	end

	return 0
end