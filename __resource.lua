resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"
dependency "connectqueue"
server_scripts {
	"@connectqueue/connectqueue.lua",
	'@mysql-async/lib/MySQL.lua',
	"server.lua",
} 

server_export 'isPlayerADonator'