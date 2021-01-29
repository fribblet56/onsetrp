local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

PetroleBrutPickUpCash = { }
RaffineriePickUpCash = { }
VentePickUpCash = { }

PickUpPetroleBrutTable = {
	{
		modelid = 2,
		location = {
			{ 34158, 96739, 1849 },
			{ 34158, 97239, 1849 },
			{ 32550, 96554, 1849 }
	 	},
		object = {}
	}
}

PickUpRaffinerieTable = {
	{
		modelid = 2,
		location = {
			{ 2396, 98031, 1497 }
	 	},
		object = {}
	}
}

PickUpVenteTable = {
	{
		modelid = 2,
		location = {
			{ 145405, 211122, 1307 }
	 	},
		object = {}
	}
}

AddRemoteEvent("petrol:startRecolting", function(player)

	if (GetPlayerUsedSlots(player) + 1) <= GetPlayerMaxSlots(player) then
		SetPlayerBusy(player)
		CallRemoteEvent(player, "LockControlMove", true)
		SetPlayerAnimation(player, "PICKUP_MIDDLE")
		CallRemoteEvent(player,"loadingbar:show","Remplissage d’un baril",10)

		Delay(10000, function ()
			SetPlayerNotBusy(player)
			CallRemoteEvent(player, "LockControlMove", false)
			AddInventory(player, "jerican_gross", 1, player)
			CallRemoteEvent(player, "MakeSuccessNotification", "+1 Bidon de Pétrol Brute.")
			CallRemoteEvent(player,"loadingbar:hide")
		end)
	else
		CallRemoteEvent(player, "MakeErrorNotification", "Vous n'avez pas de place dans votre inventaire.")
	end


end)

function GetNumberOfItem(player, item)
    return PlayerData[player].inventory[item] or 0
end

function GetPlayerMaxSlots(player)
    if PlayerData[player].inventory['item_backpack'] and math.tointeger(PlayerData[player].inventory['item_backpack']) > 0 then
        return math.floor(inventory_base_max_slots + backpack_slot_to_add)
    else
        return inventory_base_max_slots
    end
end

function GetPlayerUsedSlots(player)
    local usedSlots = 0
    for k, v in pairs(PlayerData[player].inventory) do
        if k ~= 'cash' then
            usedSlots = usedSlots + (v * ItemsWeight[k])
        end
    end
    return usedSlots
end

function AddPlayerCash(player, amount)
    AddInventory(player, 'cash', math.tointeger(amount))
end

AddRemoteEvent("petrol:startRaffin", function(player)

	if GetNumberOfItem(player, "jerican_gross") >= 1 then

		if (GetPlayerUsedSlots(player) + 1) <= GetPlayerMaxSlots(player) then 

			RemoveInventory(player, "jerican_gross", 1, 0, player)

			SetPlayerBusy(player)
			CallRemoteEvent(player, "LockControlMove", true)
			SetPlayerAnimation(player, "PICKUP_MIDDLE")

			CallRemoteEvent(player,"loadingbar:show","Raffinage du pétrole",10)

			Delay(10000, function ()
				SetPlayerNotBusy(player)
				CallRemoteEvent(player, "LockControlMove", false)

				AddInventory(player, "jerican_rafined", 1, player)

				CallRemoteEvent(player, "MakeErrorNotification", "-1 Bidon de Pétrol Brute.")
				CallRemoteEvent(player, "MakeSuccessNotification", "+1 Bidon de Pétrol Raffiner")

				CallRemoteEvent(player,"loadingbar:hide")
			end)
		else
			CallRemoteEvent(player, "MakeErrorNotification", "Vous n'avez pas de place dans votre inventaire.")
		end
	else
		CallRemoteEvent(player, "MakeErrorNotification", "Vous n'avez pas de Bidon de Pétrol Brute.")
	end

end)

AddRemoteEvent("petrol:Sell", function ( player )

	local GetNumberOfJerican = GetNumberOfItem(player, "jerican_rafined") or 0

	if GetNumberOfJerican >= 1 then

		RemoveInventory(player, "jerican_rafined", GetNumberOfJerican, 0, player)

		SetPlayerBusy(player)
		CallRemoteEvent(player, "LockControlMove", true)
		SetPlayerAnimation(player, "PICKUP_MIDDLE")

		CallRemoteEvent(player,"loadingbar:show","Dépot du pétrol raffiner.",20)

		Delay(20000, function ()

			local cash = (GetNumberOfJerican * 110)

			SetPlayerNotBusy(player)
			CallRemoteEvent(player, "LockControlMove", false)

			CallRemoteEvent(player, "MakeErrorNotification", "-"..tostring(GetNumberOfJerican).." bidon de pétrol brute.")
			CallRemoteEvent(player, "MakeSuccessNotification", "+"..cash.."€")

			AddPlayerCash(player, cash)

			CallRemoteEvent(player,"loadingbar:hide")
		end)
	else
		CallRemoteEvent(player, "MakeErrorNotification", "Vous n'avez pas de bidon de pétrol raffiner.")
	end
end)

AddEvent("OnPackageStart", function()
	for k,v in pairs(PickUpPetroleBrutTable) do
		for i,j in pairs(v.location) do
			v.object[i] = CreatePickup(v.modelid, v.location[i][1], v.location[i][2], v.location[i][3])
			CreateText3D("Pétrole brut \n".._("press_e"), 18, v.location[i][1], v.location[i][2], v.location[i][3] + 200, 0, 0, 0)

			table.insert(PetroleBrutPickUpCash, v.object[i])
		end
	end

	for k,v in pairs(PickUpRaffinerieTable) do
		for i,j in pairs(v.location) do
			v.object[i] = CreatePickup(v.modelid, v.location[i][1], v.location[i][2], v.location[i][3])
			CreateText3D("Raffiner du pétrol brut \n".._("press_e"), 18, v.location[i][1], v.location[i][2], v.location[i][3] + 200, 0, 0, 0)

			table.insert(RaffineriePickUpCash, v.object[i])
		end
	end

	for k,v in pairs(PickUpVenteTable) do
		for i,j in pairs(v.location) do
			v.object[i] = CreatePickup(v.modelid, v.location[i][1], v.location[i][2], v.location[i][3])
			CreateText3D("Vendre votre pétrol raffiner \n".._("press_e"), 18, v.location[i][1], v.location[i][2], v.location[i][3] + 200, 0, 0, 0)

			table.insert(VentePickUpCash, v.object[i])
		end
	end
end)

AddEvent("OnPlayerJoin", function(player)
	CallRemoteEvent(player, "petrol:Setup", PetroleBrutPickUpCash, RaffineriePickUpCash, VentePickUpCash)
end)