local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

EditCarTable = {
    {
        modelid = 2,
        location = {
            { 145324, 177849, 1510 }
        },
        object = {}
    }
}

AddEvent("database:connected", function()
    mariadb_query(sql, "UPDATE `player_garage` SET `garage`=1 WHERE garage = 0;")
end)

AddEvent("OnPackageStart", function()
    for k,v in pairs(EditCarTable) do
        for i,j in pairs(v.location) do
            v.object[i] = CreatePickup(v.modelid , v.location[i][1], v.location[i][2], v.location[i][3])
        end
    end
end)

function OnPlayerPickupHit(player, pickup)
    for k,v in pairs(EditCarTable) do
        for i,j in pairs(v.object) do
            if j == pickup then
                vehicle = GetPlayerVehicle(player)
                seat = GetPlayerVehicleSeat(player)
                if (vehicle ~= 0 and seat == 1) then
                    if (VehicleData[vehicle].owner == PlayerData[player].accountid) then
                        DestroyVehicleData(vehicle, player)
                    end
                end
            end
        end
    end
end
AddEvent("OnPlayerPickupHit", OnPlayerPickupHit)