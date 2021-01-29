local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

function OnPlayerChat(player, message)
    -- Region message
    if PlayerData[player].admin == 1 then
        message = '<span style="color: #EC7063">[Admin] '..PlayerData[player].name..'</>: '..message
    else
        message = '<span style="color: #85C1E9">[Joueur] '..PlayerData[player].name..'</>: '..message
    end

    AddPlayerChatAll(message)

    local query = mariadb_prepare(sql, "INSERT INTO logs VALUES (NULL, UNIX_TIMESTAMP(), '?');",
		message)

	mariadb_async_query(sql, query)
end
AddEvent("OnPlayerChat", OnPlayerChat)

-- Global chat
-- AddCommand("g", function(player, ...)
--     local args = { ... }
--     local message = ""
--     for i=1,#args do
--         if i > 1 then
--             message = message.." "
--         end
--         message = message..args[i]
--     end
--     message = '['.._("global")..'] <span>'..GetPlayerName(player)..'('..player..'):</> '..message
--     local query = mariadb_prepare(sql, "INSERT INTO logs VALUES (NULL, NULL, '?');",
-- 		message)

-- 	mariadb_async_query(sql, query)
--     AddPlayerChatAll(message)
-- end)


-- -- Send message to admin
-- AddCommand("/", function(player, ...) 
--     local args = { ... }
--     local message = ""
--     for i=1,#args do
--         if i > 1 then
--             message = message.." "
--         end
--         message = message..args[i]
--     end
--     message = '['.._("admin")..'] <span>'..GetPlayerName(player)..'('..player..'):</> '..message
--     AddPlayerChat(player, message)
--     for k,v in pairs(GetAllPlayers()) do
--         if PlayerData[k].admin == 1 then
--             AddPlayerChat(k, message)
--         end
--     end
--     local query = mariadb_prepare(sql, "INSERT INTO logs VALUES (NULL, NULL, '?');",
-- 		message)

-- 	mariadb_async_query(sql, query)
-- end)

-- -- Private message
-- AddCommand("p", function(player, toplayer, ...)
--     local args = { ... }
--     local message = ""
--     for i=1,#args do
--         if i > 1 then
--             message = message.." "
--         end
--         message = message..args[i]
--     end 
--     message = '['.._("private_message")..'] <span>'..GetPlayerName(player)..'('..player..'):</> '..message
--     AddPlayerChat(player, message)
--     AddPlayerChat(toplayer, message)
-- end)

-- --
-- AddCommand("kill", function(player)
--     SetPlayerHealth(player, 0)
-- end)

AddEvent("OnPlayerJoin", function( player )
    AddPlayerChatAll('<span style="color:#85C1E9;">'..PlayerData[player].name..' a rejoint l\'île</>')
end)

AddCommand("getpos", function(player)
    if PlayerData[player].admin ~= 1 then return end
    local x, y, z = GetPlayerLocation(player)
    AddPlayerChat(player, "X : "..x.." Y : "..y.." Z : "..z)
end)

AddCommand("job", function(player, target, jobname)
    if PlayerData[player].admin ~= 1 then return end
    if target == nil then return end
    
    PlayerData[tonumber(target)].job = jobname
    UpdateClothes(tonumber(target))
    CallRemoteEvent(tonumber(target), "MakeNotification", "Vous êtes maintenant "..jobname, "#5DADE2")

end)

AddCommand("whitelist", function(player, target, id, stat)
    if PlayerData[player].admin ~= 1 then return end

    if tonumber(id) > 3 then return end 
    
    if tonumber(id) == 1 then
        PlayerData[target].police = tonumber(stat)
        CallRemoteEvent(target, "MakeNotification", "Vous êtes maintenant police", "#5DADE2")
    end
    if tonumber(id) == 2 then
        PlayerData[target].medic = tonumber(stat)
        CallRemoteEvent(target, "MakeNotification", "Vous êtes maintenant medic", "#5DADE2")
    end
    if tonumber(id) == 3 then
        PlayerData[target].mechanic = tonumber(stat)
        CallRemoteEvent(target, "MakeNotification", "Vous êtes maintenant mechanic", "#5DADE2")
    end

end)

AddCommand("police", function(player, target, stat)
    if PlayerData[player].admin ~= 1 or PlayerData[player].police > 2 then return end

    if tonumber(id) > 3 then return end 
    
    PlayerData[target].police = tonumber(stat)
    CallRemoteEvent(target, "MakeNotification", "Vous êtes maintenant police de rank "..stat, "#5DADE2")

end)

