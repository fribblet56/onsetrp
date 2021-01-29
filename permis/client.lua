local _ = function(k, ...) return ImportPackage("i18n").t(GetPackageName(), k, ...) end

local permisUI
local monitorUI

local permisPnjCash = {}

local permisWaypointCash

local WaypointPermis = {}

local vehicleStatu = 0

local Timer = {}

local PermisPoint = 5
local PermisSpeed = 65

StatutPermis = false

AddEvent("OnPackageStart", function()
    permisUI = CreateWebUI(0.0, 0.0, 0.0, 0.0, 1, 60)
    SetWebAnchors(permisUI, 0.0, 0.0, 1.0, 1.0)
    LoadWebFile(permisUI, 'http://asset/' .. GetPackageName() .. '/permis/index.html')
    SetWebVisibility(permisUI, WEB_HIDDEN)

    monitorUI = CreateWebUI(0.0, 0.0, 0.0, 0.0, 1, 60)
    SetWebAnchors(monitorUI, 0.0, 0.0, 1.0, 1.0)
    LoadWebFile(monitorUI, 'http://asset/' .. GetPackageName() .. '/permis/monitor.html')
    SetWebVisibility(monitorUI, WEB_HIDDEN)
end)

AddRemoteEvent("permis:Setup", function ( _PnJ )
	permisPnjCash = _PnJ
end)

AddRemoteEvent("permis:StatutPermis", function ( value )
	StatutPermis = value
end)

AddEvent("OnKeyPress", function(key)

	if key == INTERACT_KEY and not GetPlayerBusy() and GetNearestpermisNpc() ~= 0 then
        SetWebVisibility(permisUI, WEB_VISIBLE)
		SetIgnoreLookInput(true)
	    SetIgnoreMoveInput(true)
	    ShowMouseCursor(true)
    end

    if key == VEHICLE_ENGINE_KEY and not GetPlayerBusy() and StatutPermis == true and vehicleStatu == 0 then
    	MakeNotification("Suivre le parcourt sans dépasser la limitation de vitesse.", "#5DADE2", 5000)
    	CallRemoteEvent("permis:StartDrive")
    	vehicleStatu = 1
    	Timer = CreateTimer(function ( )
    		local carspeed = math.floor(GetVehicleForwardSpeed(GetPlayerVehicle()))

    		if (carspeed - 5) > PermisSpeed then
    			if (PermisPoint - 1) ~= 0 then
    				PermisPoint = PermisPoint - 1
    				UpdateMonitorUiPoint(PermisPoint)
    				MakeNotification("Attention à la vitesse malheureux !", "#EC7063", 5000)
                    CallRemoteEvent("permis:losepoint")
    			else
    				PermisPoint = 0
    				DestroyTimer(Timer)
    				CallRemoteEvent("permis:lose")
    				MakeNotification("Vous n'avez pas eu votre permis de conduire.", "#EC7063", 5000)
    			end
    		end
    	end, 3000)
    end

end)

AddEvent("OnPlayerLeaveVehicle", function ( vehicle )
	if StatutPermis == true then
		CallRemoteEvent("permis:StayInCar")
	end
end)

AddRemoteEvent("permis:CreateWaypoint", function ( xA, yA, zA )
	WaypointPermis = CreateWaypoint(xA, yA, zA, "Point suivant")
end)

AddRemoteEvent("permis:DeletWaypoint", function ()
	DestroyWaypoint(WaypointPermis)
end)

AddRemoteEvent("permis:OpenMonitorUi", function ()
	SetWebVisibility(monitorUI, WEB_HITINVISIBLE)
end)

AddRemoteEvent("permis:UpdateMonitorUi", function ( Kmh, Pickup )
	PermisSpeed = tonumber(Kmh)
	ExecuteWebJS(monitorUI, "SetLimitKmh("..Kmh..");")
	ExecuteWebJS(monitorUI, "SetPickup("..Pickup..");")
end)

function UpdateMonitorUiPoint( Point )
	ExecuteWebJS(monitorUI, "SetPoint("..Point..");")
end

AddRemoteEvent("permis:CloseMonitorUi",function ()
	SetWebVisibility(monitorUI, WEB_HIDDEN)
    vehicleStatu = 0
end)

AddEvent("permis:closeGui", function()
	SetWebVisibility(permisUI, WEB_HIDDEN)
	SetIgnoreLookInput(false)
    SetIgnoreMoveInput(false)
    ShowMouseCursor(false)
    SetInputMode(INPUT_GAME)
end)

AddEvent("permis:SetupLicense", function()
	CallRemoteEvent("permis:GetPlayerLicense")
	PermisPoint = 5
	PermisSpeed = 65
    ExecuteWebJS(monitorUI, "SetPickup('1');")
end)

function GetNearestpermisNpc()
	local x, y, z = GetPlayerLocation()
	for k, npcId in pairs(GetStreamedNPC()) do
        local x2, y2, z2 = GetNPCLocation(npcId)
		local dist = GetDistance3D(x, y, z, x2, y2, z2)

		if dist < 250.0 then
            if npcId == permisPnjCash then
                return npcId
            end
		end
	end
	return 0
end