/**
 * ExileClient_gui_wasteDumpDialog_show
 */
 
private["_nearVehicles","_localVehicles","_display","_revenue","_sellButton","_dropdown","_vehicleObject","_vehicleName","_index"];
disableSerialization;
_nearVehicles = nearestObjects [player, ["LandVehicle", "Air", "Ship"], 150];
_localVehicles = [];
{
	_vehicleInfo = _x getVariable ["XG_AntiTheftInfo",[]];
	if!(_vehicleInfo isEqualTo []) then
	{
		_vehicleInfo params [["_group",""],["_vifamily","No Family"],["_ownerUID",""]];
		_family = player getVariable ["ExileClanID",""];
		if(_family isEqualTo -1) then
		{
			_family = "No Family";
		};
		if(_group isEqualTo "No Group") then
		{
			if!(_family isEqualTo "No Family") then
			{
				if((_family isEqualTo _vifamily) || (getPlayerUID player) isEqualTo _ownerUID) then
				{
					if (local _x) then {_localVehicles pushBack _x;};
				};
			}
			else
			{
				if((getPlayerUID player) isEqualTo _ownerUID) then
				{
					if (local _x) then {_localVehicles pushBack _x;};
				};
			};
		}
		else
		{
			if!(_family isEqualTo "No Family") then
			{
				if((str(group player) isEqualTo _group) || (_family isEqualTo _vifamily) || (getPlayerUID player) isEqualTo _ownerUID) then
				{
					if (local _x) then {_localVehicles pushBack _x;};
				};
			}
			else
			{
				if((str(group player) isEqualTo _group) || (getPlayerUID player) isEqualTo _ownerUID) then
				{
					if (local _x) then {_localVehicles pushBack _x;};
				};
			};
		};
	}
	else
	{
		if (local _x) then
		{
			if (alive _x) then
			{
				_localVehicles pushBack _x;
			};
		};
	};
}
forEach _nearVehicles;
if (_localVehicles isEqualTo []) exitWith
{
	["ErrorTitleAndText", ["Whoops!", "Park within 50m and get in as driver first."]] call ExileClient_gui_toaster_addTemplateToast;
};
ExileClientCurrentTrader = _this;
createDialog "RscExileWasteDumpDialog";
waitUntil { !isNull findDisplay 24011 };
_display = uiNameSpace getVariable ["RscExileWasteDumpDialog", displayNull];
_revenue = _display displayCtrl 4001;
_revenue ctrlSetStructuredText (parseText "<t size='1.4'>0<img image='\exile_assets\texture\ui\poptab_notification_ca.paa' size='1' shadow='true' /></t>");
_sellButton = _display displayCtrl 4000;
_sellButton ctrlEnable false;
_dropdown = _display displayCtrl 4002;
lbClear _dropdown;
{
	_vehicleObject = _x;
	_vehicleName = getText(configFile >> "CfgVehicles" >> (typeOf _vehicleObject) >> "displayName");
	_index = _dropdown lbAdd (format ["Cargo: %1", _vehicleName]);
	_dropdown lbSetData [_index, netId _vehicleObject];
	_dropdown lbSetValue [_index, 1];
	_index = _dropdown lbAdd (format ["Vehicle + Cargo: %1", _vehicleName]);
	_dropdown lbSetData [_index, netId _vehicleObject];
	_dropdown lbSetValue [_index, 2];
}
forEach _localVehicles;
true call ExileClient_gui_postProcessing_toggleDialogBackgroundBlur;
true