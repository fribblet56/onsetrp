local pickUpList_c = {}
local playerNearestList = {}
local step = 0

AddRemoteEvent("braco:setup", function ( _PickUpList )
	pickUpList_c = _PickUpList
end)

AddRemoteEvent("braco:changeStep", function (  )
	step = step + 1
end)

AddEvent("OnKeyPress", function(key)
    if key == INTERACT_KEY and not GetPlayerBusy() then

        local NearestPlayer = GetNearestPlayer()
        CallRemoteEvent("braco:start", playerNearestList)

		if NearestPlayer ~= 0 then
			if step == 0 then
				CallRemoteEvent("braco:start", playerNearestList)
			end
		else
			AddPlayerChat("Pas assez de monde.")
		end
	end
end)

function GetNearestPlayer()
	local x, y, z = GetPlayerLocation()

	local playerInZone = 1

	for k,v in pairs(GetStreamedPickups()) do
		local x2, y2, z2 = GetPickupLocation(v)

		local dist1 = GetDistance3D(x, y, z, x2, y2, z2)

		if dist1 < 400.0 then
            for k,i in pairs(pickUpList_c) do
				if v == i then
					for k,j in pairs(GetStreamedPlayers()) do
						local x3, y3, z3 = GetPlayerLocation(v)

						local dist2 = GetDistance3D(x, y, z, x3, y3, z3)

						if dist < 400.0 then
							playerInZone = playerInZone + 1
							table.insert(playerNearestList, GetPlayerId(v))
						end

					end
				end
			end
		end

	end 

	if playerInZone >= 0 then
		return 1
	else
		return 0
	end
end

function GetNearestCutDoor()
	local x, y, z = GetPlayerLocation()

	for k,v in pairs(GetNearestDoor()) do
		local x2, y2, z2 = GetDoorLocation(v)

		local dist1 = GetDistance3D(x, y, z, x2, y2, z2)

		if dist1 < 100.0 then
            return v
		end

	end 

	return 0
end