local _ = function(k, ...) return ImportPackage("i18n").t(GetPackageName(), k, ...) end

MechanicPickupCash = { }
local mechanicGarageIds = {}

MechanicPickupJob = {
	{
	modelid = 2,
	location = {
		{ 144493, 185049, 1778 }
	},
	object = { }
	}
}

local ALLOW_RESPAWN_VEHICLE = false

local MECHANIC_HELICO_SPAWN_LOCATION = {
    {x = 148262, y = 178919, z = 1538, h = -90},
}

local MECHANIC_VEHICLE_SPAWN_LOCATION = {
    {x = 145909, y = 184723, z = 1115, h = -90},
}

local MECHANIC_HELICO_NPC = {
    x = 149421,
    y = 179437,
    z = 1538,
    h = -180
}

local MECHANIC_VEHICLE_NPC = {
    x = 145485,
    y = 184385,
    z = 1115,
    h = -90
}

local MECHANIC_GARAGE = {
    {x = 147435, y = 177889, z = 1532},
    {x = 145258, y = 185004, z = 1115}
}

local mechanicHelicoNpcIds = {}
local mechanicVehiculNpcIds = {}

maxMechanic = 10
mechanicmens = 0

AddEvent("OnPackageStart", function( )
	for k, v in pairs(MECHANIC_GARAGE) do
        v.garageObject = CreatePickup(2, v.x, v.y, v.z)
        CreateText3D("Ranger votre véhicule de service \n Entrer en contacte", 18, v.x, v.y, v.z + 100, 0, 0, 0)
        table.insert(mechanicGarageIds, v.garageObject)
    end

	for k,v in pairs(MechanicPickupJob) do
		for i,j in pairs(v.location) do
			v.object[i] = CreatePickup(v.modelid, v.location[i][1], v.location[i][2], v.location[i][3])
			CreateText3D("Prendre sont service \n".._("press_e"), 18, v.location[i][1], v.location[i][2], v.location[i][3] + 100, 0, 0, 0)

			table.insert(MechanicPickupCash, v.object[i])
		end
	end

	mechanicVehiculNpcIds = CreateNPC(MECHANIC_VEHICLE_NPC.x, MECHANIC_VEHICLE_NPC.y, MECHANIC_VEHICLE_NPC.z, MECHANIC_VEHICLE_NPC.h )
    CreateText3D("Véhicule dépanneur \n".._("press_e"), 18, MECHANIC_VEHICLE_NPC.x, MECHANIC_VEHICLE_NPC.y, MECHANIC_VEHICLE_NPC.z  + 120, 0, 0, 0)

	mechanicHelicoNpcIds = CreateNPC(MECHANIC_HELICO_NPC.x, MECHANIC_HELICO_NPC.y, MECHANIC_HELICO_NPC.z, MECHANIC_HELICO_NPC.h )
    CreateText3D("Hélicoptère dépanneur \n".._("press_e"), 18, MECHANIC_HELICO_NPC.x, MECHANIC_HELICO_NPC.y, MECHANIC_HELICO_NPC.z  + 120, 0, 0, 0)
end)

AddEvent("OnPlayerJoin", function( player )
	CallRemoteEvent(player, "mechanic:setup", MechanicPickupCash, false, mechanicHelicoNpcIds, MechanicPickupGarageCash, mechanicVehiculNpcIds)
end)

function MechanicGetClosestSpawnPoint(player)
    local x, y, z = GetPlayerLocation(player)
    local closestSpawnPoint
    local dist
    for k, v in pairs(MECHANIC_HELICO_SPAWN_LOCATION) do
        local currentDist = GetDistance3D(x, y, z, v.x, v.y, v.z)
        if (dist == nil or currentDist < dist) and currentDist <= 10000 then
            closestSpawnPoint = k
            dist = currentDist
        end
    end
    return closestSpawnPoint
end

function DespawnMechanicCar(player)-- to despawn an ambulance
    -- #2 Check if the player has a job vehicle spawned then destroy it
    if PlayerData[player].job_vehicle ~= nil then
        DestroyVehicle(PlayerData[player].job_vehicle)
        DestroyVehicleData(PlayerData[player].job_vehicle)
        PlayerData[player].job_vehicle = nil
        CallRemoteEvent(player, "MakeNotification", _("vehicle_stored"), "#5DADE2")
        return
    end
