

fx_version 'bodacious'
lua54 'yes'
game 'gta5'
-- DISCORD> discord.gg/bUVnmBqUNf
-- JOIN DISCORD FOR MORE FREE SCRIPTS
--[[ Resource Information ]]--

author 'steaxscripts.com'
version '1.0.0'
scriptname 'wais-leaderboardv2'

--[[ Resource Information ]]--

client_scripts {
    'config.lua',
    'client.lua',
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'config.lua',
    'server.lua'
}

escrow_ignore {
    'config.lua',
    'client.lua',
    'server.lua',
}

ui_page "html/dist/index.html"
files {
    'html/dist/*.js',
    'html/dist/index.html',

    'html/public/*.png',
    'html/public/*.json',
    'html/public/css/*.*',
    'html/public/fonts/*.*',
    'html/public/images/*.*',
}

dependency '/assetpacks'