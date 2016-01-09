		call compilefinal preprocessFileLineNumbers "oo_grid.sqf";
		call compilefinal preprocessFileLineNumbers "oo_queue.sqf";
		call compilefinal preprocessFileLineNumbers "oo_hashmap.sqf";
		call compilefinal preprocessFileLineNumbers "oo_pathfinding.sqf";

		_path = ["new", ""] call OO_PATHFINDING;
		_start = getmarkerpos "start";
		_end = getmarkerpos "end";

		_time1 = time;
		_goodpath = ["getPath_A", [_start, _end]] call _path;
		_time2 = time;
		_time = _time2 - _time1;

		_goodpath = (count _goodpath * 50);
		hintc format ["path %1 distance %2 Meters", _time, _goodpath];


