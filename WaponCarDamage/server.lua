AddEvent("OnPlayerWeaponShot", function(player, weapon, hittype, hitid, hitX, hitY, hitZ, startX, startY, normalX, normalY, normalZ)
	if (hittype == HIT_VEHICLE) then

		local carId = GetVehicleModel(hitid)
		local carHealt = GetVehicleHealth(hitid)
		local damageValue = 200

		if carId == 13 or carId == 14 or carId == 15 or carId == 16 or carId == 21 then
			damageValue = 70
		elseif carId == 20 or carId == 10 then
			damageValue = 160
		elseif carId == 3 then
			damageValue = 160
		end

		if weapon < 6 and weapon > 1 then
			damageValue = damageValue * 0.5
		end

		SetVehicleHealth(hitid, carHealt - damageValue)
	end
end)