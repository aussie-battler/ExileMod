if (!isServer) exitWith {};

_logDetail = format['[OCCUPATION:Sky] Started'];
[_logDetail] call SC_fnc_log;

// more than _scaleAI players on the server and the max AI count drops per additional player
_currentPlayerCount = count playableUnits;
_maxAIcount 		= SC_maxAIcount;

if(_currentPlayerCount > SC_scaleAI) then 
{
	_maxAIcount = _maxAIcount - (_currentPlayerCount - SC_scaleAI) ;
};

// Don't spawn additional AI if the server fps is below _minFPS
if(diag_fps < SC_minFPS) exitWith 
{ 
    _logDetail = format ["[OCCUPATION:Sky]:: Held off spawning more AI as the server FPS is only %1",diag_fps]; 
    [_logDetail] call SC_fnc_log; 
};

_aiActive = {alive _x && (side _x == EAST OR side _x == WEST)} count allUnits;
if(_aiActive > _maxAIcount) exitWith 
{ 
    _logDetail = format ["[OCCUPATION:Sky]:: %1 active AI, so not spawning AI this time",_aiActive]; 
    [_logDetail] call SC_fnc_log; 
};

if(SC_liveHelis >= SC_maxNumberofHelis) exitWith 
{
    if(SC_extendedLogging) then 
    { 
        _logDetail = format['[OCCUPATION:Sky] End check %1 currently active (max %2) @ %3',SC_liveHelis,SC_maxNumberofHelis,time]; 
        [_logDetail] call SC_fnc_log;
    };    
};

_vehiclesToSpawn = (SC_maxNumberofHelis - SC_liveHelis);
_middle = worldSize/2;
_spawnCenter = [_middle,_middle,0];
_maxDistance = _middle;

_locations = (nearestLocations [_spawnCenter, ["NameVillage","NameCity", "NameCityCapital"], _maxDistance]);
_i = 0;
{
	_okToUse = true;
	_pos = position _x;	
	_nearestMarker = [allMapMarkers, _pos] call BIS_fnc_nearestPosition; // Nearest Marker to the Location		
	_posNearestMarker = getMarkerPos _nearestMarker;
	if(_pos distance _posNearestMarker < 2500) exitwith { _okToUse = false; };

	if(!_okToUse) then
	{
		_locations deleteAt _i;
	};
	_i = _i + 1;
	sleep 0.2;

} forEach _locations;

