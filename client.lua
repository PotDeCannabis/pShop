ESX = nil
 
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

-- Intéraction [E]

Citizen.CreateThread(function()
    while true do
        local wait = 900
        for k,v in pairs(Config.Positions) do
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, v.x, v.y, v.z)
            if dist <= 5 then 
                wait = 1                                                 
                DrawMarker(6, v.x, v.y, v.z-0.99, nil, nil, nil, -90, nil, nil, 1.0, 1.0, 1.0, 230, 230, 0 , 120)
             end
            if dist <= 2 then
                wait = 1
                Visual.Subtitle("Appuyer sur ~y~[E]~s~ pour accèder à la ~y~Supérette ~s~!", 1) 
                if IsControlJustPressed(1,51) then
                    OpenLocation()
                end
            end 
        end
    Citizen.Wait(wait)
    end
end)

-- Blips

Citizen.CreateThread(function()
    for k, v in pairs(Config.Positions) do
        local pos = Config.Positions
        local Blips = AddBlipForCoord(pos[k].x, pos[k].y, pos[k].z)
        SetBlipSprite(Blips, 59)
        SetBlipColour(Blips, 5)
        SetBlipScale(Blips, 0.7)
        SetBlipAsShortRange(Blips, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString("Supérette 24/7")
        EndTextCommandSetBlipName(Blips)
    Citizen.Wait(1)
    end
end)

-- NPC

CreateThread(function()
    local canCallJob = false
    for k, v in pairs(Config.NPC) do
        RequestModel(GetHashKey(v.typePed))
        while not HasModelLoaded(GetHashKey(v.typePed)) do
            Wait(1)
        end
        local npc = CreatePed(4, v.typePed, v.position.x, v.position.y, v.position.z-0.98, v.heading,  false, true)
        SetPedFleeAttributes(npc, 0, 0)
        SetPedDropsWeaponsWhenDead(npc, false)
        SetPedDiesWhenInjured(npc, false)
        SetEntityInvincible(npc , true)
        FreezeEntityPosition(npc, true)
        SetBlockingOfNonTemporaryEvents(npc, true)
    end
end)

-- Menu

local open = false 
local mainMenu = RageUI.CreateMenu('Supérette 24/7', 'COMMERCE DE PROXIMITÉ')
local mainMenu2 = RageUI.CreateSubMenu(mainMenu, 'Supérette 24/7', 'COMMERCE DE PROXIMITÉ')
local mainMenu3 = RageUI.CreateSubMenu(mainMenu, 'Supérette 24/7', 'COMMERCE DE PROXIMITÉ')
mainMenu.Display.Header = true 
mainMenu.Closed = function()
  FreezeEntityPosition(PlayerPedId(), false)
  open = false
end

function OpenLocation()
    if open then 
        open = false
        RageUI.Visible(mainMenu, false)
        return
    else
        open = true 
        RageUI.Visible(mainMenu, true)
        CreateThread(function()
            while open do 

                RageUI.IsVisible(mainMenu, function() 

                    RageUI.Separator("↓ ~y~ Supérette ~s~↓")

                    RageUI.Button("Liquide", nil, {RightLabel = "→"}, true , {
                        onSelected = function() 
                        end
                    }, mainMenu2)

                    RageUI.Button("Banque", nil, {RightLabel = "→"}, true , {
                        onSelected = function() 
                        end
                    }, mainMenu3)

                end)

                RageUI.IsVisible(mainMenu2, function() 

                    RageUI.Separator("→ Mode de Paiement : ~y~Liquide ~s~ ←")

                    for k,v in pairs(Config.Items) do
                        RageUI.Button(v.Label, nil, {RightLabel = "~y~" ..v.Prix.. "$"}, true , {
                            onSelected = function()
                                Model = v.Model
                                Prix = v.Prix
                                TriggerServerEvent("pShop:achatliquide", Model, Prix)
                            end
                        })
                    end

                end)

                RageUI.IsVisible(mainMenu3, function() 

                    RageUI.Separator("→ Mode de Paiement : ~y~Banque ~s~ ←")

                    for k,v in pairs(Config.Items) do
                        RageUI.Button(v.Label, nil, {RightLabel = "~y~" ..v.Prix.. "$"}, true , {
                            onSelected = function()
                                Model = v.Model
                                Prix = v.Prix
                                TriggerServerEvent("pShop:achatbanque", Model, Prix)
                            end
                        })
                    end

                end)

            Wait(0)
            end
        end)
    end
end

-- Braquage (Not code by Pots#0106)

local ESXLoaded = false
local robbing = false

Citizen.CreateThread(function ()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    ESXLoaded = true
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

local peds = {}
local objects = {}

RegisterNetEvent('pShop:onPedDeath')
AddEventHandler('pShop:onPedDeath', function(store)
    SetEntityHealth(peds[store], 0)
end)

RegisterNetEvent('pShop:msgPolice')
AddEventHandler('pShop:msgPolice', function(store, robber)
    local mugshot, mugshotStr = ESX.Game.GetPedMugshot(GetPlayerPed(GetPlayerFromServerId(robber)))
    ESX.ShowAdvancedNotification(Config.Shops[store].name, Translation[Config.Locale]['robbery'], Translation[Config.Locale]['cop_msg'], mugshotStr, 4)
    UnregisterPedheadshot(mugshot)
    while true do
        local name = GetCurrentResourceName() .. math.random(999)
        AddTextEntry(name, '~INPUT_CONTEXT~ ' .. Translation[Config.Locale]['set_waypoint'] .. '\n~INPUT_FRONTEND_RRIGHT~ ' .. Translation[Config.Locale]['hide_box'])
        DisplayHelpTextThisFrame(name, false)
        if IsControlPressed(0, 38) then
            SetNewWaypoint(Config.Shops[store].coords.x, Config.Shops[store].coords.y)
            return
        elseif IsControlPressed(0, 194) then
            return
        end
        Wait(0)
    end
end)

RegisterNetEvent('pShop:removePickup')
AddEventHandler('pShop:removePickup', function(bank)
    for i = 1, #objects do 
        if objects[i].bank == bank and DoesEntityExist(objects[i].object) then 
            DeleteObject(objects[i].object) 
        end 
    end
end)

RegisterNetEvent('pShop:robberyOver')
AddEventHandler('pShop:robberyOver', function()
    robbing = false
end)

RegisterNetEvent('pShop:talk')
AddEventHandler('pShop:talk', function(store, text, time)
    robbing = false
    local endTime = GetGameTimer() + 1000 * time
    while endTime >= GetGameTimer() do
        local x = GetEntityCoords(peds[store])
        DrawText3D(vector3(x.x, x.y, x.z + 1.0), text)
        Wait(0)
    end
end)

RegisterCommand('animation', function(source, args)
    if args[1] and args[2] then
        loadDict(args[1])
        TaskPlayAnim(PlayerPedId(), args[1], args[2], 8.0, -8.0, -1, 2, 0, false, false, false)
    end
end)

RegisterNetEvent('pShop:rob')
AddEventHandler('pShop:rob', function(i)
    if not IsPedDeadOrDying(peds[i]) then
        SetEntityCoords(peds[i], Config.Shops[i].coords)
        loadDict('mp_am_hold_up')
        TaskPlayAnim(peds[i], "mp_am_hold_up", "holdup_victim_20s", 8.0, -8.0, -1, 2, 0, false, false, false)
        while not IsEntityPlayingAnim(peds[i], "mp_am_hold_up", "holdup_victim_20s", 3) do Wait(0) end
        local timer = GetGameTimer() + 10800
        while timer >= GetGameTimer() do
            if IsPedDeadOrDying(peds[i]) then
                break
            end
            Wait(0)
        end

        if not IsPedDeadOrDying(peds[i]) then
            local cashRegister = GetClosestObjectOfType(GetEntityCoords(peds[i]), 5.0, GetHashKey('prop_till_01'))
            if DoesEntityExist(cashRegister) then
                CreateModelSwap(GetEntityCoords(cashRegister), 0.5, GetHashKey('prop_till_01'), GetHashKey('prop_till_01_dam'), false)
            end

            timer = GetGameTimer() + 200 
            while timer >= GetGameTimer() do
                if IsPedDeadOrDying(peds[i]) then
                    break
                end
                Wait(0)
            end

            local model = GetHashKey('prop_poly_bag_01')
            RequestModel(model)
            while not HasModelLoaded(model) do Wait(0) end
            local bag = CreateObject(model, GetEntityCoords(peds[i]), false, false)
                        
            AttachEntityToEntity(bag, peds[i], GetPedBoneIndex(peds[i], 60309), 0.1, -0.11, 0.08, 0.0, -75.0, -75.0, 1, 1, 0, 0, 2, 1)
            timer = GetGameTimer() + 10000
            while timer >= GetGameTimer() do
                if IsPedDeadOrDying(peds[i]) then
                    break
                end
                Wait(0)
            end
            if not IsPedDeadOrDying(peds[i]) then
                DetachEntity(bag, true, false)
                timer = GetGameTimer() + 75
                while timer >= GetGameTimer() do
                    if IsPedDeadOrDying(peds[i]) then
                        break
                    end
                    Wait(0)
                end
                SetEntityHeading(bag, Config.Shops[i].heading)
                ApplyForceToEntity(bag, 3, vector3(0.0, 50.0, 0.0), 0.0, 0.0, 0.0, 0, true, true, false, false, true)
                table.insert(objects, {bank = i, object = bag})
                Citizen.CreateThread(function()
                    while true do
                        Wait(5)
                        if DoesEntityExist(bag) then
                            if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(bag), true) <= 1.5 then
                                PlaySoundFrontend(-1, 'ROBBERY_MONEY_TOTAL', 'HUD_FRONTEND_CUSTOM_SOUNDSET', true)
                                TriggerServerEvent('pShop:pickUp', i)
                                break
                            end
                        else
                            break
                        end
                    end
                end)
            else
                DeleteObject(bag)
            end
        end
        loadDict('mp_am_hold_up')
        TaskPlayAnim(peds[i], "mp_am_hold_up", "cower_intro", 8.0, -8.0, -1, 0, 0, false, false, false)
        timer = GetGameTimer() + 2500
        while timer >= GetGameTimer() do Wait(0) end
        TaskPlayAnim(peds[i], "mp_am_hold_up", "cower_loop", 8.0, -8.0, -1, 1, 0, false, false, false)
        local stop = GetGameTimer() + 120000
        while stop >= GetGameTimer() do
            Wait(50)
        end
        if IsEntityPlayingAnim(peds[i], "mp_am_hold_up", "cower_loop", 3) then
            ClearPedTasks(peds[i])
        end
    end
end)

RegisterNetEvent('pShop:resetStore')
AddEventHandler('pShop:resetStore', function(i)
    while not ESXLoaded do Wait(0) end
    if DoesEntityExist(peds[i]) then
        DeletePed(peds[i])
    end
    Wait(250)
    peds[i] = _CreatePed(Config.Shopkeeper, Config.Shops[i].coords, Config.Shops[i].heading)
    local brokenCashRegister = GetClosestObjectOfType(GetEntityCoords(peds[i]), 5.0, GetHashKey('prop_till_01_dam'))
    if DoesEntityExist(brokenCashRegister) then
        CreateModelSwap(GetEntityCoords(brokenCashRegister), 0.5, GetHashKey('prop_till_01_dam'), GetHashKey('prop_till_01'), false)
    end
end)

function _CreatePed(hash, coords, heading)
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Wait(5)
    end

    local ped = CreatePed(4, hash, coords, false, false)
    SetEntityHeading(ped, heading)
    SetEntityAsMissionEntity(ped, true, true)
    SetPedHearingRange(ped, 0.0)
    SetPedSeeingRange(ped, 0.0)
    SetPedAlertness(ped, 0.0)
    SetPedFleeAttributes(ped, 0, 0)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetPedCombatAttributes(ped, 46, true)
    SetPedFleeAttributes(ped, 0, 0)
    return ped
end

Citizen.CreateThread(function()
    while not ESXLoaded do Wait(0) end
    for i = 1, #Config.Shops do 
        peds[i] = _CreatePed(Config.Shopkeeper, Config.Shops[i].coords, Config.Shops[i].heading)

        local brokenCashRegister = GetClosestObjectOfType(GetEntityCoords(peds[i]), 5.0, GetHashKey('prop_till_01_dam'))
        if DoesEntityExist(brokenCashRegister) then
            CreateModelSwap(GetEntityCoords(brokenCashRegister), 0.5, GetHashKey('prop_till_01_dam'), GetHashKey('prop_till_01'), false)
        end
    end

    Citizen.CreateThread(function()
        while true do
            for i = 1, #peds do
                if IsPedDeadOrDying(peds[i]) then
                    TriggerServerEvent('pShop:pedDead', i)
                end
            end
            Wait(5000)
        end
    end)

    while true do
        Wait(5)
        local me = PlayerPedId()
        if IsPedArmed(me, 7) then
            if IsPlayerFreeAiming(PlayerId()) then
                for i = 1, #peds do
                    if HasEntityClearLosToEntityInFront(me, peds[i], 19) and not IsPedDeadOrDying(peds[i]) and GetDistanceBetweenCoords(GetEntityCoords(me), GetEntityCoords(peds[i]), true) <= 5.0 then
                        if not robbing then
                            local canRob = nil
                            ESX.TriggerServerCallback('pShop:canRob', function(cb)
                                canRob = cb
                            end, i)
                            while canRob == nil do
                                Wait(0)
                            end
                            if canRob == true then
                                TriggerServerEvent('pShop:alertcops', i)
                                robbing = true
                                Citizen.CreateThread(function()
                                    while robbing do Wait(0) if IsPedDeadOrDying(peds[i]) then robbing = false end end
                                end)
                                loadDict('missheist_agency2ahands_up')
                                TaskPlayAnim(peds[i], "missheist_agency2ahands_up", "handsup_anxious", 8.0, -8.0, -1, 1, 0, false, false, false)

                                local scared = 0
                                while scared < 100 and not IsPedDeadOrDying(peds[i]) and GetDistanceBetweenCoords(GetEntityCoords(me), GetEntityCoords(peds[i]), true) <= 7.5 do
                                    local sleep = 600
                                    SetEntityAnimSpeed(peds[i], "missheist_agency2ahands_up", "handsup_anxious", 1.0)
                                    if IsPlayerFreeAiming(PlayerId()) then
                                        sleep = 250
                                        SetEntityAnimSpeed(peds[i], "missheist_agency2ahands_up", "handsup_anxious", 1.3)
                                    end
                                    if IsPedArmed(me, 4) and GetAmmoInClip(me, GetSelectedPedWeapon(me)) > 0 and IsControlPressed(0, 24) then
                                        sleep = 50
                                        SetEntityAnimSpeed(peds[i], "missheist_agency2ahands_up", "handsup_anxious", 1.7)
                                    end
                                    sleep = GetGameTimer() + sleep
                                    while sleep >= GetGameTimer() and not IsPedDeadOrDying(peds[i]) do
                                        Wait(0)
                                        DrawRect(0.5, 0.5, 0.2, 0.03, 75, 75, 75, 200)
                                        local draw = scared/500
                                        DrawRect(0.5, 0.5, draw, 0.03, 0, 221, 255, 200)
                                    end
                                    scared = scared + 1
                                end
                                if GetDistanceBetweenCoords(GetEntityCoords(me), GetEntityCoords(peds[i]), true) <= 7.5 then
                                    if not IsPedDeadOrDying(peds[i]) then
                                        TriggerServerEvent('pShop:rob', i)
                                        while robbing do Wait(0) if IsPedDeadOrDying(peds[i]) then robbing = false end end
                                    end
                                else
                                    ClearPedTasks(peds[i])
                                    local wait = GetGameTimer()+5000
                                    while wait >= GetGameTimer() do
                                        Wait(0)
                                        DrawText3D(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 1.5, 0.4), Translation[Config.Locale]['walked_too_far'])
                                    end
                                    robbing = false
                                end
                            elseif canRob == 'no_cops' then
                                local wait = GetGameTimer()+5000
                                while wait >= GetGameTimer() do
                                    Wait(0)
                                    DrawText3D(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 1.5, 0.4), Translation[Config.Locale]['no_cops'])
                                end
                            else
                                TriggerEvent('pShop:talk', i, '~r~' .. Translation[Config.Locale]['robbed'], 5)
                                Wait(2500)
                            end
                        end
                    end
                end
            end
        end
    end
end)

loadDict = function(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(10)
    end
end

function DrawText3D(coords, text)
    local onScreen, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z)
    local pX, pY, pZ = table.unpack(GetGameplayCamCoords())
  
    SetTextScale(0.4, 0.4)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextEntry("STRING")
    SetTextCentre(1)
    SetTextColour(255, 255, 255, 255)
    SetTextOutline()
  
    AddTextComponentString(text)
    DrawText(_x, _y)
end