end

AddEvent("OnPlayerPickupHit", function(player, pickup)-- Store the vehicle in garage
    if PlayerData[player].mechanic ~= 1 then return end
    if PlayerData[player].job ~= "mechanic" then return end
    for k, v in pairs(MECHANIC_GARAGE) do
        if v.garageObject == pickup then
            local vehicle = GetPlayerVehicle(player)
            if vehicle == nil then return end
            local seat = GetPlayerVehicleSeat(player)
            if vehicle == PlayerData[player].job_vehicle and
                VehicleData[vehicle].owner == PlayerData[player].accountid and
                seat == 1
            then
                DespawnMechanicCar(player)
            end
        end
    end
end)

function SpawnMechanicHelico(player)-- to spawn an ambulance
    -- #1 Check for the medic whitelist of the player
    if PlayerData[player].mechanic ~= 1 then
        CallRemoteEvent(player, "MakeErrorNotification", _("not_whitelisted"))
        return
    end
    if PlayerData[player].job ~= "mechanic" then
        CallRemoteEvent(player, "MakeErrorNotification", "Vous n'êtes pas Dépanneur.")
        return
    end
    
    -- #2 Check if the player has a job vehicle spawned then destroy it
    if PlayerData[player].job_vehicle ~= nil and ALLOW_RESPAWN_VEHICLE then
        DestroyVehicle(PlayerData[player].job_vehicle)
        DestroyVehicleData(PlayerData[player].job_vehicle)
        PlayerData[player].job_vehicle = nil
    end
    
    -- #3 Try to spawn the vehicle
    if PlayerData[player].job_vehicle == nil then
        local spawnPoint = MECHANIC_HELICO_SPAWN_LOCATION[MechanicGetClosestSpawnPoint(player)]
        if spawnPoint == nil then return end
        for k, v in pairs(GetStreamedVehiclesForPlayer(player)) do
            local x, y, z = GetVehicleLocation(v)
            if x == false then break end
            local dist2 = GetDistance3D(spawnPoint.x, spawnPoint.y, spawnPoint.z, x, y, z)
            if dist2 < 500.0 then
                CallRemoteEvent(player, "MakeErrorNotification", _("cannot_spawn_vehicle"))
                return
            end
        end
        local vehicle = CreateVehicle(10, spawnPoint.x, spawnPoint.y, spawnPoint.z, spawnPoint.h)
        SetVehicleLicensePlate(vehicle, "MEC-"..PlayerData[player].accountid) 
        SetVehicleColor(vehicle, "0xE26200")
        PlayerData[player].job_vehicle = vehicle
        CreateVehicleData(player, vehicle, 3)
        SetVehicleRespawnParams(vehicle, false)
        SetVehiclePropertyValue(vehicle, "locked", true, true)
        CallRemoteEvent(player, "MakeNotification", _("spawn_vehicle_success"), "#5DADE2")
    else
        CallRemoteEvent(player, "MakeErrorNotification", _("cannot_spawn_vehicle"))
    end
end
AddRemoteEvent("mechanic:spawnhelico", SpawnMechanicHelico)

