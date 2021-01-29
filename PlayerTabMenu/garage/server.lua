local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

GarageDealerObjectsCached = { }
GarageDealerTable = {
    {
        location = { -184007, -50877, 1146, -90 },
        spawn = { -183649, -51499, 1146, -90 }
    },
    {
        location = { 172750, 207070, 1411, 180 },
        spawn = { 172250, 207314, 1411 , 180 }
    },
    {
        location = { 172755, 206076, 1411, 180 },
        spawn = { 172250, 205843, 1411 , 180 }
    },
    {
        location = { -113129, 204231, 1431, -12 },
        spawn = { -111475, 204229, 1431 , -90 }
    },
    {
        location = { -24977, -17363, 2062, -180 },
        spawn = { -25798, -17967, 2062 , -180 }
    },
    {
        location = { 128271, 75035, 1566, 90 },
        spawn = { 129024, 75681, 1566 , 90 }
    }
 }

 GarageStoreTable = {
    {
        modelid = 2,
        location = {
            { 20752, 168878, 1306 },
            { -184587, -51196, 1146 },
            { -185403, -51170, 1146 },
            { -185603, -51410, 1146 },
			{ 203269, 201098, 1307 },
			{ 203973, 201098, 1307 },
            { -25189, -16824, 2077 },
            { 172676, 206306, 1411 },
            { 172676, 206848, 1411 },
            { -111434, 205125, 1431 },
            { -101455, 192152, 1315 },
            { 127542, 75136, 1566 }
        },
        object = {}
    }
}

EditCarTable = {
    {
        modelid = 337,
        location = {
            { 145325, 177615, 1510 }
        },
        object = {}
    }
}

GarageStoreObjectsCached = {}

AddEvent("database:connected", function()
    mariadb_query(sql, "UPDATE `player_garage` SET `garage`=1 WHERE garage = 0;")
end)

 AddEvent("OnPackageStart", function()
	for k,v in pairs(GarageDealerTable) do
        v.npc = CreateNPC(v.location[1], v.location[2], v.location[3], v.location[4])

		CreateText3D(_("garage").."\n".._("press_e"), 18, v.location[1], v.location[2], v.location[3] + 120, 0, 0, 0)

		table.insert(GarageDealerObjectsCached, v.npc)
    end

    for k,v in pairs(GarageStoreTable) do
        for i,j in pairs(v.location) do
            v.object[i] = CreatePickup(v.modelid , v.location[i][1], v.location[i][2], v.location[i][3])
            CreateText3D("Stocker votre véhicule \n Entrer en contact", 18, v.location[i][1], v.location[i][2], v.location[i][3] + 120, 0, 0, 0)

            table.insert(GarageStoreObjectsCached, v.object[i])
        end
	end

    for k,v in pairs(EditCarTable) do
        for i,j in pairs(v.location) do
            v.object[i] = CreatePickup(v.modelid , v.location[i][1], v.location[i][2], v.location[i][3])
            CreateText3D("Customiser votre vehicule \n Entrer en contact", 18, v.location[i][1], v.location[i][2], v.location[i][3] + 120, 0, 0, 0)
        end
    end
end)

AddEvent("OnPlayerJoin", function(player)
    CallRemoteEvent(player, "garageDealerSetup", GarageDealerObjectsCached)
end)

AddRemoteEvent("garageDealerInteract", function(player, garagedealerobject)
    local garagedealer = GetGarageDealearByObject(garagedealerobject)
	if garagedealer then
		local x, y, z = GetNPCLocation(garagedealer.npc)
		local x2, y2, z2 = GetPlayerLocation(player)
        local dist = GetDistance3D(x, y, z, x2, y2, z2)
		if dist < 150 then
            sendGarageList(player)
		end
	end
end)

function GetGarageDealearByObject(garagedealerobject)
	for k,v in pairs(GarageDealerTable) do
		if v.npc == garagedealerobject then
			return v
		end
	end
	return nil
end

function sendGarageList(player)
    local query = mariadb_prepare(sql, "SELECT * FROM player_garage WHERE ownerid = ? AND garage = 1;",
		PlayerData[player].accountid)

    mariadb_async_query(sql, query, OnGarageListLoaded, player)
end

function OnGarageListLoaded(player)
    local lVehicle = {}
    for i=1,mariadb_get_row_count() do
        local result = mariadb_get_assoc(i)

        local id = tostring(result["id"])
        local modelid = math.tointeger(result["modelid"])
        local color = result["color"]
        local name = "vehicle_"..modelid
        local price = math.ceil(result["price"] * 0.25)
        lVehicle[id] = {}
        lVehicle[id].name = name
        lVehicle[id].price = price
    end
    CallRemoteEvent(player, "openGarageDealer", lVehicle)

