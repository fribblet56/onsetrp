local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

CarDealerObjectsCached = { }

CarDefaultColors = {
	black = "0000",
	red = "FF0000",
	blue = "0000FF",
	green = "00FF00",
	orange = "971900",
	vert_bambou = "001F09",
	marron = "391c00",
	bleu_galaxie = "010026",
	rouge_bordeau = "1f0000",
	rose = "ff15b5",
	jaune = "c9be00",
	turquoise = "00a47c",
	blanc = "ffffff",
	gris_clair = "787878",
	gris_fonce = "262626",
	gris_titanium = "0b0f14",
	violet_fonce = "140019"
}

NeonColors = {
	green = "6ff00",
	pink = "ff00ff",
	yellow = "ffff00",
	blue = "4d4dff",
	red = "fe0001",
	orange = "ff4105",
	purple = "993cf3"

}

ShopCar1 = {
	vehicle_1 = 15000, --Sedan_01
	vehicle_11 = 75000, --Coupe_01
	vehicle_25 = 5000, --Sedan_Classic
	vehicle_19 = 15000 --Sedan_OneColor
}

ShopCar2 = {
	vehicle_4 = 100000, --Sedan_02
	vehicle_5 = 55000, --Sedan_03
	vehicle_6 = 200000, --Nascar_01
	vehicle_12 = 40000 --Rally_01
}

ShopCar3 = {
	vehicle_13 = 80000, --Heavy_01
	vehicle_16 = 80000, --Heavy_04
	vehicle_17 = 200000, --Cargo_Truck_01
	vehicle_26 = 500000 --Helicopter_03
}

ShopCar4 = {
	vehicle_18 = 200000, --Cargo_Truck_02
	vehicle_21 = 130000, --Humvee
	vehicle_14 = 80000 --Heavy_02
}

ShopCar5 = {
	vehicle_10 = 500000 --Helicopter_01
}

ShopCar6 = {
	vehicle_22 = 45000,
	vehicle_17 = 200000,
	vehicle_7 = 70000
}

CarDealerTable = {
	{
		vehicles = ShopCar1,
		colors = CarDefaultColors,
		location = { 189374, 200275, 1309, -100 },
		spawn = { 189405, 199256, 1309, -90 },
		legal = 1
	},
    {
		vehicles = ShopCar2,
		colors = CarDefaultColors,
		location = { 187311, 214080, 1770, -43 },
		spawn = { 188877, 213668, 1790, -90 },
		legal = 1
	},
    {
		vehicles = ShopCar3,
		colors = NeonColors,
		location = { -98084, 193978, 1311, 180 },
		spawn = { -101855, 194467, 1310, 180 },
		legal = 0
	},
    {
		vehicles = ShopCar6,
		colors = CarDefaultColors,
		location = { 162988, 198911, 1285, -180 },
		spawn = { 162562, 197096, 1285, 0 },
		legal = 1
	}
}

AddEvent("OnPackageStart", function()
	for k,v in pairs(CarDealerTable) do
		v.npc = CreateNPC(v.location[1], v.location[2], v.location[3], v.location[4])
		CreateText3D(_("car_dealer").."\n".._("press_e"), 18, v.location[1], v.location[2], v.location[3] + 120, 0, 0, 0)

		table.insert(CarDealerObjectsCached, v.npc)
	end
end)

AddEvent("OnPlayerJoin", function(player)
    CallRemoteEvent(player, "carDealerSetup", CarDealerObjectsCached)
end)

