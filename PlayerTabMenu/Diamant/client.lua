local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end
local Dialog = ImportPackage("dialogui")

local pointDiamId
local pointTraitementId
local DiamNpcJob_c = { }

local dimaMine = {-98602, 81335, 222}

local IsOnDuty = false

AddRemoteEvent("diam:Setup", function(_DiamObjects, _DiamSpawnNpcJob, _DiamTraitementObjects)
	pointDiamId = _DiamObjects
	DiamNpcJob_c = _DiamSpawnNpcJob
	pointTraitementId = _DiamTraitementObjects
end)

AddRemoteEvent("diam:client:isonduty", function(isOnDuty)
    IsOnDuty = isOnDuty
end)


AddEvent("OnKeyPress", function(key)
    if key == INTERACT_KEY and not GetPlayerBusy() then

        local NearestDiamPoint, SelectDiamId = GetNearestDiamPoint()
        local NearestDiamTraitementPoint = GetNearestDiamTraitementPoint()

		if NearestDiamPoint == 1 then
			CallRemoteEvent("diam:startRecolting", SelectDiamId)
		end

		if NearestDiamPoint == 2 then
			Dialog.show(DiamNpcMenuJob)
		end

		if NearestDiamPoint == 3 then
			Dialog.show(DiamNpcMenuSell)
		end

		if NearestDiamTraitementPoint == 1 then
			CallRemoteEvent("diam:startRaffin")
		end
	end

	if key == INTERACT_KEY and not GetPlayerBusy() and GetNearestDiamNpc() ~= 0 then
        StartServiceConversationDiam(GetNearestDiamNpc())
    end
end)

function StartServiceConversationDiam(npc)
    
    local message = (IsOnDuty and "Alors c'est l'heure de la pause ?" or "C'est l'heure de briser de la roche ?")
    startCinematic({
        title = "Chef Diamantaire",
        message = message,
        actions = {
            {
                text = _("yes"),
                callback = "diam:startstopcinematic"
            },
            {
                text = _("no"),
                close_on_click = true
            }
        }
    }, npc, "WAVE")
end

AddEvent("diam:startstopcinematic", function()
        
        local message = (IsOnDuty and "A plus tard." or "Aller au travail, bon courage et n'oublie pas ta pioche !")
        updateCinematic({
            message = message
        }, NearestPolice, "WALLLEAN04")
        Delay(1500, function()
            stopCinematic()
        end)
        CallRemoteEvent("diam:startstopservice")
end)

AddRemoteEvent("Diam:SoundPlay", function ( value )
	local x,y,z = GetPlayerLocation()

	if value == 1 then
		CreateSound("chemistry.mp3")
	else
		CreateSound("chemistry.mp3")
	end
end)

function GetNearestDiamNpc()
	local x, y, z = GetPlayerLocation()
	for k, npcId in pairs(GetStreamedNPC()) do
        local x2, y2, z2 = GetNPCLocation(npcId)
		local dist = GetDistance3D(x, y, z, x2, y2, z2)

		if dist < 250.0 then
            if npcId == DiamNpcJob_c then
                return npcId
            end
		end
	end
	return 0
end


function GetNearestDiamTraitementPoint()
	local x, y, z = GetPlayerLocation()

	for k,v in pairs(GetStreamedPickups()) do
		local x2, y2, z2 = GetPickupLocation(v)

		local dist = GetDistance3D(x, y, z, x2, y2, z2)

		if dist < 250.0 then
            for k,i in pairs(pointTraitementId) do
				if v == i then
					return 1
				end
			end
		end

	end

	return 0
end

function GetNearestDiamPoint()
	local x, y, z = GetPlayerLocation()

	local dist = GetDistance3D(x, y, z, dimaMine[1], dimaMine[2], dimaMine[3])

	if dist < 2000.0 then
		for k,v in pairs(pointDiamId) do
			local x2, y2, z2 = GetObjectLocation(k)
			local dist2 = GetDistance3D(x, y, z, x2, y2, z2)

			if dist2 < 220 then
				return 1, k
			end
		end
	end

	return 0
end