local OnlinePlayer = GetPlayerCount()
local nbrCops = 0
local nbrMedic = 0
local nbrMilitary = 0
local nbrFixMan = 0
local PlayerIsAdmin = 0

local tabmenuClient

AddEvent("OnPackageStart", function()
    tabmenuClient = CreateWebUI(0.0, 0.0, 0.0, 0.0, 1, 60)
    SetWebAnchors(tabmenuClient, 0.0, 0.0, 1.0, 1.0)
    LoadWebFile(tabmenuClient, 'http://asset/' .. GetPackageName() .. '/PlayerTabMenu/TabMenu.html')
    SetWebVisibility(tabmenuClient, WEB_HIDDEN)
    ExecuteWebJS(tabmenuClient, "SetPlayerMax('10');")
    CallRemoteEvent("tabmenu:Update")
end)

AddRemoteEvent("tabmenu:Update", function ( _nbrCops, _nbrMedic, _nbrMilitary, _nbrFixMan)
	UpdateTabMenu(_nbrCops, _nbrMedic, _nbrMilitary, _nbrFixMan)
end)

AddRemoteEvent("tabmenu:Steup", function ( _nbrMaxPlayer, _nbrCops, _nbrMedic, _nbrMilitary, _nbrFixMan, _PlayerIsAdmin)
	ExecuteWebJS(tabmenuClient, "SetPlayerMax('10');")
	AddPlayerChat("1:".._nbrMaxPlayer)
	AddPlayerChat("2:".._nbrCops)
	AddPlayerChat("3:".._nbrMedic)
	AddPlayerChat("4:".._nbrMilitary)
	AddPlayerChat("5:".._nbrFixMan)
	AddPlayerChat("6:".._PlayerIsAdmin)

	nbrCops = _nbrCops
	nbrMedic = _nbrMedic
	nbrMilitary = _nbrMilitary
	nbrFixMan = _nbrFixMan
	PlayerIsAdmin = _PlayerIsAdmin
	UpdateTabMenu(_nbrCops, _nbrMedic, _nbrMilitary, _nbrFixMan)
end)

function OnKeyPress(key)
    if key == 'Tab' and PlayerIsAdmin == 0 then
    	SetWebVisibility(tabmenuClient, WEB_HITINVISIBLE)
    end
end
AddEvent("OnKeyPress", OnKeyPress)

function OnKeyRelease(key)
    if key == 'Tab' and PlayerIsAdmin == 0 then
    	SetWebVisibility(tabmenuClient, WEB_HIDDEN)
    end
end
AddEvent("OnKeyRelease", OnKeyRelease)

function UpdateTabMenu( _nbrCops, _nbrMedic, _nbrMilitary , _nbrFixMan)
	AddPlayerChat("1:".._nbrCops)
	AddPlayerChat("2:".._nbrMedic)
	AddPlayerChat("3:".._nbrMilitary)
	AddPlayerChat("4:".._nbrFixMan)

	ExecuteWebJS(tabmenuClient, "SetCopNbr("..tostring(_nbrCops)..");")
	ExecuteWebJS(tabmenuClient, "SetSoldierNbr("..tostring(_nbrMilitary)..");")
	ExecuteWebJS(tabmenuClient, "SetDoctorNbr("..tostring(_nbrMedic)..");")
	ExecuteWebJS(tabmenuClient, "SetFixManNbr("..tostring(_nbrFixMan)..");")
	ExecuteWebJS(tabmenuClient, "SetPlayerNbr("..tostring(OnlinePlayer)..");")
end