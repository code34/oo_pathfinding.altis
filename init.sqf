		call compilefinal preprocessFileLineNumbers "oo_grid.sqf";
		call compilefinal preprocessFileLineNumbers "oo_queue.sqf";
		call compilefinal preprocessFileLineNumbers "oo_hashmap.sqf";
		call compilefinal preprocessFileLineNumbers "oo_pathfinding.sqf";


		// Initialize a virtual grid over the map
		_grid = ["new", [0,0,31000,31000,100,100]] call OO_GRID;
		_path = ["new", _grid] call OO_PATHFINDING;

		// Weight function example to evaluate each sector
		_weightfunction = {
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

		_start = getmarkerpos "start";
		_end = getmarkerpos "end";
		_time1 = time;
		_waypoints = ["getPath_A", [_start, _end]] call _path;
		_time2 = time;

		hintc format ["Waypoints: %1 Time: %2", count _waypoints, _time2 - _time1];
