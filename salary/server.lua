local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local minutes = 30

local MINIMUM_WAGE = 250
local JOB_WAGE = 853
local MECHANIC_WAGE = 750
local POLICE_WAGE = 1173
local MEDIC_WAGE = 3250

CreateTimer(function()
    for key, player in pairs(GetAllPlayers()) do
        if PlayerData[player] then 

            -- THOSE HAS TO BE ORDER BY WAGE AMOUNT (desc)
            if PlayerData[player].job == "medic" then
                PlayerData[player].bank_balance = PlayerData[player].bank_balance + MEDIC_WAGE
                CallRemoteEvent(player, "MakeSuccessNotification", _("salary_notification", _("price_in_currency", tostring(MEDIC_WAGE))))
            elseif PlayerData[player].job == "police" then
                PlayerData[player].bank_balance = PlayerData[player].bank_balance + POLICE_WAGE
                CallRemoteEvent(player, "MakeSuccessNotification", _("salary_notification", _("price_in_currency", tostring(POLICE_WAGE))))
            elseif PlayerData[player].job == "mechanic" then
                PlayerData[player].bank_balance = PlayerData[player].bank_balance + MECHANIC_WAGE
                CallRemoteEvent(player, "MakeSuccessNotification", _("salary_notification", _("price_in_currency", tostring(POLICE_WAGE))))
            elseif PlayerData[player].job == "" then
                PlayerData[player].bank_balance = PlayerData[player].bank_balance + MINIMUM_WAGE
                CallRemoteEvent(player, "MakeSuccessNotification", _("salary_notification", _("price_in_currency", tostring(MINIMUM_WAGE))))
            end
    
        end
	end
end, minutes * 60000)
