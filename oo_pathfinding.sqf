	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2014 Nicolas BOITEUX

	CLASS OO_PATHFINDING
	
	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.
	
	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.
	
	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>. 
	*/

	#include "oop.h"

	CLASS("OO_PATHFINDING")
		PRIVATE VARIABLE("code","grid");
	
		PUBLIC FUNCTION("string","constructor") {
			private ["_grid"];
	
			_grid = ["new", [31000,31000,100,100]] call OO_GRID;

			MEMBER("grid", _grid);
		};

		PUBLIC FUNCTION("object", "sizeOfRoad") {
			private ["_br0", "_br1", "_maxwidth", "_maxlength", "_myarea"];

			_br0 = (boundingboxreal _this) select 0;
			_br1 = (boundingBoxReal _this) select 1;
			_maxwidth = abs ((_br1 select 0) - (_br0 select 0));
			_maxlength = abs ((_br1 select 1) - (_br0 select 1));
			_myarea = floor (_maxwidth * _maxlength);
			_myarea;
		};

		PUBLIC FUNCTION("array", "heuristic") {
			private ["_goal", "_next"];

			_goal = _this select 0;
			_next = _this select 1;

			abs((_goal select 0) - (_next select 0)) + abs((_goal select 1) - (_next select 1));
		};

		// Path finding - find the best way between one sector and other
		PUBLIC FUNCTION("array", "getPath_GreedyBestFirst") {
			private ["_start", "_end", "_frontier", "_current", "_path", "_grid", "_hashmap", "_position", "_heuristic", "_index", "_value"];

			_start = _this select 0;
			_end = _this select 1;

			_grid = MEMBER("grid", nil);
			
			_hashmap = ["new", []] call OO_HASHMAP;
			_frontier = ["new", ""] call OO_QUEUE;

			_start = ["getSectorFromPos", _start] call _grid;
			_end = ["getSectorFromPos", _end] call _grid;

			["put", [0, _start]] call _frontier;
			["put", [str(_start), _start]] call _hashmap;


			while {!("isEmpty" call _frontier)} do {
				_current = ["get", ""] call _frontier;
				_arounds = ["getSectorAround", _current] call _grid;
				{
					_position = ["getPosFromSector", _x] call _grid;
					_list = _position nearRoads 50;
					if(count _list > 0) then {
						_result = ["containsKey", str(_x)] call _hashmap;
						if(!_result)then {
							_array = [_x, _end];
							_heuristic = MEMBER("heuristic", _array);
							["put", [_heuristic, _x]] call _frontier;
							["put", [str(_x), _current]] call _hashmap;
							["DrawSector", [_current, str(_heuristic)]] call _grid;
						};
					};
					sleep 0.000001;
				}foreach _arounds;
				if(_current isequalto _end) then {"clearQueue" call _frontier;};
			};

			_path = [];

			while {!(_current isequalto _start)} do {
				_path = _path + [_current];
				_current = ["get", str(_current)] call _hashmap;
				sleep 0.000001;
			};
			_path = _path + [_current];

			reverse _path;

			{
				["DrawSector2", _x] call _grid;
			}foreach _path;

			["delete", _hashmap] call OO_HASHMAP;
			["delete", _frontier] call OO_QUEUE;

			_path;
		};		

		// Path finding - find the best way between one sector and other
		PUBLIC FUNCTION("array", "getPath_Dijkstra") {
			private ["_start", "_end", "_frontier", "_current", "_path", "_grid", "_hashmap", "_position", "_heuristic", "_costsofar", "_newcost", "_result", "_queue"];

			_start = _this select 0;
			_end = _this select 1;

			_grid = MEMBER("grid", nil);
			_hashmap = ["new", []] call OO_HASHMAP;
			_costsofar = ["new", []] call OO_HASHMAP;
			_frontier = ["new", ""] call OO_QUEUE;

			_start = ["getSectorFromPos", _start] call _grid;
			_end = ["getSectorFromPos", _end] call _grid;

			["put", [str(_start), _start]] call _hashmap;
			["put", [str(_start), 0]] call _costsofar;
			["put", [0, _start]] call _frontier;

			while {!("isEmpty" call _frontier)} do {
				_current = ["get", ""] call _frontier;
				_arounds = ["getSectorAround", _current] call _grid;
				
				{
					_position = ["getPosFromSector", _x] call _grid;
					_list = _position nearRoads 50;
					if(count _list > 0) then {
						_newcost = (["get", str(_current)] call _costsofar) + 1;
						_result = false;
						if(["containsKey", str(_x)] call _costsofar) then {
							if(_newcost < (["get", str(_x)] call _costsofar)) then {
								_result = true;
							};
						} else {
							_result = true;
						};
						if (_result) then {
							["put", [str(_x), _newcost]] call _costsofar;
							["put", [_newcost, _x]] call _frontier;
							["put", [str(_x), _current]] call _hashmap;
							["DrawSector", [_current, str(_newcost)]] call _grid;
						};
					};
					sleep 0.000001;
				}foreach _arounds;
				if(_current isequalto _end) then {"clearQueue" call _frontier;};
			};

			_path = [];

			while {!(_current isequalto _start)} do {
				_path = _path + [_current];
				_current = ["get", str(_current)] call _hashmap;
				sleep 0.000001;
			};
			_path = _path + [_current];

			reverse _path;

			{
				["DrawSector2", _x] call _grid;
			}foreach _path;
			
			["delete", _costsofar] call OO_HASHMAP;
			["delete", _hashmap] call OO_HASHMAP;
			["delete", _frontier] call OO_QUEUE;

			_path;
		};	

		// Path finding - find the best way between one sector and other
		PUBLIC FUNCTION("array", "getPath_A") {
			private ["_start", "_end", "_frontier", "_current", "_path", "_grid", "_hashmap", "_position", "_heuristic", "_costsofar", "_newcost", "_result", "_queue", "_array", "_heuristic", "_priority", "_size"];

			_start = _this select 0;
			_end = _this select 1;

			_grid = MEMBER("grid", nil);
			_hashmap = ["new", []] call OO_HASHMAP;
			_costsofar = ["new", []] call OO_HASHMAP;
			_frontier = ["new", ""] call OO_QUEUE;

			_start = ["getSectorFromPos", _start] call _grid;
			_end = ["getSectorFromPos", _end] call _grid;

			["put", [str(_start), _start]] call _hashmap;
			["put", [str(_start), 0]] call _costsofar;
			["put", [0, _start]] call _frontier;

			while {!("isEmpty" call _frontier)} do {
				_current = ["get", ""] call _frontier;
				_arounds = ["getSectorAround", _current] call _grid;
				
				{
					_position = ["getPosFromSector", _x] call _grid;
					_list = _position nearRoads 55;
					if(count _list > 0) then {
						_size = MEMBER("sizeOfRoad", _list select 0);
						if(_size > 400) then {
							_newcost = (["get", str(_current)] call _costsofar) + 1;
						} else {
							_newcost = (["get", str(_current)] call _costsofar) + 2;
						};
						_result = false;
						if(["containsKey", str(_x)] call _costsofar) then {
							if(_newcost < (["get", str(_x)] call _costsofar)) then {
								_result = true;
							};
						} else {
							_result = true;
						};
						if (_result) then {
							_array = [_x, _end];
							_heuristic = MEMBER("heuristic", _array);
							_priority = _newcost + _heuristic;						
							["put", [str(_x), _newcost]] call _costsofar;
							["put", [_priority, _x]] call _frontier;
							["put", [str(_x), _current]] call _hashmap;
							["DrawSector", [_current, str(_newcost)]] call _grid;
						};
					};
					sleep 0.000001;
				}foreach _arounds;
				if(_current isequalto _end) then {"clearQueue" call _frontier;};
			};

			_path = [];

			while {!(_current isequalto _start)} do {
				_path = _path + [_current];
				_current = ["get", str(_current)] call _hashmap;
				sleep 0.000001;
			};
			_path = _path + [_current];

			reverse _path;

			{
				["DrawSector2", _x] call _grid;
			}foreach _path;
			
			["delete", _costsofar] call OO_HASHMAP;
			["delete", _hashmap] call OO_HASHMAP;
			["delete", _frontier] call OO_QUEUE;

			_path;
		};

		PUBLIC FUNCTION("","deconstructor") { 
			DELETE_VARIABLE("grid");
		};
	ENDCLASS;