AddCommand("delcar", function(player)
    if PlayerData[player].admin ~= 1 then return end
        
    local target = GetNearestVehicle(player, 250)

    if target ~= nil then
        if VehicleData[target] == nil then
            DestroyVehicle (target)
        else
            CallRemoteEvent(player, "MakeErrorNotification", "Vous ne pouvez pas supprimer la voiture d'un Joueur.")
        end
    else
        CallRemoteEvent(player, "MakeErrorNotification", "Aucun vehicle")
    end

end)

AddCommand("healcar", function(player)
    if PlayerData[player].admin ~= 1 then return end
        
    local target = GetNearestVehicle(player, 250)

    if target ~= nil then
        SetVehicleHealth(target, 5000)
        for i=1,8 do
            SetVehicleDamage(target, i, 0.0)
        end
        CallRemoteEvent(player, "MakeNotification", "Vehicle Health: 5000", "#5DADE2")
    else
        CallRemoteEvent(player, "MakeErrorNotification", "Aucun vehicle")
    end

end)

AddCommand("nitro", function(player)
    if PlayerData[player].admin ~= 1 then return end
        
    local target = GetNearestVehicle(player, 250)

    if target ~= nil then
            if VehicleData[target].nitro == 1 then
                AttachVehicleNitro(target , false)
                VehicleData[target].nitro = 0
                CallRemoteEvent(player, "MakeNotification", "Nitro: false", "#5DADE2")
            else
                AttachVehicleNitro(target , true)
                VehicleData[target].nitro = 1
                CallRemoteEvent(player, "MakeNotification", "Nitro: true", "#5DADE2")
            end
    else
        CallRemoteEvent(player, "MakeErrorNotification", "Aucun vehicle")
    end

end)

AddCommand("unflip", function(player)
    if PlayerData[player].admin ~= 1 then return end
        
    local target = GetNearestVehicle(player, 250)

    if target ~= nil then

        local rx, ry, rz = GetVehicleRotation(target)

        SetVehicleRotation(target, 0, ry, 0 )

        CallRemoteEvent(player, "MakeNotification", "Vehicle unflip", "#5DADE2")
    else
        CallRemoteEvent(player, "MakeErrorNotification", "Aucun vehicle")
    end

end)

-- AddCommand("bank", function(player)
--     if PlayerData[player].admin ~= 1 then
--         return
--     end
--     SetPlayerLocation(player, 189784.000000, 201549.000000, 835.000000)
-- end)
-- AddCommand("cinema", function(player)
--     if PlayerData[player].admin ~= 1 then
--         return
--     end
--     SetPlayerLocation(player, 173747.000000, 198165.000000, 2532.000000)
-- end)
-- AddCommand("policeplace", function(player)
--     if PlayerData[player].admin ~= 1 then
--         return
--     end
--     SetPlayerLocation(player, 171553.000000, 195234.000000, 572.000000)
-- end)
-- AddCommand("hos1", function(player)
--     if PlayerData[player].admin ~= 1 then
--         return
--     end
--     SetPlayerLocation(player, 215235.000000, 158465.000000, 2960.000000)
-- end)
-- AddCommand("hos2", function(player)
--     if PlayerData[player].admin ~= 1 then
--         return
--     end
--     SetPlayerLocation(player, 212372.000000, 153763.000000, 2793.000000)
-- end)
-- AddCommand("office", function(player)
--     if PlayerData[player].admin ~= 1 then
--         return
--     end
--     SetPlayerLocation(player, 191369.000000, 193415.000000, 9366.000000)
-- end)
-- AddCommand("spec", function(player)
--     if PlayerData[player].admin ~= 1 then
--         return
--     end
--     SetPlayerSpectate( player, true)
-- end)

-- AddCommand("end_spec", function(player)
--     if PlayerData[player].admin ~= 1 then
--         return
--     end
--     SetPlayerSpectate( player, false)
-- end)

AddCommand("tppos", function(player, x, y, z)
    if PlayerData[player].admin ~= 1 then
        return
    end
    SetPlayerLocation(player, x, y, z)
end)

AddCommand( "doorinfo", function( iPlayer )
    local door = false
    local x, y, z = GetPlayerLocation( iPlayer )

    for k, v in pairs( GetAllDoors() ) do
        local x2, y2, z2 = GetDoorLocation( v )

        if GetDistance3D( x, y, z, x2, y2, z2 ) < 200 then
            door = v
        end
    end

    if not door or not IsValidDoor( door ) then
        AddPlayerChat( iPlayer, "No close door found" )
        return 
    end

    local x, y, z = GetDoorLocation( door )

    print( "{ entity = -1, model = " .. GetDoorModel( door ) .. ", x = " .. x .. ", y = " .. y .. ", z = " .. z .. "}")        
end )
