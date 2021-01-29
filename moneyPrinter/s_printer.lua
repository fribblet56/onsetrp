local _ = function(k, ...) return ImportPackage("i18n").t(GetPackageName(), k, ...) end

printerSeting = {

	update = {
		time = 15,
		increment = 480
	},
	setting = {
		battery = 5,
		cash = 3000,
		repaire = 15,
		paper = 10,
		destroy = 30
	}
}

PickUpBatteryTable = {
	{
		modelid = 2,
		location = {
			{ 115379, -5559, 1242 }
	 	},
		object = {}
	}
}

printerLimite = 2

local printerPlayerList = { }

allprinter = { }

printerBatteryPickUpCash = { }

printerNbr = 0

AddEvent("OnPackageStart", function( )
	allprinter = {}

	for k,v in pairs(PickUpBatteryTable) do
		for i,j in pairs(v.location) do
			v.object[i] = CreatePickup(v.modelid, v.location[i][1], v.location[i][2], v.location[i][3])
			CreateText3D("Recharger vos batteries \n".._("press_e"), 18, v.location[i][1], v.location[i][2], v.location[i][3] + 200, 0, 0, 0)

			table.insert(printerBatteryPickUpCash, v.object[i])
		end
	end
	
	Delay(200, function ( )
		local query = mariadb_prepare(sql, "SELECT * FROM `printer`;") 
    	mariadb_async_query(sql, query, AddHoldPrinter)
	end)

	CreateTimer(function()
		--erreur exectue chaque timer sur le dernier printer a coriger mec <3

		local now = os.time(os.date("!*t"))

		for k,v in pairs(allprinter) do
			if tonumber(v.update) < tonumber(now) - printerSeting.update.increment then

				if v.battery - printerSeting.setting.battery <= 0 then
					v.battery = 0
				end

				if v.etat - printerSeting.setting.repaire <= 0 then
					v.etat = 0
				end

				if v.battery > 0 and v.etat > 0 and v.paper > 0 and v.active == 1 then
					v.update = now

					v.paper = v.paper - printerSeting.setting.paper
					v.cash = v.cash + printerSeting.setting.cash
					v.battery = v.battery - printerSeting.setting.battery
					v.etat = v.etat - printerSeting.setting.repaire

				end
			end
		end

    end, printerSeting.update.time * 1000)

end)

AddRemoteEvent("printer:GetAllPrinter", function ( player )
	CallRemoteEvent(player, "printer:UpdatePrinterList", allprinter)
end)

AddEvent("OnPlayerJoin", function( player )
	CallRemoteEvent(player,"printer:PlayerJoinSetup", printerBatteryPickUpCash)
	if printerPlayerList[player] == nil then
		printerPlayerList[player] = {}
		printerPlayerList[player].nbr = 0
	end
end)

AddRemoteEvent("printer:UpdateList", function( player )
	CallRemoteEvent(player, "printer:GetList", allprinter)
end)

AddRemoteEvent("printer:chargeBattery", function ( _player )
	if GetNumberOfItem(_player, "empty_printer_battery") >= 1 then
		RemoveInventory(_player, "empty_printer_battery", 1, 0, _player)

		SetPlayerBusy(_player)
		CallRemoteEvent(_player, "LockControlMove", true)

		CallRemoteEvent(_player,"loadingbar:show","Chargement de la battery...",60)

		SetPlayerAnimation(_player, "PICKUP_LOWER")

		Delay(60000, function ( )
			SetPlayerNotBusy(_player)
			CallRemoteEvent(_player, "LockControlMove", false)

			CallRemoteEvent(_player, "MakeErrorNotification", "-1 batterie au plond vide.")
			CallRemoteEvent(_player, "MakeSuccessNotification", "+1 batterie au plond pleine.")

			AddInventory(_player, "printer_battery", 1, _player)
			SetPlayerAnimation(_player, "PICKUP_LOWER")
		end)

	else
		CallRemoteEvent(_player, "MakeErrorNotification", "Vous n'avez pas de batterie vide.")
	end
end)

