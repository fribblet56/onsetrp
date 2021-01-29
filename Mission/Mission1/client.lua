local Dialog = ImportPackage("dialogui")

local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local Mission1NpcMenu
local Mission1NpcID = { }

local PlayerMissionList

local MissionStatu = 0

local MissionId = 1


AddRemoteEvent("Mission1Setup", function(Mission1Npc)
    Mission1NpcID = Mission1Npc
end)

function OnKeyPress(key)
    if key == INTERACT_KEY and not GetPlayerBusy() then
        local nearestNpc = GetNearestMission1Npc()
        if nearestNpc ~= 0 then
            CallRemoteEvent("Mission1Interact", nearestNpc)
        end
    end
end
AddEvent("OnKeyPress", OnKeyPress)

AddEvent("OnDialogSubmit", function(dialog, button, ...)
    if dialog == Mission1NpcMenu then
        if button == 1 then
            if MissionStatu == 0 then
                CallRemoteEvent("StartMission1")
                CallRemoteEvent("AddMission1ToPlayer", MissionId, 0)

            elseif MissionStatu == 1 then

                MissionStatu = 2

                CallRemoteEvent("PlayerEndMission1", "repair_kit", MissionId, 1)


            elseif MissionStatu == 2 then


            end
        end
    end
end)

function GetNearestMission1Npc()
    local x, y, z = GetPlayerLocation()
    for k, npcId in pairs(GetStreamedNPC()) do
        local x2, y2, z2 = GetNPCLocation(npcId)
        local dist = GetDistance3D(x, y, z, x2, y2, z2)

        if dist < 250.0 then
            if npcId == Mission1NpcID then
                return npcId
            end
        end
    end
    return 0
end

AddRemoteEvent("OpenMission1", function(_title, _description, _start, _end, _done, _playermission)

    PlayerMissionList = _playermission

    for k, v in pairs(_playermission) do
        if MissionId == v.id then
            if v.statue == 0 then
                Mission1NpcMenu = Dialog.create(_title, _description, _end, "Cancel")
                MissionStatu = 1
            elseif v.statue == 1 then
                Mission1NpcMenu = Dialog.create(_title, _done, "Cancel")
                MissionStatu = 2
            end
        end
    end

    if MissionStatu == 0 then
        Mission1NpcMenu = Dialog.create(_title, _description, _start, "Cancel")
    end

    Dialog.show(Mission1NpcMenu)

end)
