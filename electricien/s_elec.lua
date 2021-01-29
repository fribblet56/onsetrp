local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

TransfoPickUpCash = { }
ElecPnjCash = { }

Elecl = {}

ElecPnjPos = { 114447, -5594, 1242, -40 }

PickTransfoTable = {
	modelid = 2,
	nbrLocation = 30,
	location = {
		{ 174718, 217824, 1282 },
		{ -16125, -18995, 2063 },
		{ -91054, 39558, 4704 },
		{ -184836, 84194, 1528 },
		{ -172734, 4107 ,1989 },
		{ -182632, -34503, 1166 },
		{ -187621, -42901, 1161 },
		{ -186455, -48500, 1142 },
		{ 135015, -126298, 1250 },
		{ 210773, 94366, 1307 },
		{ 216175, 155781, 1320 },
		{ 200346, 179541, 1319 },
		{ 168155, 193894, 1316 },
		{ 133555, 212122, 1306 },
		{ 71340, 184986, 532 },
		{ 77328, 185109, 526 },
		{ 195001, 189122, 1313 },
		{ 177326, 200338, 1317 },
		{ 175988, 217756, 1293 },
		{ 23082, 139127, 1559 },
		{ -13636, 137445, 1540 },
		{ 114468, 78285, 1331 },
		{ 108623, 76501, 1324 },
		{ 181077, 146806, 5928 },
		{ 180609, 10030, 10372 },
		{ 128511, 74061, 1574 },
		{ 175908, 217773, 1282 }
	 },
	object = {}
}

SetingJob = {
	rent = 300,
	new = 5
}

AddEvent("OnPlayerQuite", function ( player )
	Elecl[player] = nil
end)

AddEvent("OnPlayerJoin", function ( player )
	CallRemoteEvent(player, "elec:Setup", ElecPnjCash)
end)

AddEvent("OnPackageStart", function()

	ElecPnjCash = CreateNPC(ElecPnjPos[1], ElecPnjPos[2], ElecPnjPos[3], ElecPnjPos[4] )
    CreateText3D("Devenir électricien \n".._("press_e"), 18, ElecPnjPos[1], ElecPnjPos[2], ElecPnjPos[3]  + 120, 0, 0, 0)

	CreateTimer(function ( )

		for k, v in pairs(GetAllPlayers()) do

			local x,y,z = GetPlayerLocation(v) 

			if PlayerData[v] == nil then goto continue end

			if PlayerData[v].job ~= nil then
				if PlayerData[v].job == "electricien" then

					if Elecl[v] == nil then Elecl[v] = {} end

					if Elecl[v].pickup == nil then

						local random = math.random(1, tonumber(PickTransfoTable.nbrLocation))

						if random == Elecl[v].last then
							if random == PickTransfoTable.nbrLocation then
								random = 1
							else
								random = math.random(Elecl[v].last, tonumber(PickTransfoTable.nbrLocation))
							end
						end

						Elecl[v].last = random

						Elecl[v].pickup = CreatePickup(2, PickTransfoTable.location[random][1], PickTransfoTable.location[random][2], PickTransfoTable.location[random][3])

						for u,j in pairs(GetAllPlayers()) do
							SetPickupVisibility(Elecl[v].pickup, j, false)
						end

						SetPickupVisibility(Elecl[v].pickup, v, true)
						
						Elecl[v].dist = GetDistance3D(x, y, z, PickTransfoTable.location[random][1], PickTransfoTable.location[random][2], PickTransfoTable.location[random][3])

						CallRemoteEvent(v,"elec:Update", PickTransfoTable.location[random][1], PickTransfoTable.location[random][2], PickTransfoTable.location[random][3])
						CallRemoteEvent(v, "MakeNotification", "La position d'un transformateur vous a être envoyer.", "#5DADE2", 10000)
					end
				end
			end

			::continue::
		end

	end, 30000)
end)

--------- SERVICE AND EQUIPMENT
function ElecStartStopService(player)-- toggle service
    if PlayerData[player].job == "" then
        ElecStartService(player)
    elseif PlayerData[player].job == "electricien" then
        ElecEndService(player)
    else
        CallRemoteEvent(player, "MakeErrorNotification", _("please_leave_previous_job"))
    end
end
AddRemoteEvent("elec:startstopservice", ElecStartStopService)

function ElecStartService(player)
    
    PlayerData[player].job = "electricien"
    CallRemoteEvent(player, "elec:client:isonduty", true)
    
    CallRemoteEvent(player, "MakeNotification", "La position des transformateurs à remettre en état von bientôt vous être envoyer.", "#5DADE2", 10000)

    return true
end

function ElecEndService(player)-- stop service

    PlayerData[player].job = ""
    CallRemoteEvent(player, "elec:client:isonduty", false)

    CallRemoteEvent(player, "elec:DeletWaypoint")
	DestroyPickup(Elecl[player].pickup)
	Elecl[player] = nil

    
    CallRemoteEvent(player, "MakeNotification", "Vous avez quitté votre poste d'électricien.", "#5DADE2", 10000)
    
    return true
end

AddRemoteEvent("elec:Repar", function ( player )
	if GetNumberOfItem(player, "toolbox") >= 1 then

		CallRemoteEvent(player, "elec:DeletWaypoint")
		DestroyPickup(Elecl[player].pickup)

		SetPlayerBusy(player)
		CallRemoteEvent(player, "LockControlMove", true)
		SetPlayerAnimation(player, "LOCKDOOR")

		CallRemoteEvent(player,"loadingbar:show","Réparation du transformateur...",60)

		Delay(3000, function (  )
			SetPlayerAnimation(player, "LOCKDOOR")
		end)

		Delay(6000, function (  )
			SetPlayerAnimation(player, "ENTERCODE")
		end)

		Delay(9000, function (  )
			SetPlayerAnimation(player, "THINKING")
		end)

		Delay(54000, function (  )
			SetPlayerAnimation(player, "THUMBSUP")
		end)

		Delay(57000, function (  )
			SetPlayerAnimation(player, "LOCKDOOR")
		end)

		Delay(60000, function (  )
			SetPlayerAnimation(player, "STOP")

			local facteur = Elecl[player].dist / 100000

			if facteur < 1 then
				AddPlayerCash(player, 300)
				CallRemoteEvent(player, "MakeSuccessNotification", "Votre employeur vous a payer 300€ pour cette réparation.")
			elseif facteur >= 1 and facteur < 2 then
				AddPlayerCash(player, 375)
				CallRemoteEvent(player, "MakeSuccessNotification", "Votre employeur vous a payer 375€ pour cette réparation.")
			elseif facteur >= 2 and facteur < 3 then
				AddPlayerCash(player, 450)
				CallRemoteEvent(player, "MakeSuccessNotification", "Votre employeur vous a payer 450€ pour cette réparation.")
			elseif facteur >= 3 and facteur < 4 then
				AddPlayerCash(player, 525)
				CallRemoteEvent(player, "MakeSuccessNotification", "Votre employeur vous a payer 525€ pour cette réparation.")
			elseif facteur >= 4 then
				AddPlayerCash(player, 600)
				CallRemoteEvent(player, "MakeSuccessNotification", "Votre employeur vous a payer 600€ pour cette réparation.")
			end

			SetPlayerNotBusy(player)
			CallRemoteEvent(player, "LockControlMove", false)

			CallRemoteEvent(player,"loadingbar:hide")
			Elecl[player].pickup = nil
		end)

	else
		CallRemoteEvent(player, "MakeErrorNotification", "Il vous faut une boite a outils.")
	end
end)

function GetNumberOfItem(player, item)
    return PlayerData[player].inventory[item] or 0
end