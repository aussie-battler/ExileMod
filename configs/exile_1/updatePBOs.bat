@echo off

set srvname=@ExileServer
:: Creating New Pbos
"C:\Program Files\PBO Manager v.1.4 beta\PBOConsole.exe" -pack "C:\ExileMod\maps\Tanoa" "D:\a3Server\mpmissions\GG_exile_1.Tanoa.pbo"
"C:\Program Files\PBO Manager v.1.4 beta\PBOConsole.exe" -pack "C:\ExileMod\addons\exile_server" "D:\a3Server\%srvname%\addons\exile_server.pbo"
"C:\Program Files\PBO Manager v.1.4 beta\PBOConsole.exe" -pack "C:\ExileMod\addons\exile_server_config" "D:\a3Server\%srvname%\addons\exile_server_config.pbo"
"C:\Program Files\PBO Manager v.1.4 beta\PBOConsole.exe" -pack "C:\ExileMod\addons\a3_infiSTAR_Exile" "D:\a3Server\%srvname%\addons\a3_infiSTAR_Exile.pbo"
"C:\Program Files\PBO Manager v.1.4 beta\PBOConsole.exe" -pack "C:\ExileMod\addons\a3_dms" "D:\a3Server\%srvname%\addons\a3_dms.pbo"
"C:\Program Files\PBO Manager v.1.4 beta\PBOConsole.exe" -pack "C:\ExileMod\addons\a3_zcp_exile" "D:\a3Server\%srvname%\addons\a3_zcp_exile.pbo"
"C:\Program Files\PBO Manager v.1.4 beta\PBOConsole.exe" -pack "C:\ExileMod\addons\exad_core" "D:\a3Server\%srvname%\addons\exad_core.pbo"
"C:\Program Files\PBO Manager v.1.4 beta\PBOConsole.exe" -pack "C:\ExileMod\addons\exad_dv" "D:\a3Server\%srvname%\addons\exad_dv.pbo"
"C:\Program Files\PBO Manager v.1.4 beta\PBOConsole.exe" -pack "C:\ExileMod\addons\exad_hacking" "D:\a3Server\%srvname%\addons\exad_hacking.pbo"
"C:\Program Files\PBO Manager v.1.4 beta\PBOConsole.exe" -pack "C:\ExileMod\addons\exad_vg" "D:\a3Server\%srvname%\addons\exad_vg.pbo"
"C:\Program Files\PBO Manager v.1.4 beta\PBOConsole.exe" -pack "C:\ExileMod\addons\Anti-Theft_Server" "D:\a3Server\%srvname%\addons\Anti-Theft_Server.pbo"
"C:\Program Files\PBO Manager v.1.4 beta\PBOConsole.exe" -pack "C:\ExileMod\addons\server_buildings" "D:\a3Server\%srvname%\addons\server_buildings.pbo"
"C:\Program Files\PBO Manager v.1.4 beta\PBOConsole.exe" -pack "C:\ExileMod\addons\MarXet_Server" "D:\a3Server\%srvname%\addons\MarXet_Server.pbo"
"C:\Program Files\PBO Manager v.1.4 beta\PBOConsole.exe" -pack "C:\ExileMod\addons\a3_exile_occupation" "D:\a3Server\%srvname%\addons\a3_exile_occupation.pbo"
"C:\Program Files\PBO Manager v.1.4 beta\PBOConsole.exe" -pack "C:\ExileMod\addons\XG_killboard" "D:\a3Server\%srvname%\addons\XG_killboard.pbo"
"C:\Program Files\PBO Manager v.1.4 beta\PBOConsole.exe" -pack "C:\ExileMod\addons\AVS" "D:\a3Server\%srvname%\addons\AVS.pbo"
"C:\Program Files\PBO Manager v.1.4 beta\PBOConsole.exe" -pack "C:\ExileMod\addons\GG_SecretCode" "D:\a3Server\%srvname%\addons\GG_SecretCode.pbo"
"C:\Program Files\PBO Manager v.1.4 beta\PBOConsole.exe" -pack "C:\ExileMod\addons\ClaimVehicles_Server" "D:\a3Server\%srvname%\addons\ClaimVehicles_Server.pbo"

echo Creating new PBOs 

cls
@exit