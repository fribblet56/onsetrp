local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local deliveryNpc = {
    location = { -16925, -29058, 2200, -90 },
    spawn = { -17450, -28600, 2060, 110 }
}
local deliveryPoint = {
    { 116691, 164243, 3028 },
    { 38964, 204516, 550 },
    { 182789, 186140, 1203 },
    { 211526, 176056, 1209 },
    { 42323, 137508, 1569 },
    { 122776, 207169, 1282 },
    { 209829, 92977, 1312 },
    { 176840, 10049, 10370 },
    { 198130, -49703, 1109 },
    { 130042, 78285, 1566 },
    { 203711, 190025, 1312 },
    { 170311, -161302, 1242 },
    { 152267, -143379, 1242 },
    { -181677, -31627, 1148 },
    { -179804, -66772, 1147 },
    { 182881, 148416, 5933 }
}

local playerDelivery = {}

AddEvent("OnPackageStart", function()
    deliveryNpc.npc = CreateNPC(deliveryNpc.location[1], deliveryNpc.location[2], deliveryNpc.location[3],deliveryNpc.location[4])
    CreateText3D(_("delivery_job").."\n".._("press_e"), 18, deliveryNpc.location[1], deliveryNpc.location[2], deliveryNpc.location[3] + 120, 0, 0, 0)
end)

AddEvent("OnPlayerJoin", function(player)
    CallRemoteEvent(player, "SetupDelivery", deliveryNpc.npc)
end)

AddRemoteEvent("StartStopDelivery", function(player)
    if PlayerData[player].job == "" then
        if PlayerData[player].job_vehicle ~= nil then
            DestroyVehicle(PlayerData[player].job_vehicle)
            DestroyVehicleData(PlayerData[player].job_vehicle)
            PlayerData[player].job_vehicle = nil
        else
            local isSpawnable = true
            for k,v in pairs(GetAllVehicles()) do
                local x, y, z = GetVehicleLocation(v)
                local dist2 = GetDistance3D(deliveryNpc.spawn[1], deliveryNpc.spawn[2], deliveryNpc.spawn[3], x, y, z)
                if dist2 < 1500.0 then
                    isSpawnable = false
                    break
                end
            end
            if isSpawnable then
                local vehicle = CreateVehicle(24, deliveryNpc.spawn[1], deliveryNpc.spawn[2], deliveryNpc.spawn[3], deliveryNpc.spawn[4])
                PlayerData[player].job_vehicle = vehicle
                CreateVehicleData(player, vehicle, 24)
                SetVehiclePropertyValue(vehicle, "locked", true, true)
                PlayerData[player].job = "delivery"
                return
            end
        end
    elseif PlayerData[player].job == "delivery" then
        if PlayerData[player].job_vehicle ~= nil then
            DestroyVehicle(PlayerData[player].job_vehicle)
            DestroyVehicleData(PlayerData[player].job_vehicle)
            PlayerData[player].job_vehicle = nil
        end
        PlayerData[player].job = ""
        playerDelivery[player] = nil
        CallRemoteEvent(player, "ClientDestroyCurrentWaypoint")
    end
end)

AddRemoteEvent("OpenDeliveryMenu", function(player)
    if PlayerData[player].job == "delivery" then
        CallRemoteEvent(player, "DeliveryMenu")
    end
end)

AddRemoteEvent("NextDelivery", function(player)
    if playerDelivery[player] ~= nil then
        return AddPlayerChat(player, _("finish_your_delivery"))
    end
    delivery = Random(1, #deliveryPoint)
    playerDelivery[player] = delivery
    CallRemoteEvent(player, "ClientCreateWaypoint", _("delivery"), deliveryPoint[delivery][1], deliveryPoint[delivery][2], deliveryPoint[delivery][3])
    AddPlayerChat(player, _("new_delivery"))
end)

AddRemoteEvent("FinishDelivery", function(player)
    delivery = playerDelivery[player]

    if delivery == nil then
        AddPlayerChat(player, _("no_delivery"))
    end

    local x, y, z = GetPlayerLocation(player)
    
    local dist = GetDistance3D(x, y, z, deliveryPoint[delivery][1], deliveryPoint[delivery][2], deliveryPoint[delivery][3])

    if dist < 150.0 then
        local reward = Random(100, 500)

        AddPlayerChat(player, _("finished_delivery", reward, _("currency")))
        
        PlayerData[player].cash = PlayerData[player].cash + reward
        playerDelivery[player] = nil
        CallRemoteEvent(player, "ClientDestroyCurrentWaypoint")
    else
        AddPlayerChat(player, _("no_delivery_point"))
    end
end)