AddRemoteEvent("carDealerInteract", function(player, cardealerobject)
	if PlayerData[player].driver_license == 1 then
		local cardealer = GetCarDealearByObject(cardealerobject)
		
		if cardealer then
			local x, y, z = GetNPCLocation(cardealer.npc)
			local x2, y2, z2 = GetPlayerLocation(player)
			local dist = GetDistance3D(x, y, z, x2, y2, z2)
	
			if dist < 250 then
				for k,v in pairs(CarDealerTable) do
					if cardealerobject == v.npc then
						if v.legal == 0 and PlayerData[player].rebel_car_license == 1 then
							CallRemoteEvent(player, "openCarDealer", v.vehicles, v.colors)
						elseif v.legal == 1 then
							CallRemoteEvent(player, "openCarDealer", v.vehicles, v.colors)
						elseif v.legal == 0 and PlayerData[player].rebel_car_license == 0 then
							CallRemoteEvent(player, "MakeErrorNotification",_("no_driver_license_rebel"))
						end
					end
				end
	
			end
		end
	else
        CallRemoteEvent(player, "MakeErrorNotification",_("no_driver_license"))
	end
end)

function GetCarDealearByObject(cardealerobject)
	for k,v in pairs(CarDealerTable) do
		if v.npc == cardealerobject then
			return v
		end
	end
	return nil
end

function CreateVehicleDatabase(player, vehicle, modelid, color, price, licensePlate)
    local query = mariadb_prepare(sql, "INSERT INTO player_garage (id, ownerid, modelid, color, garage, price, license_plate) VALUES (NULL, '?', '?', '?', '0', '?', '?');",
        tostring(PlayerData[player].accountid),
        tostring(modelid),
        tostring(color),
		tostring(price),
		tostring(licensePlate)
    )

    mariadb_async_query(sql, query, onVehicleCreateDatabase, vehicle)
end

function onVehicleCreateDatabase(vehicle)
    VehicleData[vehicle].garageid = mariadb_get_insert_id()
end

function buyCarServer(player, modelid, color, cardealerobject)
	local name = _(modelid)
	local price = getVehiclePrice(modelid, cardealerobject)
	local color = getVehicleColor(color, cardealerobject)
	local modelid = getVehicleId(modelid)
	local licensePlate = genLicensePlate()

	if price == nil or tonumber(price) > GetPlayerCash(player) then
        CallRemoteEvent(player, "MakeErrorNotification",_("no_money_car"))
    else
        local x, y, z = GetPlayerLocation(player)

        for k,v in pairs(CarDealerTable) do
            local x2, y2, z2 = GetNPCLocation(v.npc)
            local dist = GetDistance3D(x, y, z, x2, y2, z2)
            if dist < 150.0 then
                local isSpawnable = true
                for k,w in pairs(GetAllVehicles()) do
                    local x3, y3, z3 = GetVehicleLocation(w)
                    local dist2 = GetDistance3D(v.spawn[1], v.spawn[2], v.spawn[3], x3, y3, z3)
                    if dist2 < 1000.0 then
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
                    CreateVehicleData(player, vehicle, modelid)
                    CreateVehicleDatabase(player, vehicle, modelid, color, price, licensePlate)
                    RemovePlayerCash(player, price)
                    CallRemoteEvent(player, "closeCarDealer")
                    return CallRemoteEvent(player, "MakeSuccessNotification", _("car_buy_sucess", name, price, _("currency")))
                else
                    return CallRemoteEvent(player, "MakeErrorNotification", _("cannot_spawn_vehicle"))
                end
            end
        end
    end
end
AddRemoteEvent("buyCarServer", buyCarServer)

function genLicensePlate() 
	local plate = ""

	math.randomseed(os.time()) -- Random seed
	-- FIRST 2 LETTERS
	plate = plate .. genPlateRandomLetter(2) .. "-"
	-- 3 MIDDLE NUMBERS
	plate = plate .. genPlateRandomNumber(3) .. "-"
	-- LAST 2 LETTERS
	plate = plate .. genPlateRandomLetter(2)
	return plate	
end

function genPlateRandomLetter(nb)
	if nb == nil then nb = 1 end
	local value = ""
	for i = 1 , nb do
		local rand = string.char(math.random(65,90))
    	value = value .."".. rand
	end	
	return value
end

function genPlateRandomNumber(nb)
	if nb == nil then nb = 1 end
	local value = ""
	for i = 1, nb do
		local rand = tostring(math.random(0,9))
    	value = value .. "" .. rand
	end	
	return value
end