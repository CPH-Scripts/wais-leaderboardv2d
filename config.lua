-- DISCORD> discord.gg/bUVnmBqUNf
Config = {}
Config.DefaultStatusMessage = "Sponsored by Ayazwai"
Config.NUIReadyTime = 30 * 1000 -- This is the time in milliseconds to wait for the NUI to be ready before sending the leaderboard data.
Config.MenuOpenKey = 166 -- This is the key code to open the leaderboard menu. You can find the key codes here: https://docs.fivem.net/docs/game-references/controls/

Config.Debug = false
Config.Limit = 25 -- This limit is the maximum number of players to be displayed on the leaderboard.
Config.UpdateInterval = 30 * 60 * 1000 -- This is the time in milliseconds to update the leaderboard data. 5 Min = 5 * 60 * 1000
Config.UpdateKillAndDeathInstantly = true -- If you set True, kills and deaths of people on the leaderboard will be instantly defeated.
Config.Xss = {
    "script",
    "jQuery",
    "jquery",
    "eval",
    "src",
    "href",
    "onload",
    "onerror",
    "javascript",
}

--[[
    DEBUG => If you set debug mode to true, you can see server-side data streams and instant transactions
    IMPORTANT => The higher the limit, the larger the data size the server will send to the player. Thus, your server may crash with network problems. It can throw players out of the server.
    IMPORTANT => UpdateInterval 30 minutes or 1 hour if possible. I do not recommend less than 10 minutes. 1 * 60 * 60 * 1000 = 1 Hours, 30 * 60 * 1000 = 30 Minutes
    INFORMATION => If you make the UpdateKillAndDeathInstantly Variable true, the death or killing of the people in the table will be instantly renewed and will also be recorded instantly in sql. 
--]]