function SpawnMechanicVehicule(player)-- to spawn an ambulance
    -- #1 Check for the medic whitelist of the player
    if PlayerData[player].mechanic ~= 1 then
        CallRemoteEvent(player, "MakeErrorNotification", _("not_whitelisted"))
        return
    end
    if PlayerData[player].job ~= "mechanic" then
        CallRemoteEvent(player, "MakeErrorNotification", "Vous n'êtes pas Dépanneur.")
        return
    end
    
    -- #2 Check if the player has a job vehicle spawned then destroy it
    if PlayerData[player].job_vehicle ~= nil and ALLOW_RESPAWN_VEHICLE then
        DestroyVehicle(PlayerData[player].job_vehicle)
        DestroyVehicleData(PlayerData[player].job_vehicle)
        PlayerData[player].job_vehicle = nil
    end
    
    -- #3 Try to spawn the vehicle
    if PlayerData[player].job_vehicle == nil then
        local spawnPoint = MECHANIC_VEHICLE_SPAWN_LOCATION[MechanicGetClosestSpawnPoint(player)]
        if spawnPoint == nil then return end
        for k, v in pairs(GetStreamedVehiclesForPlayer(player)) do
            local x, y, z = GetVehicleLocation(v)
            if x == false then break end
            local dist2 = GetDistance3D(spawnPoint.x, spawnPoint.y, spawnPoint.z, x, y, z)
            if dist2 < 500.0 then
                CallRemoteEvent(player, "MakeErrorNotification", _("cannot_spawn_vehicle"))
                return
            end
        end
        local vehicle = CreateVehicle(7, spawnPoint.x, spawnPoint.y, spawnPoint.z, spawnPoint.h)
        SetVehicleLicensePlate(vehicle, "MEC-"..PlayerData[player].accountid) 
        SetVehicleColor(vehicle, "0xE26200")
        PlayerData[player].job_vehicle = vehicle
        CreateVehicleData(player, vehicle, 3)
        SetVehicleRespawnParams(vehicle, false)
        SetVehiclePropertyValue(vehicle, "locked", true, true)
        CallRemoteEvent(player, "MakeNotification", _("spawn_vehicle_success"), "#5DADE2")
    else
        CallRemoteEvent(player, "MakeErrorNotification", _("cannot_spawn_vehicle"))
    end
end
AddRemoteEvent("mechanic:spawnvehicule", SpawnMechanicVehicule)

function mechanicStartStopService(player)
    if PlayerData[player].job == "" then
        mechanicStartService(player)
    elseif PlayerData[player].job == "mechanic" then
        mechanicEndService(player)
    else
        CallRemoteEvent(player, "MakeErrorNotification", _("please_leave_previous_job"))
    end
end
AddRemoteEvent("mechanic:startstopservice", mechanicStartStopService)

AddRemoteEvent("mechanic:getJob", function (player)
    if PlayerData[player].job == "" then
        CallRemoteEvent(player, "mechanic:SetPlayerInfo", 0)
    elseif PlayerData[player].job == "mechanic" then
        CallRemoteEvent(player, "mechanic:SetPlayerInfo", 1)
    end
end)

function mechanicStartService(player)

    if PlayerData[player].mechanic ~= 1 then
        CallRemoteEvent(player, "MakeErrorNotification", _("not_whitelisted"))
        return
    end
    

    if PlayerData[player].job_vehicle ~= nil then
        DestroyVehicle(PlayerData[player].job_vehicle)
        DestroyVehicleData(PlayerData[player].job_vehicle)
        PlayerData[player].job_vehicle = nil
    end
    
    if mechanicmens >= maxMechanic then
        CallRemoteEvent(player, "MakeErrorNotification", "La limite de place de ce metier est atteinte.")
        return
    end

    for k, v in pairs(PlayerData) do
        if v.job == "mechanic" then mechanicmens = mechanicmens + 1 end
    end

    local x, y, z = GetPlayerLocation(player)
    PlayerData[player].hat = CreateObject(402, x, y, z)
    SetObjectScale(PlayerData[player].hat, 1.4, 1.4, 1.4)

    SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 17.0, 2.0, 0.0, 180.0, 90.0, -90.0, "head")
    

    PlayerData[player].job = "mechanic" 

    GivePoliceEquipmentToPlayer(player)
    UpdateClothes(player)
    
	CallRemoteEvent(player, "mechanic:isonduty", true)   

    CallRemoteEvent(player, "MakeNotification", "Vous avez pris votre service de Dépaneur.", "#5DADE2")
    
    return true
end

function mechanicEndService(player)

    if PlayerData[player].job_vehicle ~= nil then
        DestroyVehicle(PlayerData[player].job_vehicle)
        DestroyVehicleData(PlayerData[player].job_vehicle)
        PlayerData[player].job_vehicle = nil
    end

    mechanicmens = mechanicmens - 1

    DestroyObject(PlayerData[player].hat)
    PlayerData[player].hat = nil

    PlayerData[player].job = ""


    UpdateClothes(player)

    CallRemoteEvent(player, "mechanic:isonduty", false)   
    
    CallRemoteEvent(player, "MakeNotification", "Vous avez quiter votre service de Dépaneur.", "#5DADE2")
    
    return true
end

