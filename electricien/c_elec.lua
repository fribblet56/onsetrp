local Dialog = ImportPackage("dialogui")
local _ = function(k, ...) return ImportPackage("i18n").t(GetPackageName(), k, ...) end

positionPickup = {
	x = 0,
	y = 0,
	z = 0
}

local Waypoint = {}

local PnjCash = {}

local IsOnDuty = false

AddRemoteEvent("elec:Setup", function ( _PnJ )
	PnjCash = _PnJ
end)

AddRemoteEvent("elec:client:isonduty", function(isOnDuty)
    IsOnDuty = isOnDuty
end)

AddRemoteEvent("elec:Update", function ( x, y, z )
	Waypoint = CreateWaypoint(x, y, z, "Transformateur a remettre en état")
	positionPickup.x = x
	positionPickup.y = y
	positionPickup.z = z

end)

AddEvent("OnKeyPress", function(key)
    if key == INTERACT_KEY and not GetPlayerBusy() then

        local NearestPickUpTransfo = GetNearestPickUpTransfo()

		if NearestPickUpTransfo ~= 0 then
			CallRemoteEvent("elec:Repar")
		end
	end

	if key == INTERACT_KEY and not GetPlayerBusy() and GetNearestElecNpc() ~= 0 then
        StartServiceConversationElec(GetNearestElecNpc())
    end

end)

function StartServiceConversationElec(npc)
    
    local message = (IsOnDuty and "Alors c'est l'heure de la pause ?" or "C'est l'heure de prendre soin de notre réseau électrique ?")
    startCinematic({
        title = "Chef électricien",
        message = message,
        actions = {
            {
                text = _("yes"),
                callback = "elec:startstopcinematic"
            },
            {
                text = _("no"),
                close_on_click = true
            }
        }
    }, npc, "WAVE")
end

AddEvent("elec:startstopcinematic", function()
        
        local message = (IsOnDuty and "A plus tard." or "Aller au travail, bon courage et n'oublie pas ta boite à outils !")
        updateCinematic({
            message = message
        }, NearestPolice, "WALLLEAN04")
        Delay(1500, function()
            stopCinematic()
        end)
        CallRemoteEvent("elec:startstopservice")
end)

AddRemoteEvent("elec:DeletWaypoint", function (  )
	DestroyWaypoint(Waypoint)
end)


function GetNearestPickUpTransfo()
	local x, y, z = GetPlayerLocation()

	for k,v in pairs(GetStreamedPickups()) do
		local x2, y2, z2 = GetPickupLocation(v)

		local dist = GetDistance3D(x, y, z, positionPickup.x, positionPickup.y, positionPickup.z)

		if dist < 400.0 then
            return 1
		end

	end

	return 0
end

function GetNearestElecNpc()
	local x, y, z = GetPlayerLocation()
	for k, npcId in pairs(GetStreamedNPC()) do
        local x2, y2, z2 = GetNPCLocation(npcId)
		local dist = GetDistance3D(x, y, z, x2, y2, z2)

		if dist < 250.0 then
            if npcId == PnjCash then
                return npcId
            end
		end
	end
	return 0
end