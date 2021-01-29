local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local pickupWeedId
local pickupButaneId
local pickupWeedManicureId
local pickupWeedBHOId

AddRemoteEvent("weed:Setup", function(_WeedObjects, _WeedManicureObject, _WeedBHOObject, _ButaneObject)
	pickupWeedId = _WeedObjects
	pickupWeedManicureId = _WeedManicureObject
	pickupWeedBHOId = _WeedBHOObject
	pickupButaneId = _ButaneObject
end)


AddEvent("OnKeyPress", function(key)
    if key == INTERACT_KEY and not GetPlayerBusy() then

        local NearestPickUpWeed = GetNearestPickUpWeed()
        local NearestPickUpWeedManicure = GetNearestPickUpWeedManicure()
        local NearestPickUpWeedBHO = GetNearestPickUpWeedBHO()
        local NearestPickUpButane = GetNearestPickUpButane()

		if NearestPickUpWeed ~= 0 then
			CallRemoteEvent("weed:startRecolting")
		elseif NearestPickUpWeedManicure ~= 0 then
			CallRemoteEvent("weed:startManicuring")
		elseif NearestPickUpWeedBHO ~= 0 then
			CallRemoteEvent("weed:startRaffin")
		elseif NearestPickUpButane ~= 0 then
			CallRemoteEvent("weed:TimerCops")
			CallRemoteEvent("weed:startPickupButane")
		end
	end
end)

function GetNearestPickUpWeed()
	local x, y, z = GetPlayerLocation()

	for k,v in pairs(GetStreamedPickups()) do
		local x2, y2, z2 = GetPickupLocation(v)

		local dist = GetDistance3D(x, y, z, x2, y2, z2)

		if dist < 400.0 then
            for k,i in pairs(pickupWeedId) do
				if v == i then
					return v
				end
			end
		end

	end

	return 0
end

function GetNearestPickUpButane()
	local x, y, z = GetPlayerLocation()

	for k,v in pairs(GetStreamedPickups()) do
		local x2, y2, z2 = GetPickupLocation(v)

		local dist = GetDistance3D(x, y, z, x2, y2, z2)

		if dist < 400.0 then
            for k,i in pairs(pickupButaneId) do
				if v == i then
					return v
				end
			end
		end

	end

	return 0
end

function GetNearestPickUpWeedManicure()
	local x, y, z = GetPlayerLocation()

	for k,v in pairs(GetStreamedPickups()) do
		local x2, y2, z2 = GetPickupLocation(v)

		local dist = GetDistance3D(x, y, z, x2, y2, z2)

		if dist < 100.0 then
            for k,i in pairs(pickupWeedManicureId) do
				if v == i then
					return v
				end
			end
		end
	end

	return 0
end

function GetNearestPickUpWeedBHO()
	local x, y, z = GetPlayerLocation()

	for k,v in pairs(GetStreamedPickups()) do
		local x2, y2, z2 = GetPickupLocation(v)

		local dist = GetDistance3D(x, y, z, x2, y2, z2)

		if dist < 100.0 then
            for k,i in pairs(pickupWeedBHOId) do
				if v == i then
					return v
				end
			end
		end
	end

	return 0
end