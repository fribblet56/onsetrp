local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local Mission2require_object = {
        objectID = 486,
        title = "Conne de Chantier",
        amount = 1,
        item_name = "safety_cone",
        x = -16380,
        y = -172359,
        z = 5907
}

local Mission2reward = {
    cash = 3000,
    item = "unicorn"
}

local Mission2pickup = {
    { 23432, 145697, 1550}
}

local Mission2Message = {
    npc = "[Aider moi]",
    title = "Mission 2 [limiter]",
    description = "J’ai perdu mon objet fétiche dans le secteur peux tu m’aider à le retrouver ?",
    start = "Je veux bien essayer !",
    finish = "Je l’ai retrouvé !",
    alreadydone = "Tu peux maintenant aller rendre visite a mon amie dans le bunker tu pourras rentrer grâce à ce code [25565] bonne chance voici un petit supplément pour toi tien …"
}

local Mission2NpcValue = { 
    x = -21822, 
    y = -175121, 
    z = 5102, 
    h = -93
}

local Mission2Npc = {}

AddEvent("OnPackageStart", function()
    Mission2Npc = CreateNPC(Mission2NpcValue.x, Mission2NpcValue.y, Mission2NpcValue.z, Mission2NpcValue.h )
    CreateText3D(Mission2Message.npc.."\n".._("press_e"), 18, Mission2NpcValue.x, Mission2NpcValue.y, Mission2NpcValue.z  + 120, 0, 0, 0)
end)

AddEvent("OnPlayerJoin", function(player)
    CallRemoteEvent(player, "Mission2Setup", Mission2Npc)
end)

AddRemoteEvent("PlayerEndMission2", function ( player, _item, _id, _statue)


    if PlayerData[player].inventory[_item] or 0 >= 1 then

        for k, v in pairs(PlayerData[player].mission) do

            if v.id == _id then
                v.statue = _statue
            end

        end

            RemoveInventory(player, Mission2require_object.item_name, 1, 0, player)
            AddInventory(player, Mission2reward.item, 1, player)
            AddPlayerCash(player, Mission2reward.cash)

            CallRemoteEvent(player, "OpenMission2", Mission2Message.title, Mission2Message.description, Mission2Message.start, Mission2Message.finish, Mission2Message.alreadydone, PlayerData[player].mission)

    end


end)

AddRemoteEvent("Mission2Interact", function(player)
    CallRemoteEvent(player, "OpenMission2", Mission2Message.title, Mission2Message.description, Mission2Message.start, Mission2Message.finish, Mission2Message.alreadydone, PlayerData[player].mission)
end)

AddRemoteEvent("StartMission2", function( player )
    CreateObj(
        Mission2require_object.x,
        Mission2require_object.y,
        Mission2require_object.z,
        Mission2require_object.objectID,
        Mission2require_object.title,
        Mission2require_object.amount,
        Mission2require_object.item_name
    )
end)

AddRemoteEvent("AddMission2ToPlayer", function ( player, _id, _statue )

    local Mission2 = {
        id = _id,
        statue = _statue
    }

    table.insert(PlayerData[player].mission, Mission2)
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