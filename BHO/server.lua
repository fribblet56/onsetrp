local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

WeedPickUpCash = { }
ButanePickUpCash = { }
WeedManicurePickUpCash = { }
WeedBHOPickUpCash = { }

BHOTimerPlayerCash = {}

PickUpWeedTable = {
	{
		modelid = 2,
		location = {
			{ 37580, -982, 9955 }
	 	},
		object = {}
	}
}

PickUpButaneTable = {
	{
		modelid = 2,
		location = {
			{ 59058, 191393, 550 }
	 	},
		object = {}
	}
}

PickUpManicureTable = {
	{
		modelid = 2,
		location = {
			{ -28430, -11081, 2082 }
	 	},
		object = {}
	}
}

PickUpBHOTable = {
	{
		modelid = 2,
		location = {
			{ -28259, -10137, 2083 }
	 	},
		object = {}
	}
}

AddEvent("OnPackageStart", function()
	for k,v in pairs(PickUpWeedTable) do
		for i,j in pairs(v.location) do
			v.object[i] = CreatePickup(v.modelid, v.location[i][1], v.location[i][2], v.location[i][3])
			CreateText3D("Récolter pied de weed \n".._("press_e"), 18, v.location[i][1], v.location[i][2], v.location[i][3] + 200, 0, 0, 0)

			table.insert(WeedPickUpCash, v.object[i])
		end
	end

		for k,v in pairs(PickUpButaneTable) do
		for i,j in pairs(v.location) do
			v.object[i] = CreatePickup(v.modelid, v.location[i][1], v.location[i][2], v.location[i][3])
			CreateText3D("Voler des bouteille de butane \n".._("press_e"), 18, v.location[i][1], v.location[i][2], v.location[i][3] + 200, 0, 0, 0)

			table.insert(ButanePickUpCash, v.object[i])
		end
	end

	for k,v in pairs(PickUpManicureTable) do
		for i,j in pairs(v.location) do
			v.object[i] = CreatePickup(v.modelid, v.location[i][1], v.location[i][2], v.location[i][3])
			CreateText3D("Manucurer vos pieds de weed \n".._("press_e"), 18, v.location[i][1], v.location[i][2], v.location[i][3] + 200, 0, 0, 0)

			table.insert(WeedManicurePickUpCash, v.object[i])
		end
	end

	for k,v in pairs(PickUpBHOTable) do
		for i,j in pairs(v.location) do
			v.object[i] = CreatePickup(v.modelid, v.location[i][1], v.location[i][2], v.location[i][3])
			CreateText3D("Transformation BHO \n".._("press_e"), 18, v.location[i][1], v.location[i][2], v.location[i][3] + 100, 0, 0, 0)

			table.insert(WeedBHOPickUpCash, v.object[i])
		end
	end

end)

AddEvent("OnPlayerJoin", function(player)
	CallRemoteEvent(player, "weed:Setup", WeedPickUpCash, WeedManicurePickUpCash, WeedBHOPickUpCash, ButanePickUpCash)
end)

AddRemoteEvent("weed:startRecolting", function(player)

	if math.ceil((GetPlayerUsedSlots(player) + 1)) <= GetPlayerMaxSlots(player) then
		SetPlayerBusy(player)
		CallRemoteEvent(player, "LockControlMove", true)
		SetPlayerAnimation(player, "PICKUP_LOWER")
		CallRemoteEvent(player,"loadingbar:show","Récolte du pied de weed.",10)

		Delay(10000, function ()
			SetPlayerNotBusy(player)
			CallRemoteEvent(player, "LockControlMove", false)
			AddInventory(player, "cannabis_no_manicure", 1, player)
			CallRemoteEvent(player, "MakeSuccessNotification", "+1 Pied de weed non manucurer.")
			CallRemoteEvent(player,"loadingbar:hide")
		end)
	else
		CallRemoteEvent(player, "MakeErrorNotification", "Vous n'avez pas de place dans votre inventaire.")
	end


end)

AddRemoteEvent("weed:startPickupButane", function(player)
	if math.ceil((GetPlayerUsedSlots(player) + 1)) <= GetPlayerMaxSlots(player) then
		SetPlayerBusy(player)
		CallRemoteEvent(player, "LockControlMove", true)
		SetPlayerAnimation(player, "PICKUP_LOWER")
		CallRemoteEvent(player,"loadingbar:show","Vole de bouteille de gaz butane.",25)

		Delay(25000, function ()
			local value = math.random(1,2)
			SetPlayerNotBusy(player)
			CallRemoteEvent(player, "LockControlMove", false)
			AddInventory(player, "butane_cylinder", value, player)
			CallRemoteEvent(player, "MakeSuccessNotification", "+"..value.." bouteille de gaz butane.")
			CallRemoteEvent(player,"loadingbar:hide")
		end)
	else
		CallRemoteEvent(player, "MakeErrorNotification", "Vous n'avez pas de place dans votre inventaire.")
	end


end)

