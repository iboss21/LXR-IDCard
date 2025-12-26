fx_version 'cerulean'
game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

author 'The Land of Wolves'
description 'Immersive Citizenship ID Card System - The Land of Wolves'
version '3.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'locales/init.lua',
    'locales/*.lua',
    'config.lua'
}

client_scripts {
    'client/main.lua',
    'client/features.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
    'server/api.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/features.html',
    'html/style.css',
    'html/features.css',
    'html/script.js',
    'html/features.js',
    'html/assets/*.png',
    'html/assets/*.jpg',
    'html/assets/*.ogg',
    'html/assets/fonts/*.ttf'
}

dependencies {
    'rsg-core',
    'rsg-inventory',
    'ox_lib',
    'ox_target',
    'oxmysql'
}

lua54 'yes'
