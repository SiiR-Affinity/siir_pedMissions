fx_version 'cerulean'
game 'gta5'
author 'SiiR'
description 'https://github.com/SiiR-Affinity/siir_pedMissions'
version '1.0.0'

dependency 'es_extended'

shared_scripts {
	'@es_extended/imports.lua',
	'@es_extended/locale.lua',
	'locales/*.lua',
	'config.lua',
	'shared/*.lua'
}

server_scripts {
	'server/*.lua'
}

client_scripts {
	'client/*.lua'
}

ui_page 'ui/index.html'

files {
	'ui/*.html',
	'ui/*.css',
	'ui/*.js'
}