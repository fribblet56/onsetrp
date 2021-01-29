AddRemoteEvent("rebel:GetLicense", function ( player )
    if PlayerData[player].rebel_car_license ~= 0 or PlayerData[player].rebel_gun_license ~= 0 then
        CallRemoteEvent(player, "rebel:Setup", 1)
    end
end)

local function RebelCuffPlayer(player)
    
    local target = GetNearestPlayer(player, 200)
    if target ~= nil and PlayerData[target].is_cuffed == 0 then
        if GetNumberOfItem(player, "handcuffs") > 0 then
            RemoveInventory(player, "handcuffs", 1)
            RebelSetPlayerCuffed(target, true)            
            CallRemoteEvent(player, "MakeNotification", "Joueur menotter, vous pouvez maintenant accéder a son inventaire via les inventaires proche.", "#5DADE2")
            CallRemoteEvent(target, "MakeNotification", "Vous avez été menotter.", "#E74C3C")
        else
            CallRemoteEvent(player, "MakeErrorNotification", _("no_handcuffs"))
        end
    elseif target ~= nil and PlayerData[target].is_cuffed == 1 then
        RebelSetPlayerCuffed(target, false)
        AddInventory(player, "handcuffs", 1)
        CallRemoteEvent(player, "MakeNotification", "Joueur Démenotter.", "#5DADE2")
        CallRemoteEvent(target, "MakeSuccessNotification", "Vous avez été Démenotter.")
    end
end
AddRemoteEvent("rebel:cuff", RebelCuffPlayer)

function RebelSetPlayerCuffed(player, state)

    if state == true then
        -- # Empty the weapons shortcuts
        SetPlayerWeapon(player, 1, 0, true, 1)
        SetPlayerWeapon(player, 1, 0, false, 2)
        SetPlayerWeapon(player, 1, 0, false, 3)
        -- # Launch the cuffed animation
        SetPlayerAnimation(player, "CUFF")
        -- # Disable most of interactions
        SetPlayerBusy(player)
        -- # Set player as cuffed
        PlayerData[player].is_cuffed = 1
        -- # Set property value
        SetPlayerPropertyValue(player, "cuffed", true, true)
    else
        SetPlayerAnimation(player, "STOP")
        SetPlayerNotBusy(player)
        PlayerData[player].is_cuffed = 0
        SetPlayerPropertyValue(player, "cuffed", false, true)
    end
end

function RebelPutPlayerInCar(player, StreamedVehicles)
    
    local target = GetNearestPlayer(player, 200)
    if target ~= nil then
        RebelSetPlayerInCar(player, target, StreamedVehicles)
    end
end
AddRemoteEvent("rebel:playerincar", RebelPutPlayerInCar)

function RebelSetPlayerInCar(player, target, StreamedVehicles)

    local x2, y2, z2 = GetPlayerLocation(target)

    for k,v in pairs(StreamedVehicles) do
        local x, y, z = GetVehicleLocation(v)
        
        if GetDistance3D(x, y, z, x2, y2, z2) <= 400 then
            if GetVehiclePassenger(v, 3) == 0 then -- First back seat
                SetPlayerInVehicle(target, v, 3)
                CallRemoteEvent(player, "MakeNotification", "Le joueur a été placer à l'arrière du véhicule.", "#5DADE2")
            elseif GetVehiclePassenger(v, 4) == 0 then -- Second back seat
                SetPlayerInVehicle(target, v, 4)
                CallRemoteEvent(player, "MakeNotification", "Le joueur a été placer à l'arrière du véhicule.", "#5DADE2")
            else -- All seats are busy
                CallRemoteEvent(player, "MakeErrorNotification", "Il n'y a plus de place dans ce véhicule.")
            end
        else -- Too far away
            CallRemoteEvent(player, "MakeErrorNotification", "Le Joueur est trop loin.")
        end
    end
end

function RebelRemovePlayerInCar(player, StreamedVehicles)

    local x2, y2, z2 = GetPlayerLocation(player)

    for k,v in pairs(StreamedVehicles) do
        local x, y, z = GetVehicleLocation(v)
    
        if GetDistance3D(x, y, z, x2, y2, z2) <= 300 then
            if GetVehiclePassenger(v, 3) ~= 0 then -- First back seat
                RemovePlayerFromVehicle(GetVehiclePassenger(v, 3))
            end
            if GetVehiclePassenger(v, 4) ~= 0 then -- Second back seat
                RemovePlayerFromVehicle(GetVehiclePassenger(v, 4))
            end
            CallRemoteEvent(player, "MakeNotification", "Le joueur a été sorite du véhicule.", "#5DADE2")
        end
    end
end
AddRemoteEvent("rebel:removeplayerincar", RebelRemovePlayerInCar)

function FriskPlayerRebel(player)

    local target = GetNearestPlayer(player, 200)
    if target ~= nil then
        LaunchFriskPlayerRebel(player, target)
    end
end
AddRemoteEvent("rebel:friskplayer", FriskPlayerRebel)

function rebelRemoveVehicle(player)

    local vehicle = GetNearestVehicle(player)
    MoveVehicleToGarage(vehicle, player)
end
AddRemoteEvent("rebel:removevehicle", rebelRemoveVehicle)

local function LaunchFriskPlayerRebel(player, target)

    if GetPlayerPropertyValue(target, "cuffed") ~= true then return end
    
    local x, y, z = GetPlayerLocation(player)
    local nearestPlayers = GetPlayersInRange3D(x, y, z, 200)
    local playerList = {}
    for k, v in pairs(nearestPlayers) do
        if k ~= player then
            local playerName
            if PlayerData[k].accountid ~= nil and PlayerData[k].accountid ~= 0 then playerName = PlayerData[k].accountid else playerName = GetPlayerName(k) end            
            table.insert(playerList, {id = k, name = playerName}) -- On prend le nom affiché (l'accountid)
        end
    end
    
    friskedPlayer = { id = tostring(target), name = PlayerData[tonumber(target)].accountid, inventory = PlayerData[tonumber(target)].inventory }
    CallRemoteEvent(player, "OpenPersonalMenu", Items, PlayerData[target].inventory, PlayerData[target].name, player, playerList, GetPlayerMaxSlots(target), friskedPlayer)
end