AddRemoteEvent("weed:startManicuring", function(player)

	if GetNumberOfItem(player, "cannabis_no_manicure") >= 1 then

		if math.ceil((GetPlayerUsedSlots(player) + 1)) <= GetPlayerMaxSlots(player) then 

			RemoveInventory(player, "cannabis_no_manicure", 1, 0, player)

			SetPlayerBusy(player)
			CallRemoteEvent(player, "LockControlMove", true)
			SetPlayerAnimation(player, "PICKUP_MIDDLE")

			CallRemoteEvent(player,"loadingbar:show","Manucure du pied de weed",10)

			Delay(10000, function ()
				SetPlayerNotBusy(player)
				CallRemoteEvent(player, "LockControlMove", false)

				local mathWeed = math.random(1, 3)

				AddInventory(player, "weed", mathWeed, player)

				CallRemoteEvent(player, "MakeErrorNotification", "-1 pied de weed.")
				CallRemoteEvent(player, "MakeSuccessNotification", "+"..mathWeed.." weed.")

				CallRemoteEvent(player,"loadingbar:hide")
			end)
		else
			CallRemoteEvent(player, "MakeErrorNotification", "Vous n'avez pas de place dans votre inventaire.")
		end
	else
		CallRemoteEvent(player, "MakeErrorNotification", "Vous n'avez pas de pied de weed dans votre inventaire.")
	end

end)

AddRemoteEvent("weed:startRaffin", function(player)

	if GetNumberOfItem(player, "weed") >= 3 then

		if GetNumberOfItem(player, "butane_cylinder") >= 1 then

			if (GetPlayerUsedSlots(player) + 1) <= GetPlayerMaxSlots(player) then 

				RemoveInventory(player, "weed", 3, 0, player)
				RemoveInventory(player, "butane_cylinder", 1, 0, player)

				SetPlayerBusy(player)
				CallRemoteEvent(player, "LockControlMove", true)
				SetPlayerAnimation(player, "PICKUP_MIDDLE")

				CallRemoteEvent(player,"loadingbar:show","Transformation de la weed en BHO",10)

				Delay(10000, function ()
					SetPlayerNotBusy(player)
					CallRemoteEvent(player, "LockControlMove", false)

					AddInventory(player, "cannabis_oil", 1, player)

					CallRemoteEvent(player, "MakeErrorNotification", "-3 Weed.")
					CallRemoteEvent(player, "MakeErrorNotification", "-1 bouteille de gaz butane.")
					CallRemoteEvent(player, "MakeSuccessNotification", "+1 BHO")

					CallRemoteEvent(player,"loadingbar:hide")
				end)
			else
				CallRemoteEvent(player, "MakeErrorNotification", "Vous n'avez pas de place dans votre inventaire.")
			end
		else
			CallRemoteEvent(player, "MakeErrorNotification", "Vous n'avez de bouteille de gaz butane.")
		end
	else
		CallRemoteEvent(player, "MakeErrorNotification", "Il vous faut un minimum de 3 weed.")
	end

end)

AddRemoteEvent("weed:TimerCops", function ( player )
	if BHOTimerPlayerCash[player] == nil then
		BHOTimerPlayerCash[player] = {}
		BHOTimerPlayerCash[player].Date = os.time(os.date("!*t"))
		BHOTimerPlayerCash[player].Timer = CreateTimer(function ( )
			local x,y,z = GetPlayerLocation(player) 
			dist = GetDistance3D(x, y, z, -28259, -10137, 2083)
			if dist <= 12000 then
				if tonumber(BHOTimerPlayerCash[player].Date) < tonumber(os.time(os.date("!*t"))) - 300 then
				    for k, v in pairs(GetAllPlayers()) do
				        if PlayerData[v].job == "police" then
				        	CallRemoteEvent(v, "MakeErrorNotification", "Individu repérer près des cortinaire du port.")
				     	end
				    end
				end
			else
				DestroyTimer(BHOTimerPlayerCash[player].Timer)
				BHOTimerPlayerCash[player] = nil
			end
		end, 15000)
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