for "_i" from 1 to _vehiclesToSpawn do
{
	private["_group"];
	_Location = _locations call BIS_fnc_selectRandom;
	_pos = position _Location;	
	_position = [_pos select 0, _pos select 1, 300];
	_safePos = [_position,10,100,5,0,20,0] call BIS_fnc_findSafePos;
	_height = 350 + (round (random 200));
	_spawnLocation = [_safePos select 0, _safePos select 1, _height];
   
    _group = createGroup east;
    _VehicleClassToUse = SC_HeliClassToUse call BIS_fnc_selectRandom;
    _vehicle = createVehicle [_VehicleClassToUse, _spawnLocation, [], 0, "NONE"];
    _group addVehicle _vehicle;
    _vehicle setVariable["vehPos",_spawnLocation,true];
    _vehicle setVariable["vehClass",_VehicleClassToUse,true];
    _vehicle setVariable ["SC_vehicleSpawnLocation", _spawnLocation,true];

    SC_liveHelis = SC_liveHelis + 1;
    SC_liveHelisArray = SC_liveHelisArray + [_vehicle];

    _vehicle setVehiclePosition [_spawnLocation, [], 0, "FLY"];
	_vehicle setVariable ["vehicleID", _spawnLocation, true];  
	_vehicle setFuel 1;
	_vehicle setDamage 0;
	_vehicle engineOn true;
	_vehicle flyInHeight 150;
    _vehicle lock 0;			
    _vehicle setVehicleLock "UNLOCKED";
    _vehicle setVariable ["ExileIsLocked", 0, true];
    _vehicle action ["LightOn", _vehicle];
    	
      
        
    // Calculate the crew requried
    _vehicleRoles = (typeOf _vehicle) call bis_fnc_vehicleRoles;
    {
        _vehicleRole = _x select 0;
        _vehicleSeat = _x select 1;
        if(_vehicleRole == "Driver") then
        {
            _unit = [_group,_spawnLocation,"assault","random","bandit","Vehicle"] call DMS_fnc_SpawnAISoldier;   
            _unit assignAsDriver _vehicle;
            _unit moveInDriver _vehicle;
            //_vehicle lockDriver true;
            _unit setVariable ["DMS_AssignedVeh",_vehicle]; 
            removeBackpackGlobal _unit;
            _unit addBackpackGlobal "B_Parachute";
        };
        if(_vehicleRole == "Turret") then
        {
            _unit = [_group,_spawnLocation,"assault","random","bandit","Vehicle"] call DMS_fnc_SpawnAISoldier;   
            _unit moveInTurret [_vehicle, _vehicleSeat];
            _unit setVariable ["DMS_AssignedVeh",_vehicle]; 
            removeBackpackGlobal _unit;
            _unit addBackpackGlobal "B_Parachute";
        };
        if(_vehicleRole == "CARGO") then
        {
            _unit = [_group,_spawnLocation,"assault","random","bandit","Vehicle"] call DMS_fnc_SpawnAISoldier;   
            _unit assignAsCargo _vehicle; 
            _unit moveInCargo _vehicle;
            _unit setVariable ["DMS_AssignedVeh",_vehicle];
            removeBackpackGlobal _unit;
            _unit addBackpackGlobal "B_Parachute";
        };  
        if(SC_extendedLogging) then 
        { 
            _logDetail = format['[OCCUPATION:Sky] %1 added to %2',_vehicleRole,_vehicle]; 
            [_logDetail] call SC_fnc_log;
        };                    
    } forEach _vehicleRoles;

    {	
        _unit = _x;
        [_unit] joinSilent grpNull;
        [_unit] joinSilent _group;
    }foreach units _group;

	if(SC_infiSTAR_log) then 
	{ 
		_logDetail = format['[OCCUPATION:Sky] %1 spawned @ %2',_VehicleClassToUse,_spawnLocation];	
		[_logDetail] call SC_fnc_log;
	};


	
	clearMagazineCargoGlobal _vehicle;
	clearWeaponCargoGlobal _vehicle;
	clearItemCargoGlobal _vehicle;

	_vehicle addMagazineCargoGlobal ["HandGrenade", (random 2)];
	_vehicle addItemCargoGlobal  ["ItemGPS", (random 1)];
	_vehicle addItemCargoGlobal  ["Exile_Item_InstaDoc", (random 1)];
	_vehicle addItemCargoGlobal ["Exile_Item_PlasticBottleFreshWater", 2 + (random 2)];
	_vehicle addItemCargoGlobal ["Exile_Item_EMRE", 2 + (random 2)];
	
	// Add weapons with ammo to the vehicle
	_possibleWeapons = 
	[			
		"arifle_MXM_Black_F",
		"arifle_MXM_F",
		"srifle_DMR_01_F",
		"srifle_DMR_02_camo_F",
		"srifle_DMR_02_F",
		"srifle_DMR_02_sniper_F",
		"srifle_DMR_03_F",
		"srifle_DMR_03_khaki_F",
		"srifle_DMR_03_multicam_F",
		"srifle_DMR_03_tan_F",
		"srifle_DMR_03_woodland_F",
		"srifle_DMR_04_F",
		"srifle_DMR_04_Tan_F",
		"srifle_DMR_05_blk_F",
		"srifle_DMR_05_hex_F",
		"srifle_DMR_05_tan_f",
		"srifle_DMR_06_camo_F",
		"srifle_DMR_06_olive_F",
		"srifle_EBR_F",
		"srifle_GM6_camo_F",
		"srifle_GM6_F",
		"srifle_LRR_camo_F",
		"srifle_LRR_F"
	];
	_amountOfWeapons = 1 + (random 3);
	
	for "_i" from 1 to _amountOfWeapons do
	{
		_weaponToAdd = _possibleWeapons call BIS_fnc_selectRandom;
		_vehicle addWeaponCargoGlobal [_weaponToAdd,1];
	   
		_magazinesToAdd = getArray (configFile >> "CfgWeapons" >> _weaponToAdd >> "magazines");
		_vehicle addMagazineCargoGlobal [(_magazinesToAdd select 0),round random 3];
	};

	
	[_group, _spawnLocation, 2000] call bis_fnc_taskPatrol;
	_group setBehaviour "AWARE";
	_group setCombatMode "RED";
	_vehicle addEventHandler ["getin", "_this call SC_fnc_claimVehicle;"];	
	_vehicle addMPEventHandler ["mpkilled", "_this call SC_fnc_vehicleDestroyed;"];
	_vehicle addMPEventHandler ["mphit", "_this call SC_fnc_airHit;"];
	_vehicle setVariable ["SC_crewEjected", false,true];	
	sleep 0.2;
	
};


_logDetail = format['[OCCUPATION:Sky] Running'];
[_logDetail] call SC_fnc_log;