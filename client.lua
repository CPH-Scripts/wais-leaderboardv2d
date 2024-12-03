
-- DISCORD> discord.gg/bUVnmBqUNf
-- JOIN DISCORD FOR MORE FREE SCRIPTS


local playerStats, boardData = {}, {}
local menuState, nuiready, nuiWait = false, false, Config.NUIReadyTime

-----------------------------------------------------------------------------------------
-- EVENT'S --
-----------------------------------------------------------------------------------------

RegisterNetEvent('wais:leaderboardv2:sendData', function(playerData, boardDatas)
    while not nuiready do
        nuiWait = nuiWait - 1000
        if nuiWait <= 0 then
            print("NUI is not ready")
            return
        end
        Wait(1000)
    end

    boardData = boardDatas
    playerStats = playerData
    nuiWait = Config.NUIReadyTime

    SendNUIMessage({
        type = 'SET_DATA',
        board = boardDatas,
        player = playerData,
    })
end)

RegisterNetEvent('wais:leaderboardv2:updateBoard', function(boardData)
    SendNUIMessage({
        type = 'UPDATE_BOARD',
        board = boardData,
    })
end)

RegisterNetEvent('wais:add:kill', function()
    playerStats.kills = playerStats.kills + 1
    SendNUIMessage({
        type = 'UPDATE_KILL',
        kills = playerStats.kills,
    })
end)

RegisterNetEvent('wais:add:death', function()
    playerStats.deaths = playerStats.deaths + 1
    SendNUIMessage({
        type = 'UPDATE_DEATH',
        deaths = playerStats.deaths,
    })
end)

RegisterNetEvent('wais:add:boardKill', function(hex)
    SendNUIMessage({
        type = 'UPDATE_BOARD_KILL',
        hex = hex,
    })
end)

RegisterNetEvent('wais:add:boardDeath', function(hex)
    SendNUIMessage({
        type = 'UPDATE_BOARD_DEATH',
        hex = hex,
    })
end)

RegisterNetEvent('wais:add:boardRow', function(hex, data)
    boardData[hex] = data
    SendNUIMessage({
        type = 'ADD_BOARD_ROW',
        hex = hex,
        data = data,
    })
end)

RegisterNetEvent('wais:leaderboardv2:changeProfile:cl', function(hex, data)
    if boardData[hex] ~= nil then
        boardData[hex].profile.status = data.status
        boardData[hex].profile.banner = data.banner

        SendNUIMessage({
            type = 'UPDATE_BOARD_PROFILE',
            hex = hex,
            data = data,
        })
    end
    
    if playerStats.identifier == hex then
        playerStats.profile.status = data.status
        playerStats.profile.banner = data.banner

        SendNUIMessage({
            type = 'UPDATE_PROFILE',
            data = data,
        })
    end
end)

AddEventHandler('gameEventTriggered', function(e, data)
    if e == "CEventNetworkEntityDamage" then
        local victim, attacker, victimDied = data[1], data[2], (data[6] == 1 and true or false)
        if victim == attacker then return end
        if victim == -1 or attacker == -1 then return end
        if not IsPedAPlayer(victim) then return end

        if victimDied and NetworkGetPlayerIndexFromPed(victim) ~= PlayerId() then
            local victimId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(victim))
            local attackerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(attacker))
            TriggerServerEvent('wais:player:dead', attackerId, victimId)
        end
    end
end)

-----------------------------------------------------------------------------------------
-- NUI CALLBACK'S --
-----------------------------------------------------------------------------------------

RegisterNUICallback('ready', function(_, cb)
    nuiready = true
    cb('ok')
end)

RegisterNUICallback('close', function(_, cb)
    closeUI()
    cb('ok')
end)

RegisterNUICallback('changeProfile', function(data, cb)
    if not checkXss(data) then
        TriggerServerEvent('wais:leaderboardv2:changeProfile', data)
    end
    cb('ok')
end)

-----------------------------------------------------------------------------------------
-- FUNCTION'S --
-----------------------------------------------------------------------------------------

function openUI()
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = "OPEN_UI",
    })
end

function closeUI()
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = "HIDE_UI",
    })
end

function checkXss(data)
    for i = 1, #Config.Xss do
        if string.match(data.status, Config.Xss[i]) then
            return true
        end
    end
    return false
end

-----------------------------------------------------------------------------------------
-- COMMAND'S --
-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
-- THREAD'S --
-----------------------------------------------------------------------------------------

CreateThread(function()
    while true do
        local sleep = 5
        if IsControlJustPressed(0, Config.MenuOpenKey) then
            openUI()
        end
    
        Wait(sleep)
    end
end)

CreateThread(function()
    while true do
        local sleep = 1000
        if NetworkIsSessionStarted() then
            TriggerServerEvent('wais:leaderboardv2:getData')
            break
        end
        Wait(sleep)
    end
end)

-----------------------------------------------------------------------------------------
-- EXPORT'S --
-----------------------------------------------------------------------------------------