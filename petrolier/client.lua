local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local pickupPetroleBrutId
local pickupRaffinerieId
local pickupVenteId

AddRemoteEvent("petrol:Setup", function(_PetroleBrutObjects, _RaffinerieObject, _VenteObject)
	pickupPetroleBrutId = _PetroleBrutObjects
	pickupRaffinerieId = _RaffinerieObject
	pickupVenteId = _VenteObject
end)


AddEvent("OnKeyPress", function(key)
    if key == INTERACT_KEY and not GetPlayerBusy() then
        local NearestPickUpPetroleBrut = GetNearestPickUpPetroleBrut()
        local NearestPickUpRaffinerie = GetNearestPickUpRaffinerie()
        local NearestPickUpVente = GetNearestPickVente()

		if NearestPickUpPetroleBrut ~= 0 then
			CallRemoteEvent("petrol:startRecolting")
		elseif NearestPickUpRaffinerie ~= 0 then
			CallRemoteEvent("petrol:startRaffin")
		elseif NearestPickUpVente ~= 0 then
			CallRemoteEvent("petrol:Sell")
		end
	end
end)

function GetNearestPickUpPetroleBrut()
	local x, y, z = GetPlayerLocation()

	for k,v in pairs(GetStreamedPickups()) do
		local x2, y2, z2 = GetPickupLocation(v)

		local dist = GetDistance3D(x, y, z, x2, y2, z2)

		if dist < 100.0 then
            for k,i in pairs(pickupPetroleBrutId) do
				if v == i then
					return v
				end
			end
		end
	end

	return 0
end

function GetNearestPickUpRaffinerie()
	local x, y, z = GetPlayerLocation()

	for k,v in pairs(GetStreamedPickups()) do
		local x2, y2, z2 = GetPickupLocation(v)

		local dist = GetDistance3D(x, y, z, x2, y2, z2)

		if dist < 100.0 then
            for k,i in pairs(pickupRaffinerieId) do
				if v == i then
					return v
				end
			end
		end
	end

	return 0
end

function GetNearestPickVente()
	local x, y, z = GetPlayerLocation()

	for k,v in pairs(GetStreamedPickups()) do
		local x2, y2, z2 = GetPickupLocation(v)

		local dist = GetDistance3D(x, y, z, x2, y2, z2)

		if dist < 300.0 then
            for k,i in pairs(pickupVenteId) do
				if v == i then
					return v
				end
			end
		end
	end

	return 0
end