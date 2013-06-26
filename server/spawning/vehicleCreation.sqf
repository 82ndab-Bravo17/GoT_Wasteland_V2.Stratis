//	@file Version: 1.1
//	@file Name: vehicleCreation.sqf
//	@file Author: [404] Deadbeat, modded by AgentRev
//	@file Created: 20/11/2012 05:19
//	@file Args: markerPos [, carType]

if(!X_Server) exitWith {};

private ["_markerPos","_pos","_type","_num","_cartype","_car","_debug"];

_markerPos = _this select 0;
_cartype = _this select 1;

if (count _this > 1) then
{
	
	if (_cartype in civilianVehicles) then { _type = 0 };
	if (_cartype in lightMilitaryVehicles) then { _type = 1 };
	if (_cartype in mediumMilitaryVehicles) then { _type = 2 };
}
else
{
	_num = floor (random 100);

	if (_num < 100) then { _cartype = civilianVehicles call BIS_fnc_selectRandom; _type = 0 };
	if (_num < 70) then { _cartype = lightMilitaryVehicles call BIS_fnc_selectRandom; _type = 1 };
	if (_num < 25) then { _cartype = mediumMilitaryVehicles call BIS_fnc_selectRandom; _type = 2 };
};

		//debug line added by JoSchaap to find an issue (you should NOT use my debug builds on your server!)
		_debug = (if (_type == 1) then { 2 } else { 5 });
		diag_log format["--DEBUG-- [vehicleCreation] call findsafepos with args: [%1, 1, 35, %2, 0, 60 * (pi / 180), 0, [], [%1]] --DEBUG--", _markerPos, _debug]; 
		//end of debug line added by JoSchaap (you should NOT use my debug builds on your server!)

_pos = [_markerPos, 1, 35, ( if (_type == 1) then { 2 } else { 5 } ), 0, 60 * (pi / 180), 0, [], [_markerPos]] call BIS_fnc_findSafePos;

//Car Initialization
_car = createVehicle [_cartype,_pos, [], 0, "None"];
[_car, 1800, 3600, 0, false, _markerPos] execVM "server\functions\vehicle.sqf";

//Clear Cars Inventory
clearMagazineCargoGlobal _car;
clearWeaponCargoGlobal _car;

//Set Cars Attributes
_car setFuel (0.50);
_car setDamage (random 0.50);

if (_type in [0,1]) then
{
	_car setHit ["wheel_1_1_steering", 0];
	_car setHit ["wheel_1_2_steering", 0];
	_car setHit ["wheel_2_1_steering", 0];
	_car setHit ["wheel_2_2_steering", 0];
};

_car setDir (random 360);
if (_type > 1) then { _car setVehicleAmmo (random 0.90) };
_car disableTIEquipment true;
[_car] call randomWeapons;

//Set original posistion then add to vehicle array
_car setVariable ["vehicleChecksum",call vChecksum,true]; 
_car setPosATL [getpos _car select 0,getpos _car select 1,1];
_car setVelocity [0,0,0];
