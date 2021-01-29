local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local pickupExtaId
local pickupAmphetId

AddRemoteEvent("Exta:Setup", function(_ExtaObjects, _AmphetObject)
	pickupExtaId = _ExtaObjects
	pickupAmphetId = _AmphetObject
end)


AddEvent("OnKeyPress", function(key)
    if key == INTERACT_KEY and not GetPlayerBusy() then

        local NearestPickUpExta = GetNearestPickUpExta()
        local NearestPickUpAmphet = GetNearestPickUpAmphet()

		if NearestPickUpExta ~= 0 then
			CallRemoteEvent("Exta:startRaffin")
		elseif NearestPickUpAmphet ~= 0 then
			CallRemoteEvent("Exta:TimerCops")
			CallRemoteEvent("Exta:startPickupAmphet")
		end
	end
end)

function GetNearestPickUpExta()
	local x, y, z = GetPlayerLocation()

	for k,v in pairs(GetStreamedPickups()) do
		local x2, y2, z2 = GetPickupLocation(v)

		local dist = GetDistance3D(x, y, z, x2, y2, z2)

		if dist < 400.0 then
            for k,i in pairs(pickupExtaId) do
				if v == i then
					return v
				end
			end
		end

	end

	return 0
end

function GetNearestPickUpAmphet()
	local x, y, z = GetPlayerLocation()

	for k,v in pairs(GetStreamedPickups()) do
		local x2, y2, z2 = GetPickupLocation(v)

		local dist = GetDistance3D(x, y, z, x2, y2, z2)

		if dist < 400.0 then
            for k,i in pairs(pickupAmphetId) do
				if v == i then
					return v
				end
			end
		end

	end

	return 0
end