end

function OnPlayerPickupHit(player, pickup)
    for k,v in pairs(GarageStoreTable) do
        for i,j in pairs(v.object) do
            if j == pickup then
                vehicle = GetPlayerVehicle(player)
                seat = GetPlayerVehicleSeat(player)
                if (vehicle ~= 0 and seat == 1) then
                    if (VehicleData[vehicle].owner == PlayerData[player].accountid) then
                        MoveVehicleToGarage(vehicle, player)
                    end
                end
            end
		end
	end
    for k,v in pairs(EditCarTable) do
        for i,j in pairs(v.object) do
            if j == pickup then
                vehicle = GetPlayerVehicle(player)
                seat = GetPlayerVehicleSeat(player)
                if (vehicle ~= 0 and seat == 1) then
                    if (VehicleData[vehicle].owner == PlayerData[player].accountid) then
                        CallRemoteEvent(player, "showeditcar")
                    end
                end
            end
        end
    end
end
AddEvent("OnPlayerPickupHit", OnPlayerPickupHit)

function s_ChangeCarColor(arg1, arg2, arg3)

    local cash = PlayerData[arg2].inventory['cash'] or 0
    if cash >= 1000 then
        vehicle = GetPlayerVehicle(arg2)
        SetVehicleColor(vehicle, "0x"..arg3)
        RemovePlayerCash(arg2, 1000)

        query = mariadb_async_query(sql, mariadb_prepare(sql, "UPDATE `player_garage` SET `color` = '?' WHERE `id` = ?;", 
        tostring(arg3),
        tostring(VehicleData[vehicle].garageid)))
        CallRemoteEvent(arg2, "MakeNotification", "La couleur de votre véhicule a été changer.", "#5DADE2")
    else
        CallRemoteEvent(arg2, "MakeErrorNotification", "Vous n'avez pas asser d'argent sur vous.")
    end
end
AddRemoteEvent("s_ChangeCarColor", s_ChangeCarColor)

function s_ChangeCarPlate(arg1, arg2, arg3)

    local cash = PlayerData[arg2].inventory['cash'] or 0
    if cash >= 5000 then
        vehicle = GetPlayerVehicle(arg2)
        SetVehicleLicensePlate(vehicle, arg3)
        RemovePlayerCash(arg2, 5000)

        mariadb_async_query(sql, mariadb_prepare(sql, "UPDATE `player_garage` SET `license_plate` = '?' WHERE `id` = ?;", 
        tostring(arg3),
        tostring(VehicleData[vehicle].garageid)))
        CallRemoteEvent(arg2, "MakeNotification", "La plaque d'immatriculation de votre véhicule a été changer.", "#5DADE2")
    else
        CallRemoteEvent(arg2, "MakeErrorNotification", "Vous n'avez pas asser d'argent sur vous.")
    end
end
AddRemoteEvent("s_ChangeCarPlate", s_ChangeCarPlate)

AddRemoteEvent("stop_engine", function (player)
    vehicle = GetPlayerVehicle(player)
    StopVehicleEngine(vehicle)
end)

AddRemoteEvent("start_engine", function (player)
    vehicle = GetPlayerVehicle(player)
    StartVehicleEngine(vehicle)
end)

function MoveVehicleToGarage(vehicle, player)
    if vehicle then
        if VehicleData[vehicle].garageid ~= 0 then
            VehicleData[vehicle].health = GetVehicleHealth(vehicle)            
            mariadb_async_query(sql, mariadb_prepare(sql, "UPDATE `player_garage` SET `garage`=1, fuel = ?, health = ?, nitro = ? WHERE `id` = ?;", 
            VehicleData[vehicle].fuel,
            VehicleData[vehicle].health,
            VehicleData[vehicle].nitro,
            tostring(VehicleData[vehicle].garageid)))
        end
        DestroyVehicle(vehicle)
        DestroyVehicleData(vehicle)
        return CallRemoteEvent(player, "MakeNotification", _("vehicle_stored"), "#5DADE2")
    end
end

function spawnCarServer(player, id)
    if tonumber(id) == nil then return end
    local query = mariadb_prepare(sql, "SELECT * FROM player_garage WHERE id = ?;",
    tonumber(id))
    mariadb_async_query(sql, query, spawnCarServerLoaded, player)
end
AddRemoteEvent("spawnCarServer", spawnCarServer)

