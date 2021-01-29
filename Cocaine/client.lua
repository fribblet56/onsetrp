local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local pickupCocaineId
local pickupAcetoneId
local pickupCocaine1
local pickupCocaine2

AddRemoteEvent("Cocaine:Setup", function(_CocaineObjects, _Cocaine1Object, _Cocaine2Object, _AcetoneObject)
	pickupCocaineId = _CocaineObjects
	pickupCocaine1 = _Cocaine1Object
	pickupCocaine2 = _Cocaine2Object
	pickupAcetoneId = _AcetoneObject
end)


AddEvent("OnKeyPress", function(key)
    if key == INTERACT_KEY and not GetPlayerBusy() then

        local NearestPickUpCocaine = GetNearestPickUpCocaine()
        local NearestPickUpCocaine1 = GetNearestPickUpCocaine1()
        local NearestPickUpCocaine2 = GetNearestPickUpCocaine2()
        local NearestPickUpAcetone = GetNearestPickUpAcetone()

		if NearestPickUpCocaine ~= 0 then
			CallRemoteEvent("Cocaine:startRecolting")
		elseif NearestPickUpCocaine1 ~= 0 then
			CallRemoteEvent("Cocaine:startManicuring")
		elseif NearestPickUpCocaine2 ~= 0 then
			CallRemoteEvent("Cocaine:startRaffin")
		elseif NearestPickUpAcetone ~= 0 then
			CallRemoteEvent("Cocaine:TimerCops")
			CallRemoteEvent("Cocaine:startPickupAcetone")
		end
	end
end)

function GetNearestPickUpCocaine()
	local x, y, z = GetPlayerLocation()

	for k,v in pairs(GetStreamedPickups()) do
		local x2, y2, z2 = GetPickupLocation(v)

		local dist = GetDistance3D(x, y, z, x2, y2, z2)

		if dist < 400.0 then
            for k,i in pairs(pickupCocaineId) do
				if v == i then
					return v
				end
			end
		end

	end

	return 0
end

function GetNearestPickUpAcetone()
	local x, y, z = GetPlayerLocation()

	for k,v in pairs(GetStreamedPickups()) do
		local x2, y2, z2 = GetPickupLocation(v)

		local dist = GetDistance3D(x, y, z, x2, y2, z2)

		if dist < 1200.0 then
            for k,i in pairs(pickupAcetoneId) do
				if v == i then
					return v
				end
			end
		end

	end

	return 0
end

function GetNearestPickUpCocaine1()
	local x, y, z = GetPlayerLocation()

	for k,v in pairs(GetStreamedPickups()) do
		local x2, y2, z2 = GetPickupLocation(v)

		local dist = GetDistance3D(x, y, z, x2, y2, z2)

		if dist < 100.0 then
            for k,i in pairs(pickupCocaine1) do
				if v == i then
					return v
				end
			end
		end
	end

	return 0
end

function GetNearestPickUpCocaine2()
	local x, y, z = GetPlayerLocation()

	for k,v in pairs(GetStreamedPickups()) do
		local x2, y2, z2 = GetPickupLocation(v)

		local dist = GetDistance3D(x, y, z, x2, y2, z2)

		if dist < 100.0 then
            for k,i in pairs(pickupCocaine2) do
				if v == i then
					return v
				end
			end
		end
	end

	return 0
end