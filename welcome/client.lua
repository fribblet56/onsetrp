local Dialog = ImportPackage("dialogui")
local _ = _ or function(k, ...) return ImportPackage("i18n").t(GetPackageName(), k, ...) end

local welcomeUI
local isCreated = false
local hideGameElements = true
local isInHomepage = true
local screenWidth, screenHeight = GetScreenSize()

AddEvent("OnPackageStart", function()
    welcomeUI = CreateWebUI(0.0, 0.0, 0.0, 0.0, 1, 60)
    SetWebAnchors(welcomeUI, 0.0, 0.0, 1.0, 1.0)
    LoadWebFile(welcomeUI, 'http://asset/' .. GetPackageName() .. '/welcome/index_fr.html')
    SetWebVisibility(welcomeUI, WEB_VISIBLE)
end)

AddRemoteEvent("InitWelcome", function(created)
    isCreated = created
    -- ExecuteWebJS(welcomeUI, 'initWelcome('..tostring(created)..');')
end)

AddRemoteEvent("SetWelcomeInfo", function ( _MaxPlayer, _NumberPlayer, _NamePlayer, _SteamIdPlayer, _IdPlayer, _PlayTime )
    ExecuteWebJS(welcomeUI, 'PlayerMax('..tostring(_MaxPlayer)..');')
    ExecuteWebJS(welcomeUI, 'PlayerNumber('..tostring(_NumberPlayer)..');')
    ExecuteWebJS(welcomeUI, 'PlayerPseudo("'..tostring(_NamePlayer)..'");')
    ExecuteWebJS(welcomeUI, 'PlayerName("'..tostring(_NamePlayer)..'");')
    ExecuteWebJS(welcomeUI, 'PlayerSteamId('..tostring(_SteamIdPlayer)..');')
    ExecuteWebJS(welcomeUI, 'PlayerId('..tostring(_IdPlayer)..');')
    ExecuteWebJS(welcomeUI, 'PlayTime("'..tostring(_PlayTime)..'");')
end)

AddEvent("WelcomePageReady", function()
    SetIgnoreLookInput(true)
    SetIgnoreMoveInput(true)
    ShowMouseCursor(true)
    ShowMouseCursor(true)
    ExecuteWebJS(welcomeUI, 'initWelcome('..tostring(isCreated)..');')
    DisplayMinimap()
    CallRemoteEvent("GetInfosWelcome")
end)

AddEvent("CloseAndSpawn", function()
    isInHomepage = false
    hideGameElements = false
    SetIgnoreLookInput(false)
    SetIgnoreMoveInput(false)
    ShowMouseCursor(false)
    SetInputMode(INPUT_GAME)
    SetWebVisibility(welcomeUI, WEB_HIDDEN)
    --CallRemoteEvent("setPositionAndSpawn")
    StartCameraFade(1, 0, 5, RGB(0, 0, 0))
end)

AddEvent("CloseAndCreateCharacter", function()
    isInHomepage = false
    hideGameElements = false
    SetIgnoreLookInput(false)	
    SetIgnoreMoveInput(false)	
    ShowMouseCursor(true)	
    SetInputMode(INPUT_GAME)
    SetWebVisibility(welcomeUI, WEB_HIDDEN)
    --CallRemoteEvent("setPositionAndSpawn")
    StartCameraFade(1, 0, 5, RGB(0, 0, 0))
end)

function OnRenderHUD()
    if (hideGameElements == true) then
        SetDrawColor(RGB(0, 0, 0)) --Set Draw Color to Black
        DrawRect(0, 0, screenWidth, screenHeight) --Draw full screen black rectangle for black screen effect
    end
end
AddEvent("OnRenderHUD", OnRenderHUD)

AddEvent("OnHideMainMenu", function()
    if isInHomepage then
        Delay(1, function()
            SetIgnoreLookInput(true)
            SetIgnoreMoveInput(true)
            ShowMouseCursor(true)
        end)
    end
end)