function AddHoldPrinter( )
	print("Regeneration Printer: "..mariadb_get_row_count())

	if mariadb_get_row_count() == 0 then return end

	for i=1,mariadb_get_row_count() do
		local printerInfoReponse = mariadb_get_assoc(i)

		printerNbr = printerNbr + 1

		allprinter[i] = { }
		allprinter[i].location = json_decode(printerInfoReponse['location'])
		allprinter[i].id = printerNbr
		allprinter[i].owner = tonumber(printerInfoReponse["owner"])
		allprinter[i].battery = tonumber(printerInfoReponse["battery"])
		allprinter[i].etat = tonumber(printerInfoReponse["etat"])
		allprinter[i].cash = tonumber(printerInfoReponse["cash"])
		allprinter[i].paper = tonumber(printerInfoReponse["paper"])
		allprinter[i].active = tonumber(printerInfoReponse["active"])
		allprinter[i].update = os.time(os.date("!*t"))


		CreatePrinter(allprinter[i].location.x, allprinter[i].location.y, allprinter[i].location.z, printerNbr, allprinter[i].owner)

		if printerPlayerList[allprinter[i].owner] == nil then
			printerPlayerList[allprinter[i].owner] = { }
			printerPlayerList[allprinter[i].owner].nbr = 0
		end
		
		printerPlayerList[allprinter[i].owner].nbr = printerPlayerList[allprinter[i].owner].nbr + 1

	end
end


AddRemoteEvent("printer:Create", function ( player )
	local nbrPlayerPrinter = printerPlayerList[player].nbr
	if GetNumberOfItem(player, "money_printer") >= 1 then
		if nbrPlayerPrinter < printerLimite then
			RemoveInventory(player, "money_printer", 1, 0, player)

			local x, y, z = GetPlayerLocation(player)

			printerNbr = printerNbr + 1
			printerPlayerList[player].nbr = nbrPlayerPrinter + 1


			allprinter[printerNbr] = { }
			allprinter[printerNbr].id = printerNbr
			allprinter[printerNbr].owner = PlayerData[player].id
			allprinter[printerNbr].location = { x = x, y = y, z = z }
			allprinter[printerNbr].battery = 0
			allprinter[printerNbr].etat = 100
			allprinter[printerNbr].cash = 0
			allprinter[printerNbr].paper = 0
			allprinter[printerNbr].active = 0
			allprinter[printerNbr].update = os.time(os.date("!*t"))

			CreatePrinter(x, y, z, printerNbr, PlayerData[player].id)

			CallRemoteEvent(player, "MakeSuccessNotification", "Vous avez posser 1 printer.")
		else
			CallRemoteEvent(player, "MakeErrorNotification", "Vous ne pouvez pas placer plus de 2 printer.")
		end
	else
		CallRemoteEvent(player, "MakeErrorNotification", "Vous n'avez pas de printer.")
	end
end)

AddRemoteEvent("printer:Withdraw", function ( _player, _printerId, _printerCash )
	AddPlayerCash(_player, _printerCash)
	allprinter[_printerId].cash = 0
	SetPlayerAnimation(_player, "PICKUP_MIDDLE")
end)

AddRemoteEvent("printer:ChangeStatu", function ( _player, _printerId )
	SetPlayerBusy(_player)
	CallRemoteEvent(_player, "LockControlMove", true)
	SetPlayerAnimation(_player, "ENTERCODE")
	CallRemoteEvent(_player,"loadingbar:show","Modification des paramétre d'alimentation du printer...",5)

	Delay(5000, function ()
		if allprinter[_printerId].active == 1 then
			allprinter[_printerId].active = 0
			CallRemoteEvent(_player, "MakeErrorNotification", "Printer Off.")
		elseif allprinter[_printerId].active == 0 then
			allprinter[_printerId].active = 1
			CallRemoteEvent(_player, "MakeErrorNotification", "Printer On.")
		end
			SetPlayerNotBusy(_player)
			CallRemoteEvent(_player, "LockControlMove", false)
			CallRemoteEvent(_player,"loadingbar:hide")
	end)
end)

AddRemoteEvent("printer:Destroy", function ( _player, _printerId )

	SetPlayerBusy(_player)
	CallRemoteEvent(_player, "LockControlMove", true)
	SetPlayerAnimation(_player, "KICKDOOR")
	CallRemoteEvent(_player,"loadingbar:show","Déstruction du printer",printerSeting.setting.destroy)

	Delay(printerSeting.setting.destroy * 1000, function ()
			DestroyObject(allprinter[_printerId].object)
			DestroyText3D(allprinter[_printerId].objectText)
			allprinter[_printerId]= nil
			SetPlayerNotBusy(_player)
			CallRemoteEvent(_player, "LockControlMove", false)
			CallRemoteEvent(_player, "MakeErrorNotification", "Printer détruit.")
			CallRemoteEvent(_player,"loadingbar:hide")
	end)
end)

