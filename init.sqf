		call compile preprocessFileLineNumbers "oo_grid.sqf";
		call compile preprocessFileLineNumbers "oo_queue.sqf";
		call compile preprocessFileLineNumbers "oo_hashmap.sqf";
		call compile preprocessFileLineNumbers "oo_pathfinding.sqf";


		// Initialize a virtual grid over the map
		private _grid = ["new", [0,0,31000,31000,100,100]] call OO_GRID;
		private _path = ["new", _grid] call OO_PATHFINDING;

		// Weight function example to evaluate each sector
		private _weightfunction = {
			private ["_position", "_size", "_average", "_cost"];
			
			_position = _this select 0;
			_size = _this select 1;
			_average = 0;
			_cost = 0;

			_list = _position nearRoads _size;
			if(count _list > 0) then {
				_bbr = boundingBoxReal (_list select 0);
				_br0 = _bbr select 0;
				_br1 = _bbr select 1;
				_maxwidth = abs ((_br1 select 0) - (_br0 select 0));
				_maxlength = abs ((_br1 select 1) - (_br0 select 1));
				_average = floor (_maxwidth * _maxlength);
				if(_average > 200) then {
					_cost = 1;
				} else {
					_cost = 2;
				};
			};
			_cost;
		};

		["setWeightFunction", _weightfunction] call _path;

		private _start = getmarkerpos "start";
		private _end = getmarkerpos "end";
		private _time1 = time;
		private _waypoints = ["getPath_A", [_start, _end]] call _path;
		private _time2 = time;

		hintc format ["Waypoints: %1 Time: %2", count _waypoints, _time2 - _time1];
