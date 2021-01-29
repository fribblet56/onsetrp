
EnterPoint = {
    {
        modelid = 2,
        location = {
            { 189365, 209032, 1308, 189450}
        },
        object = {}
    }
}

ExitPoint = {
    {
        modelid = 2,
        location = {
            { 189332, 208090, 1308, 189450 }
        },
        object = {}
    }
}

 AddEvent("OnPackageStart", function()
    for k,v in pairs(EnterPoint) do
        for i,j in pairs(v.location) do
            v.object[i] = CreatePickup(v.modelid , v.location[i][1], v.location[i][2], v.location[i][3])

            table.insert(GarageStoreObjectsCached, v.object[i])
        end
	end

	for k,v in pairs(ExitPoint) do
        for i,j in pairs(v.location) do
            v.object[i] = CreatePickup(v.modelid , v.location[i][1], v.location[i][2], v.location[i][3])

            table.insert(GarageStoreObjectsCached, v.object[i])
        end
	end
end)

function OnPlayerPickupHit(player, pickup)
    for k,v in pairs(EnterPoint) do
        for i,j in pairs(v.object) do
            if j == pickup then
            	for r,o in pairs(ExitPoint) do
                    local inVehicle = GetPlayerVehicle(player)
                    if inVehicle == 0 then
                        AddPlayerChat(player, o.location[i][1])
                        SetPlayerLocation ( player ,  o.location[i][4],  o.location[i][2] , o.location[i][3] )
                    end
            	end
            end
		end
	end
    for k,v in pairs(ExitPoint) do
        for i,j in pairs(v.object) do
            if j == pickup then
            	for r,o in pairs(EnterPoint) do
                    local inVehicle = GetPlayerVehicle(player)
                    if inVehicle == 0 then
                        AddPlayerChat(player, o.location[i][1])
                        SetPlayerLocation ( player ,  o.location[i][4] ,  o.location[i][2] , o.location[i][3] )
                    end
            	end
            end
        end
    end
end
AddEvent("OnPlayerPickupHit", OnPlayerPickupHit)