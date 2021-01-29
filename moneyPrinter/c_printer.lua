local _ = function(k, ...) return ImportPackage("i18n").t(GetPackageName(), k, ...) end

PrinterList = { }

local pickupBatteryPrinterId

AddEvent("OnPackageStart", function()
    printerUi = CreateWebUI(0.0, 0.0, 0.0, 0.0, 1, 60)
    SetWebAnchors(printerUi, 0.0, 0.0, 1.0, 1.0)
    LoadWebFile(printerUi, 'http://asset/' .. GetPackageName() .. '/inventory/gui/index.html')
    SetWebVisibility(printerUi, WEB_HIDDEN)
end)

AddEvent("closeEditor", function()
    SetWebVisibility(printerUi, WEB_HIDDEN)
    SetIgnoreLookInput(false)
    SetIgnoreMoveInput(false)
    ShowMouseCursor(false)
    SetInputMode(INPUT_GAME)
end)

function closeGui( )
    SetWebVisibility(printerUi, WEB_HIDDEN)
    SetIgnoreLookInput(false)
    SetIgnoreMoveInput(false)
    ShowMouseCursor(false)
    SetInputMode(INPUT_GAME)
end

AddRemoteEvent("printer:PlayerJoinSetup", function ( _batteryPickupCash )
    pickupBatteryPrinterId = _batteryPickupCash
end)

AddRemoteEvent("printer:GetList", function ( _PrinterList )
	PrinterList = _PrinterList
end)

AddRemoteEvent("printer:Setup", function ()
	CallRemoteEvent("printer:Create")
end)

function OnKeyPress(key)
    if key == INTERACT_KEY and not GetPlayerBusy() then
        CallRemoteEvent("printer:UpdateList")

        local nearestPrinter = GetNearestPrinter()
        local nearestBattery = GetNearestPickUpBattery()

        if nearestPrinter ~= 0 then
            SetWebVisibility(printerUi, WEB_VISIBLE)
            SetIgnoreLookInput(true)
            SetIgnoreMoveInput(true)
            ShowMouseCursor(true)

            Delay(200, function ()
            ExecuteWebJS(printerUi, "OpenGui("..tonumber(PrinterList[nearestPrinter].id)..","..tonumber(PrinterList[nearestPrinter].etat)..","..tonumber(PrinterList[nearestPrinter].battery)..","..tonumber(PrinterList[nearestPrinter].paper)..","..tonumber(PrinterList[nearestPrinter].cash)..","..tonumber(PrinterList[nearestPrinter].active)..");")
            end)
        end

        if nearestBattery ~= 0 then
            CallRemoteEvent("printer:chargeBattery")
        end
    end
end
AddEvent("OnKeyPress", OnKeyPress)

AddEvent("printer:SetupWithdraw", function ( _printerId, _printerCash )
    CallRemoteEvent("printer:Withdraw", _printerId, _printerCash)
    closeGui()
end)

AddEvent("printer:SetupRepaire", function ( _printerId )
    CallRemoteEvent("printer:Repaire", _printerId)
    closeGui()
end)

AddEvent("printer:SetupPaper", function ( _printerId )
    CallRemoteEvent("printer:Paper", _printerId)
    closeGui()
end)

AddEvent("printer:SetupChangeBattery", function ( _printerId )
    CallRemoteEvent("printer:ChangeBattery", _printerId)
    closeGui()
end)

AddEvent("printer:SetupChangeStatu", function ( _printerId )
    CallRemoteEvent("printer:ChangeStatu", _printerId)
    closeGui()
end)

AddEvent("printer:SetupDestroy", function ( _printerId )
    CallRemoteEvent("printer:Destroy", _printerId)
    closeGui()
end)

function GetNearestPrinter()
    local x, y, z = GetPlayerLocation()
    for k, printerId in pairs(PrinterList) do

        local x2 = printerId.location.x
        local y2 = printerId.location.y
        local z2 = printerId.location.z

        local dist = GetDistance3D(x, y, z, x2, y2, z2)

        if dist < 50.0 then
        	return printerId.id
        end
    end
    return 0
end

function GetNearestPickUpBattery()
    local x, y, z = GetPlayerLocation()

    for k,v in pairs(GetStreamedPickups()) do
        local x2, y2, z2 = GetPickupLocation(v)

        local dist = GetDistance3D(x, y, z, x2, y2, z2)

        if dist < 400.0 then
            for k,i in pairs(pickupBatteryPrinterId) do
                if v == i then
                    return v
                end
            end
        end

    end

    return 0
end