AddRemoteEvent("mechanic:MakeNotification:selectCar", function ( player, carName )
	if carName ~= nil then
		local name = _("vehicle_"..carName)
		CallRemoteEvent(player, "MakeNotification", "Vous avez sélectionner : "..tostring(name), "#5DADE2")
	else
		CallRemoteEvent(player, "MakeErrorNotification", "Aucun véhicule a proximiter.")
	end
end)


AddRemoteEvent("mechanic:repaireCar_s",function ( player )
	local nearestCar = GetNearestCar(player)
    if not IsValidVehicle(nearestCar) then return end                
    if nearestCar ~= 0 then
        if GetVehicleHealth(nearestCar) >= 5000 then
            CallRemoteEvent(player, "MakeErrorNotification", _("dont_need_repair"))
        else
        	SetVehicleHoodRatio(nearestCar, 1)
            CallRemoteEvent(player, "LockControlMove", true)
            SetPlayerAnimation(player, "COMBINE")
            SetPlayerBusy(player)
            CallRemoteEvent(player, "loadingbar:show", _("repairing"), 20)-- LOADING BAR
            Delay(20000, function()
                SetVehicleHealth(nearestCar, 5000)   
                local percentOfDamage = (1 - (GetVehicleHealth(nearestCar) / 5000)) or 0.5
                if percentOfDamage < 0 then percentOfDamage = 0 end
                if percentOfDamage > 1 then percentOfDamage = 1 end
                for j = 1, 8 do
                    SetVehicleDamage(nearestCar, j, percentOfDamage)                 
                end 
                if GetVehicleHealth(nearestCar) > 5000 then SetVehicleHealth(nearestCar, 5000) end   
                CallRemoteEvent(player, "LockControlMove", false)
                SetPlayerAnimation(player, "STOP")
                SetPlayerNotBusy(player)
                CallRemoteEvent(player, "MakeSuccessNotification", _("repair_kit_vehicle_repaired"))
                SetVehicleHoodRatio(nearestCar, 0)
            end)
        end
    end
end)

AddRemoteEvent("mechanic:unFlip_s",function ( player, selectCar)
    if selectCar ~= nil then
        local rx, ry, rz = GetVehicleRotation(selectCar)

        SetVehicleRotation(selectCar, 0, ry, 0 )
    else
        CallRemoteEvent(player, "MakeErrorNotification", "Vous n'avez pas sélectioner de véhicule")
    end
    
end)

AddRemoteEvent("mechanic:mouveCar_s",function ( player, selectCar)
	if selectCar ~= nil then
		local x,y,z = GetPlayerLocation(player)
		SetVehicleLocation(selectCar, x+250, y+250, z)
		CallRemoteEvent(player, "MakeSuccessNotification", "Véhicule déplacer.")
	else
		CallRemoteEvent(player, "MakeErrorNotification", "Vous n'avez pas sélectioner de véhicule")
	end
	
end)

AddRemoteEvent("mechanic:openCar_s",function (player)
	local nearestCar = GetNearestCar(player)
    if GetVehiclePropertyValue(nearestCar, "locked") then
		CallRemoteEvent(player, "LockControlMove", true)
		SetVehicleHoodRatio(nearestCar, 1)
		SetPlayerAnimation(player, "LOCKDOOR")
		CallRemoteEvent(player,"loadingbar:show","Ouverture du véhicule ...",10)
		Delay(3000, function()
			SetPlayerAnimation(player, "LOCKDOOR")
		end)
		Delay(6000, function()
			SetPlayerAnimation(player, "LOCKDOOR")
		end)
		Delay(10000, function()
			SetVehiclePropertyValue(nearestCar, "locked", false, true)
			CallRemoteEvent(player, "MakeSuccessNotification", _("car_unlocked"))
			CallRemoteEvent(player, "LockControlMove", false)
			SetPlayerAnimation(player, "STOP")
			CallRemoteEvent(player,"loadingbar:hide")
			SetVehicleHoodRatio(nearestCar, 0)
			for j = 1, 8 do
                SetVehicleDamage(nearestCar, j, 0.0)                 
            end
		end)
	else
		CallRemoteEvent(player, "MakeErrorNotification", _("vehicle_already_unlocked"))
	end
end)