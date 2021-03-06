ESX = nil

TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)

-- Liquide

RegisterNetEvent("pShop:achatliquide") 
AddEventHandler("pShop:achatliquide", function(Model, Prix) 
	local joueur = ESX.GetPlayerFromId(source)  
	local argent = joueur.getMoney()

	if argent >= Prix then 
		joueur.removeMoney(Prix) 

		joueur.addInventoryItem(Model, 1) 
		TriggerClientEvent('esx:showNotification', source, "Vous avez acheter un ~y~produit ~s~pour ~y~" ..Prix.. "$~s~.")
	else 
		TriggerClientEvent("esx:showNotification", source, "~r~Vous n'avez pas assez d'argent.")
	end
end)

-- Banque

RegisterNetEvent('pShop:achatbanque') 
AddEventHandler('pShop:achatbanque', function(Model, Prix)
	local joueur = ESX.GetPlayerFromId(source)  
	local argent = joueur.getAccount('bank').money

	if argent >= Prix then 
		joueur.removeAccountMoney('bank', Prix)

		joueur.addInventoryItem(Model, 1) 
		TriggerClientEvent('esx:showNotification', source, "Vous avez acheter un ~y~produit ~s~pour ~y~" ..Prix.. "$~s~.")
	else 
		TriggerClientEvent("esx:showNotification", source, "~r~Vous n'avez pas assez d'argent.")
	end
end)

-- Braquage (Not code by Pots#0106)

local deadPeds = {}

RegisterServerEvent('pShop:pedDead')
AddEventHandler('pShop:pedDead', function(store)
    if not deadPeds[store] then
        deadPeds[store] = 'deadlol'
        TriggerClientEvent('pShop:onPedDeath', -1, store)
        local second = 1000
        local minute = 60 * second
        local hour = 60 * minute
        local cooldown = Config.Shops[store].cooldown
        local wait = cooldown.hour * hour + cooldown.minute * minute + cooldown.second * second
        Wait(wait)
        if not Config.Shops[store].robbed then
            for k, v in pairs(deadPeds) do if k == store then table.remove(deadPeds, k) end end
            TriggerClientEvent('pShop:resetStore', -1, store)
        end
    end
end)

RegisterServerEvent('pShop:handsUp')
AddEventHandler('pShop:handsUp', function(store)
    TriggerClientEvent('pShop:handsUp', -1, store)
end)

RegisterServerEvent('pShop:pickUp')
AddEventHandler('pShop:pickUp', function(store)
    local xPlayer = ESX.GetPlayerFromId(source)
    local randomAmount = math.random(Config.Shops[store].money[1], Config.Shops[store].money[2])
    xPlayer.addMoney(randomAmount)
    TriggerClientEvent('esx:showNotification', source, Translation[Config.Locale]['cashrecieved'] .. ' ~g~' .. randomAmount .. ' ' .. Translation[Config.Locale]['currency'])
    TriggerClientEvent('pShop:removePickup', -1, store) 
end)

ESX.RegisterServerCallback('pShop:canRob', function(source, cb, store)
    local cops = 0
    local xPlayers = ESX.GetPlayers()
    for i = 1, #xPlayers do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'police' or 'sheriff' then
            cops = cops + 1
        end
    end
    if cops >= Config.Shops[store].cops then
        if not Config.Shops[store].robbed and not deadPeds[store] then
            cb(true)
        else
            cb(false)
        end
    else
        cb('no_cops')
    end
end)

RegisterServerEvent('pShop:alertcops')
AddEventHandler('pShop:alertcops', function(store)
    local src = source
    Config.Shops[store].robbed = true
    local xPlayers = ESX.GetPlayers()
    for i = 1, #xPlayers do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'police' or 'sheriff' then
            TriggerClientEvent('pShop:msgPolice', xPlayer.source, store, src)
        end
    end
end)

RegisterServerEvent('pShop:rob')
AddEventHandler('pShop:rob', function(store)
    local src = source
    Config.Shops[store].robbed = true
    local xPlayers = ESX.GetPlayers()
    for i = 1, #xPlayers do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'police' or 'sheriff' then
            TriggerClientEvent('pShop:msgPolice', xPlayer.source, store, src)
        end
    end
    TriggerClientEvent('pShop:rob', -1, store)
    Wait(30000)
    TriggerClientEvent('pShop:robberyOver', src)

    local second = 1000
    local minute = 60 * second
    local hour = 60 * minute
    local cooldown = Config.Shops[store].cooldown
    local wait = cooldown.hour * hour + cooldown.minute * minute + cooldown.second * second
    Wait(wait)
    Config.Shops[store].robbed = false
    for k, v in pairs(deadPeds) do if k == store then table.remove(deadPeds, k) end end
    TriggerClientEvent('pShop:resetStore', -1, store)
end)

Citizen.CreateThread(function()
    while true do
        for i = 1, #deadPeds do TriggerClientEvent('pShop:pedDead', -1, i) end -- update dead peds
        Citizen.Wait(500)
    end
end)