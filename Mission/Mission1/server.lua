local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

Mission1require_object = {
    objectID = 551,
    title = "Repare Kit",
    amount = 1,
    item_name = "repair_kit",
    x = 184516,
    y = 213361,
    z = 1292
}

reward = {
    cash = 3000,
    item = "lumberjack_axe"
}

Mission1pickup = {
    { 23432, 145697, 1550}
}

Mission1Message = {
    npc = "[Aider moi]",
    title = "Mission 1",
    description = "Pourait tu retrouver mon repare kit ?",
    start = "Je peux essayer !",
    finish = "Je les retrouver !",
    alreadydone = "Merci beaucoup pour la dernier fois !"
}

Mission1NpcLocation = { x = 185352, y = 214553, z = 1317, h = -90 }

Mission1Npc = {}

AddEvent("OnPackageStart", function()
    Mission1Npc = CreateNPC(Mission1NpcLocation.x, Mission1NpcLocation.y, Mission1NpcLocation.z, Mission1NpcLocation.h )
    CreateText3D(Mission1Message.npc.."\n".._("press_e"), 18, Mission1NpcLocation.x, Mission1NpcLocation.y, Mission1NpcLocation.z  + 120, 0, 0, 0)
end)

AddEvent("OnPlayerJoin", function(player)
    CallRemoteEvent(player, "Mission1Setup", Mission1Npc)
end)

AddRemoteEvent("PlayerEndMission1", function ( player, _item, _id, _statue)


    if PlayerData[player].inventory[_item] or 0 >= 1 then

        for k, v in pairs(PlayerData[player].mission) do

            if v.id == _id then
                v.statue = _statue
            end

        end

            RemoveInventory(player, Mission1require_object.item_name, 1, 0, player)
            AddInventory(player, reward.item, 1, player)
            AddPlayerCash(player, reward.cash)

    end


end)

AddRemoteEvent("Mission1Interact", function(player)
    CallRemoteEvent(player, "OpenMission1", Mission1Message.title, Mission1Message.description, Mission1Message.start, Mission1Message.finish, Mission1Message.alreadydone, PlayerData[player].mission)
end)

AddRemoteEvent("StartMission1", function( player )
    CreateObj(
        Mission1require_object.x,
        Mission1require_object.y,
        Mission1require_object.z,
        Mission1require_object.objectID,
        Mission1require_object.title,
        Mission1require_object.amount,
        Mission1require_object.item_name
    )
end)

AddRemoteEvent("AddMission1ToPlayer", function ( player, _id, _statue )

    Mission = {
        id = _id,
        statue = _statue
    }

    table.insert(PlayerData[player].mission, Mission)
end)

AddEvent("OnNPCDamage", function(npc)
    SetNPCHealth( npc, 100 )
end)

function CreateObj( x, y, z, ObjectID, text , amount, item)
    object = CreateObject(ObjectID, x, y, z - 100)
    textObj = CreateText3D(text.." x"..amount, 15, x, y, z, 0,0,0)
    SetObjectPropertyValue(object, "isitem", true, true)
    SetObjectPropertyValue(object, "collision", false, true)
    SetObjectPropertyValue(object, "item", item, true)
    SetObjectPropertyValue(object, "amount", amount, true)
    SetObjectPropertyValue(object, "textid", textObj)
end