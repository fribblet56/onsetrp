local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

EnterPoint = {
    {
        modelid = 2,
        location = {
            { 213620, 156051, 2781, 213500, 156048, 2781, 180 }, -- Hospital toie
            { -174244, 78299, 1978, -174239, 78200, 1978, -90 }, -- Prison
            { -99841, 82995, 180, -99793, 83308, 180 , 90}, --Mine
            { 46393, 48156, 3061, 46353, 47968, 3029, -90}, --Bunker
            { 189362, 208909, 1308, 189355, 209012, 1308, 90 }, --Gouvernement
            { 146243, 185301, 1716 , 146237, 185425, 1779, 90 }, -- Gragiste
            { 191935, 198357, 1309, 191933, 198253, 1309, -90}, -- Habille chapeau
            { 115279, 70719, 1430, 115288, 70864, 1430, 90 }, --Box
            { 212121, 158745, 1322, 212121, 158919, 1305, 90}, -- Hospital
            { 109085, 209147, 1922, 109056, 209242, 1922, 90}, --boite Tp 1
            { 108726, 209071, 1922, 108701, 209176, 1922, 90}, --boite Tp 1
            { 109450, 209224, 1922, 109436, 209354, 1922, 90}, --boite Tp 1
            { 108739, 209075, 3964, 108696, 209207, 3964, 90} --boite Tp 1
        },
        object = {}
    }
}

ExitPoint = {
    {
        modelid = 2,
        location = {
            { 214860, 156696, 3145, 214770, 156690, 3145, -180},  -- Hospital toie
            { -174244, 78500, 1978, -174212, 78617, 1978, 90 }, -- Prison
            { -98219, 80525, 222, -98236, 80664, 222, 90 }, --Mine
            { 46494, 48159, 2250, 46293, 48163, 2265, 180 }, --Bunker
            { 189371, 208471, 1320, 189371, 208371, 1320, -90}, --Gouvernement
            { 146242, 185104, 1736, 146242, 184993, 1778, -90 }, -- Grargiste
            { 191931, 198645, 1309, 191932, 198749, 1310, 90}, -- Habille chapeau
            { 115432, 70320, 1452, 115420, 70169, 1452, -90 }, --Box
            { 213666, 156049, 2431, 213561, 156045, 2431, 180}, -- Hospital
            { 108735, 209075, 3406, 108711, 209205, 3406, 90}, --boite Tp 1
            { 109455, 209225, 2275, 109423, 209346, 2275, 90}, --boite Tp 1
            { 108732, 209073, 2846, 108708, 209208, 2846, 90}, --boite Tp 1
            { 109093, 209149, 3406, 109066, 209257, 3406, 90} --boite Tp 1
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
                        SetPlayerLocation ( player ,  o.location[i][4],  o.location[i][5] , o.location[i][6] )
                        SetPlayerHeading(player, o.location[i][7])
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
                        SetPlayerLocation ( player ,  o.location[i][4] ,  o.location[i][5] , o.location[i][6] )
                        SetPlayerHeading(player, o.location[i][7])
                    end
                end
            end
        end
    end
end
AddEvent("OnPlayerPickupHit", OnPlayerPickupHit)