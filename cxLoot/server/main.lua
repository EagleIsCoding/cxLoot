
if LootSettings.useLegacy then 
    ESX = exports["es_extended"]:getSharedObject() 
else
    ESX = nil 
    TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
end

local eventLocation 
local startedEvent = false 
local Loots = {}

function getRandomLocation()
    local randomLocation = math.random(1, #LootSettings.eventZones)
    return LootSettings.eventZones[randomLocation]
end

function getCount(item)
    for _, value in pairs(LootSettings.randomLoot) do 
        if value.item == item then 
            return value.count
        end
    end
    return 1 
end

CreateThread(function()
    startedEvent = true
    while true do 
        if startedEvent then 
            Wait(5000)
            eventLocation = getRandomLocation()
            Loots[#Loots+1] = true
            TriggerClientEvent("cxLoot:reset", -1)
            TriggerClientEvent("cxLoot:create", -1, eventLocation)
            TriggerClientEvent("esx:showAdvancedNotification", -1, LootSettings.message.title, LootSettings.message.subtitle, LootSettings.message.announcement, LootSettings.message.char, 2)
            SetTimeout((LootSettings.waitingDuration*60000) - 1000, function()
                if Loots[#Loots] then 
                    Loots[#Loots] = false
                    TriggerClientEvent("cxLoot:reset", -1)
                end
            end)
        end
        Wait(LootSettings.waitingDuration*60000)
    end
end)

RegisterServerEvent("cxLoot:rewards")
AddEventHandler("cxLoot:rewards", function(weaponItem)
    local source = source 
    local xPlayer = ESX.GetPlayerFromId(source)
    if Loots[#Loots] == nil or Loots[#Loots] == false then 
        return print("Loots[#Loots] is nil or false")
    end
    if not LootSettings.useWeaponItem then 
        return TriggerClientEvent("esx:showAdvancedNotification", -1, LootSettings.message.title, LootSettings.message.subtitle, LootSettings.message.defeat, LootSettings.message.char, 2)
    end
    local playerPos = GetEntityCoords(GetPlayerPed(source))
    local location = eventLocation
    local dst = #(playerPos-location)
    if dst > 20.0 then 
        return
    end
    xPlayer.addInventoryItem(weaponItem, getCount(weaponItem))
    TriggerClientEvent("cxLoot:reset", -1)
    TriggerClientEvent("esx:showAdvancedNotification", -1, LootSettings.message.title, LootSettings.message.subtitle, LootSettings.message.defeat, LootSettings.message.char, 2)
end)