function spawnCarServerLoaded(player)
    for i=1,mariadb_get_row_count() do
        local result = mariadb_get_assoc(i)

        local id = math.tointeger(result["id"])
        local modelid = math.tointeger(result["modelid"])
        local fuel = math.tointeger(result["fuel"])
        local health = math.tointeger(result["health"])
        local nitro = math.tointeger(result["nitro"])
        if health < 100 then health = 100 end
        local color = tostring(result["color"])
        local licensePlate = tostring(result["license_plate"])        
        local inventory = json_decode(result["inventory"] or "{}") 
        local name = _("vehicle_"..modelid)

        local query = nil
        if licensePlate == "AA-111-AA" or licensePlate == nil or licensePlate == "" then 
            licensePlate = genLicensePlate() 
            query = mariadb_prepare(sql, "UPDATE `player_garage` SET `garage`=0, `license_plate`='?' WHERE `id` = ?;",
                licensePlate,
                tostring(id))
        else
            query = mariadb_prepare(sql, "UPDATE `player_garage` SET `garage`=0 WHERE `id` = ?;",
                tostring(id))
        end

        local x, y, z = GetPlayerLocation(player)

        for k,v in pairs(GarageDealerTable) do
            local x2, y2, z2 = GetNPCLocation(v.npc)
            local dist = GetDistance3D(x, y, z, x2, y2, z2)
            if dist < 150.0 then
                local isSpawnable = true
                for k,w in pairs(GetAllVehicles()) do
                    local x3, y3, z3 = GetVehicleLocation(w)
                    local dist2 = GetDistance3D(v.spawn[1], v.spawn[2], v.spawn[3], x3, y3, z3)
                    if dist2 < 600.0 then
                        isSpawnable = false
                        break
                    end
                end
                if isSpawnable then
                    local vehicle = CreateVehicle(modelid, v.spawn[1], v.spawn[2], v.spawn[3], v.spawn[4])
                    SetVehicleLicensePlate(vehicle, licensePlate)
                    SetVehicleRespawnParams(vehicle, false)
                    SetVehicleColor(vehicle, "0x"..color)
                    SetVehiclePropertyValue(vehicle, "locked", true, true)
                    SetVehiclePropertyValue(vehicle, "fuel", true, fuel)
                    SetVehicleHealth(vehicle, health)
                    if nitro == 1 then AttachVehicleNitro(vehicle , true) end                 
                    CreateVehicleData(player, vehicle, modelid, fuel, health, licensePlate)
                    local percentOfDamage = (1 - (health / 5000)) or 0
                    if percentOfDamage < 0 then percentOfDamage = 0 end
                    if percentOfDamage > 1 then percentOfDamage = 1 end
                    for j = 1, 8 do
                        SetVehicleDamage(vehicle, j, percentOfDamage)                 
                    end
                    VehicleData[vehicle].garageid = id
                    if inventory == nil then
                        inventory = {}
                    end
                    VehicleData[vehicle].inventory = inventory
                    VehicleData[vehicle].nitro = nitro
                    mariadb_async_query(sql, query)
                    CallRemoteEvent(player, "closeGarageDealer")

                    return CallRemoteEvent(player, "MakeNotification", _("spawn_vehicle_success", tostring(name)),"#5DADE2")
                else
                    return CallRemoteEvent(player, "MakeErrorNotification", _("cannot_spawn_vehicle"))
                end
            end
        end
	end
end

-- function sellCarServer(player, id)
--     local query = mariadb_prepare(sql, "SELECT * FROM player_garage WHERE id = ?;",
--     tostring(id))

--     mariadb_async_query(sql, query, sellCarServerLoaded, player)
-- end
-- AddRemoteEvent("sellCarServer", sellCarServer)

-- function sellCarServerLoaded(player)
--     for i=1,mariadb_get_row_count() do
--         local result = mariadb_get_assoc(i)

--         local id = math.tointeger(result["id"])
--         local modelid = math.tointeger(result["modelid"])
--         local name = _("vehicle_"..modelid)
--         local price = math.ceil(result["price"] * 0.25)

--         local query = mariadb_prepare(sql, "DELETE FROM `player_garage` WHERE `id` = ?;", tostring(id))
--         mariadb_async_query(sql, query)
--         AddPlayerCash(player, price)
--         return CallRemoteEvent(player, "MakeNotification", _("sell_vehicle_success", tostring(name), price, _("currency")), "linear-gradient(to right, #00b09b, #96c93d)")
-- 	end
-- end
