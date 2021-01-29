local Dialog = ImportPackage("dialogui")

local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local Mission2NpcMenu
local Mission2NpcID = { }

local PlayerMission2List

local Mission2Statu = 0

local Mission2Id = 2


AddRemoteEvent("Mission2Setup", function(Mission2Npc)
    Mission2NpcID = Mission2Npc
end)

function OnKeyPress(key)
    if key == INTERACT_KEY and not GetPlayerBusy() then
        local nearestNpcMission2 = GetNearestMission2Npc()
        if nearestNpcMission2 ~= 0 then
            CallRemoteEvent("Mission2Interact", nearestNpcMission2)
        end
    end
end
AddEvent("OnKeyPress", OnKeyPress)

AddEvent("OnDialogSubmit", function(dialog, button, ...)
    if dialog == Mission2NpcMenu then
        if button == 1 then
            if Mission2Statu == 0 then
                CallRemoteEvent("StartMission2")
                CallRemoteEvent("AddMission2ToPlayer", Mission2Id, 0)
                Mission2Statu = 1

            elseif Mission2Statu == 1 then

                Mission2Statu = 2

                CallRemoteEvent("PlayerEndMission2", "safety_cone", Mission2Id, 1)


            elseif Mission2Statu == 2 then


            end
        end
    end
end)

function GetNearestMission2Npc()
    local x, y, z = GetPlayerLocation()
    for k, npcId in pairs(GetStreamedNPC()) do
        local x2, y2, z2 = GetNPCLocation(npcId)
        local dist = GetDistance3D(x, y, z, x2, y2, z2)

        if dist < 250.0 then
            if npcId == Mission2NpcID then
                return npcId
            end
        end
    end
    return 0
end

AddEvent("OnNPCStreamIn", function(npc)
    if npc == Mission2NpcID then
        SetNPCClothingPreset(npc, 10)
    end
end)

AddRemoteEvent("OpenMission2", function(_titleMission2, _descriptionMission2, _startMission2, _endMission2, _doneMission2, _playermissionMission2)

    PlayerMission2List = _playermissionMission2

    for k, v in pairs(_playermissionMission2) do
        if Mission2Id == v.id then
            if v.statue == 0 then
                Mission2NpcMenu = Dialog.create(_titleMission2, _descriptionMission2, _endMission2, "Cancel")
                MissionStatu = 1
            elseif v.statue == 1 then
                Mission2NpcMenu = Dialog.create(_titleMission2, _doneMission2, "Cancel")
                Mission2Statu = 2
            end
        end
    end

    if Mission2Statu == 0 then
        Mission2NpcMenu = Dialog.create(_titleMission2, _descriptionMission2, _startMission2, "Cancel")
    end

    Dialog.show(Mission2NpcMenu)

end)