AddRemoteEvent("printer:Repaire", function ( _player, _printerId )
	if GetNumberOfItem(_player, "toolbox") >= 1 then
		SetPlayerBusy(_player)
		CallRemoteEvent(_player, "LockControlMove", true)
		SetPlayerAnimation(_player, "PICKUP_LOWER")
		CallRemoteEvent(_player,"loadingbar:show","Entretien du printer",30)

		Delay(30000, function ()
			SetPlayerNotBusy(_player)
			CallRemoteEvent(_player, "LockControlMove", false)
			allprinter[_printerId].etat = 100
			CallRemoteEvent(_player, "MakeSuccessNotification", "Printer remis en état.")
			CallRemoteEvent(_player,"loadingbar:hide")
		end)
	else
		CallRemoteEvent(_player, "MakeErrorNotification", "Il vous faut une boite a outils pour entretenir votre printer.")
	end
end)

AddRemoteEvent("printer:ChangeBattery", function ( _player, _printerId )
	if GetNumberOfItem(_player, "printer_battery") >= 1 then
		RemoveInventory(_player, "printer_battery", 1, 0, _player)
		SetPlayerBusy(_player)
		CallRemoteEvent(_player, "LockControlMove", true)
		SetPlayerAnimation(_player, "PICKUP_LOWER")
		CallRemoteEvent(_player,"loadingbar:show","Changement de batterie ...",20)

		Delay(20000, function ()
			SetPlayerNotBusy(_player)
			CallRemoteEvent(_player, "LockControlMove", false)
			allprinter[_printerId].battery = 100
			AddInventory(_player, "empty_printer_battery", 1, _player)
			CallRemoteEvent(_player, "MakeSuccessNotification", "Nouvelle batterie installer.")
			CallRemoteEvent(_player,"loadingbar:hide")
		end)
	else
		CallRemoteEvent(_player, "MakeErrorNotification", "Vous n'avez pas de batterie plein sur vous.")
	end
end)

AddRemoteEvent("printer:Paper", function ( _player, _printerId )
	if GetNumberOfItem(_player, "printer_paper") >= 1 then
		RemoveInventory(_player, "printer_paper", 1, 0, _player)
		SetPlayerBusy(_player)
		CallRemoteEvent(_player, "LockControlMove", true)
		SetPlayerAnimation(_player, "PICKUP_LOWER")
		CallRemoteEvent(_player,"loadingbar:show","Ajout du papier ...",20)

		Delay(20000, function ()
			SetPlayerNotBusy(_player)
			CallRemoteEvent(_player, "LockControlMove", false)
			allprinter[_printerId].paper = 100
			CallRemoteEvent(_player, "MakeSuccessNotification", "Papier ajouter.")
			CallRemoteEvent(_player,"loadingbar:hide")
		end)
	else
		CallRemoteEvent(_player, "MakeErrorNotification", "Vous n'avez pas de papier sur vous.")
	end
end)

function CreatePrinter( x, y, z, PrinterID, Owner)
    object = CreateObject(535, x, y -55, z -100)
    textObj = CreateText3D("Printer [E]", 15, x, y -55, z + 50, 0,0,0)
    SetObjectPropertyValue(object, "collision", true, true)
    SetObjectPropertyValue(object, "printerId", PrinterID)
    SetObjectPropertyValue(object, "printerOwner", Owner)
    allprinter[PrinterID].object = object
    allprinter[PrinterID].objectText = textObj
end

function GetNumberOfItem(player, item)
    return PlayerData[player].inventory[item] or 0
end

AddEvent("OnPackageStop", function ( )
	local query1 = mariadb_prepare(sql, "TRUNCATE `printer`;")
    mariadb_query(sql, query1)
	for k,v in pairs(allprinter) do
		print("Save printer: "..k)
		SavePrinter(k)
	end
end)

function SavePrinter(printerId)
    if (allprinter[printerId] == nil) then
        return
    end
    
    if (allprinter[printerId].id == 0) then
        return
    end
    
    local query2 = mariadb_prepare(sql, "INSERT INTO `printer` (`id_printer`, `owner`, `location`, `battery`, `etat`, `cash`, `paper`, `active`) VALUES ('?', '?', '?', '?', '?', '?', '?', '?');",
    	tonumber(allprinter[printerId].id),
    	tonumber(allprinter[printerId].owner),
    	json_encode(allprinter[printerId].location),
    	tonumber(allprinter[printerId].battery),
    	tonumber(allprinter[printerId].etat),
    	tonumber(allprinter[printerId].cash),
    	tonumber(allprinter[printerId].paper),
    	tonumber(allprinter[printerId].active)
    )
    mariadb_query(sql, query2)
end