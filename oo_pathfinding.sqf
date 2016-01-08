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
		PRIVATE VARIABLE("code","hashmap");
		
		PUBLIC FUNCTION("string","constructor") {
			private ["_hashmap", "_grid"];
			
			_hashmap = ["new", []] call OO_HASHMAP;
			_grid = ["new", [31000,31000,100,100]] call OO_GRID;

			MEMBER("grid", _grid);
			MEMBER("hashmap", _hashmap);
		};

		PUBLIC FUNCTION("array", "heuristic") {
			private ["_goal", "_next"];

			_goal = _this select 0;
			_next = _this select 1;

			abs((_goal select 0) - (_next select 0)) + abs((_goal select 1) - (_next select 1));
		};

		// Path finding - find the best way between one sector and other
		PUBLIC FUNCTION("array", "getPath") {
			private ["_start", "_end", "_frontier", "_current", "_path", "_grid", "_hashmap", "_position", "_heuristic", "_index", "_value"];

			_start = _this select 0;
			_end = _this select 1;

			_grid = MEMBER("grid", nil);
			_hashmap = MEMBER("hashmap", nil);

			_start = ["getSectorFromPos", _start] call _grid;
			_end = ["getSectorFromPos", _end] call _grid;

			_frontier = [_start];
			_current = _start;

			["put", [str(_start), _current]] call _hashmap;

			while {count _frontier > 0} do {
				_index = 0;
				//_current = _frontier deleteAt 0;
				_current = _frontier select 0;
				while { isnil "_current"} do {
					//_current = _frontier deleteAt 0;
					_index = _index + 1;
					_current = _frontier select _index;
				};
				//_current = _frontier deleteAt _index;
				_frontier set [_index, nil];

				_arounds = ["getSectorAround", _current] call _grid;
				{
					_position = ["getPosFromSector", _x] call _grid;
					_list = _position nearRoads 50;
					if(count _list > 0) then {
						_result = ["containsKey", str(_x)] call _hashmap;
						if(!_result)then {
							_array = [_x, _end];
							_heuristic = MEMBER("heuristic", _array);
							_value = _frontier select _heuristic;
							while { !(isnil "_value") } do {
								_heuristic = _heuristic + 1;
								_value = _frontier select _heuristic;
							};
							hint format ["heuristic %1", _heuristic];
							_frontier set [_heuristic, _x] ;
							//_frontier = _frontier + [_x];
							["put", [str(_x), _current]] call _hashmap;
							["DrawSector", _current] call _grid;
						};
					};
					sleep 0.000001;
				}foreach _arounds;
				if(_current isequalto _end) then {_frontier = []};
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

			_path;
		};		

		// Path finding - find the best way between one sector and other
		PUBLIC FUNCTION("array", "getPathWithA") {
			private ["_start", "_end", "_frontier", "_current", "_path", "_grid", "_hashmap", "_position", "_heuristic", "_cost", "_newcost", "_result2"];

			_start = _this select 0;
			_end = _this select 1;

			_grid = MEMBER("grid", nil);
			_hashmap = MEMBER("hashmap", nil);
			_cost = MEMBER("hashmap", nil);

			_start = ["getSectorFromPos", _start] call _grid;
			_end = ["getSectorFromPos", _end] call _grid;

			_frontier = [_start];
			_current = _start;

			["put", [str(_start), _current]] call _hashmap;
			["put", [str(_start), 0]] call _cost;

			while {count _frontier > 0} do {
				_current = _frontier deleteAt 0;
				while { isnil "_current"} do {
					_current = _frontier deleteAt 0;
				};
				_arounds = ["getSectorAround", _current] call _grid;
				{
					_position = ["getPosFromSector", _x] call _grid;
					_list = _position nearRoads 50;
					if(count _list > 0) then {
						_newcost = (["get", str(_current)] call _cost) + 1;
						_result = ["containsKey", str(_x)] call _cost;
						_result2 = (_newcost < (["get", str(_x)] call _cost));
						sleep 100;
						if(!_result)then {
							_array = [_x, _end];
							_heuristic = MEMBER("heuristic", _array);
							_frontier set [_heuristic, _x] ;
							//_frontier = _frontier + [_x];
							["put", [str(_x), _current]] call _hashmap;
							["DrawSector", _current] call _grid;
						};
					};
					sleep 0.000001;
				}foreach _arounds;
				if(_current isequalto _end) then {_frontier = []};
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

			_path;
		};	

		PUBLIC FUNCTION("","deconstructor") { 
			["delete", MEMBER("grid", nil)] call OO_GRID;
			["delete", MEMBER("hashmap", nil)] call OO_HASHMAP;
			DELETE_VARIABLE("grid");
			DELETE_VARIABLE("hashmap");
			DELETE_VARIABLE("reversehashmap");
		};
	ENDCLASS;