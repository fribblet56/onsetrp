local Dialog = ImportPackage("dialogui")

local MissionNpcId = {}
local MissionListId = {}

local MissionNpcMenu = {}

local MissionId
local MissionStatu = 0

AddRemoteEvent("mission:Setup", function ( _NpcList, _MissionList )
	MissionNpcId = _NpcList
	MissionListId = _MissionList
end)

AddRemoteEvent("mission:UpdateMissionList_c", function ( _MissionPlayer )
	MissionPlayerId = json_decode_MissionPlayer
end)

AddRemoteEvent("mission:OpenMission", function(_MissionInfos, _playermission, _MissionId)

    for k, v in pairs(_playermission) do
        if _MissionId == v.id then
            if v.statue == 0 then
                MissionNpcMenu = Dialog.create(_MissionInfos.title, _MissionInfos.description, _MissionInfos.finish, "Cancel")
                MissionId = _MissionId
                MissionStatu = 1
                Dialog.show(MissionNpcMenu)
                break
            elseif v.statue == 1 then
                MissionNpcMenu = Dialog.create(_MissionInfos.title, _MissionInfos.alreadydone, "Cancel")
                MissionId = _MissionId
                MissionStatu = 2
                Dialog.show(MissionNpcMenu)
                break
            end
        end
    end

    if MissionStatu == 0 then
        MissionId = _MissionId
        MissionNpcMenu = Dialog.create(_MissionInfos.title, _MissionInfos.description, _MissionInfos.start, "Cancel")

        Dialog.show(MissionNpcMenu)
    end

end)

AddEvent("OnDialogSubmit", function(dialog, button)
    if dialog == MissionNpcMenu then
        if button == 1 then
            if MissionStatu == 0 then
                CallRemoteEvent("mission:PlayerStart", MissionId)
                CallRemoteEvent("mission:AddMissionToPlayer", MissionId, 0)

            elseif MissionStatu == 1 then

                MissionStatu = 2

                CallRemoteEvent("mission:PlayerEnd", MissionId, 1)

            elseif MissionStatu == 2 then


            end

            MissionId = nil
            MissionStatu = nil
        end
    end
end)

function OnKeyPress(key)
    if key == INTERACT_KEY and not GetPlayerBusy() then
        CallRemoteEvent("mission:InteractNpc")
    end
end
AddEvent("OnKeyPress", OnKeyPress)