	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2014-2016 Nicolas BOITEUX

	CLASS OO_GRID STRATEGIC GRID
	
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

	CLASS("OO_GRID")
		PRIVATE VARIABLE("scalar","xgrid");
		PRIVATE VARIABLE("scalar","ygrid");
		PRIVATE VARIABLE("scalar","xgridsize");
		PRIVATE VARIABLE("scalar","ygridsize");
		PRIVATE VARIABLE("scalar","xsectorsize");
		PRIVATE VARIABLE("scalar","ysectorsize");
		PRIVATE VARIABLE("scalar","markerindex");
		PRIVATE VARIABLE("array","gridmarker");		

		/*
		Create a new grid object

		Parameters:
			xgrid - x grid pos
			ygrid - y grid pos
			xgridsize - grid width
			ygridsize - grid height
			xsectorsize - sector width
			ysectorsize - sector height
		*/

		PUBLIC FUNCTION("array", "DrawSector") {
			private ["_index", "_gridmarker", "_marker", "_sector", "_text"];

			_sector = _this  select 0;
			_text = _this select 1;

			_index = MEMBER("markerindex", nil);
			_gridmarker = MEMBER("gridmarker", nil);

			_position = MEMBER("getPosFromSector", _sector);

			_marker = createMarker [format["mrk_text_%1", _index], _position];
			_marker setMarkerShape "ICON";
			_marker setMarkerType "mil_triangle";
			_marker setmarkerbrush "Solid";
			_marker setmarkercolor "ColorBlack";
			_marker setmarkersize [0.5,0.5];
			_marker setmarkertext format["%1", _text];
			_gridmarker = _gridmarker + [_marker];
		
			_index = _index + 1;
			MEMBER("gridmarker", _gridmarker);
			MEMBER("markerindex", _index);
		};	

		PUBLIC FUNCTION("array", "DrawSector2") {
			private ["_marker", "_xsize", "_ysize", "_sector", "_index", "_gridmarker", "_position"];

			_sector = _this;
			_index = MEMBER("markerindex", nil);
			_gridmarker = MEMBER("gridmarker", nil);
			_xsize = MEMBER("xsectorsize", nil);
			_ysize = MEMBER("ysectorsize", nil);

			_position = MEMBER("getPosFromSector", _sector);

			_marker = createMarker [format["mrk_text_%1", _index], _position];
			_marker setMarkerShape "RECTANGLE";
			_marker setmarkerbrush "Solid";
			_marker setmarkercolor "ColorRed";
			_marker setmarkersize [_xsize/2,_ysize/2];

			_gridmarker = _gridmarker + [_marker];

			_index = _index + 1;
			MEMBER("gridmarker", _gridmarker);
			MEMBER("markerindex", _index);
		};

		PUBLIC FUNCTION("array","constructor") {
			MEMBER("xgrid", _this select 0);
			MEMBER("ygrid", _this select 1);
			MEMBER("xgridsize", _this select 2);
			MEMBER("ygridsize", _this select 3);
			MEMBER("xsectorsize", _this select 4);
			MEMBER("ysectorsize", _this select 5);

			_array = [];
			MEMBER("markerindex", 0);
			MEMBER("gridmarker", _array);	
		};

		PUBLIC FUNCTION("scalar","setXgrid") {
			MEMBER("xgrid", _this);
		};

		PUBLIC FUNCTION("scalar","setYgrid") {
			MEMBER("ygrid", _this);
		};

		PUBLIC FUNCTION("scalar","setXgridsize") {
			MEMBER("xgridsize", _this);
		};

		PUBLIC FUNCTION("scalar","setYgridsize") {
			MEMBER("ygridsize", _this);
		};

		PUBLIC FUNCTION("scalar","setXsectorsize") {
			MEMBER("xsectorsize", _this);
		};

		PUBLIC FUNCTION("scalar","setYsectorsize") {
			MEMBER("ysectorsize", _this);
		};

		PUBLIC FUNCTION("","getXgrid") FUNC_GETVAR("xgrid");
		PUBLIC FUNCTION("","getYgrid") FUNC_GETVAR("ygrid");
		PUBLIC FUNCTION("","getXgridsize") FUNC_GETVAR("xgridsize");
		PUBLIC FUNCTION("","getYgridsize") FUNC_GETVAR("ygridsize");
		PUBLIC FUNCTION("","getXsectorsize") FUNC_GETVAR("xsectorsize");
		PUBLIC FUNCTION("","getYsectorsize") FUNC_GETVAR("ysectorsize");

		/* 
		Call a loopback parsing function and return sectors that are concerned
		Example of string parameter: "hasBuildingsAtSector" will return sector with buildings
		Parameters: 
			_this : function name - string
		*/ 
		PUBLIC FUNCTION("string", "parseAllSectors") {
			private["_array", "_position", "_sector", "_x", "_y"];

			_array = [];

			for "_y" from MEMBER("ygrid", nil) to MEMBER("ygridsize", nil) step MEMBER("ysectorsize", nil) do {
				for "_x" from MEMBER("xgrid", nil) to MEMBER("xgridsize", nil) step MEMBER("xsectorsize", nil) do {
					_position = [_x, _y];
					_sector = MEMBER("getSectorFromPos", _position);
					if(MEMBER(_this, _sector)) then {
						_array pushback _sector;
					};
				};
			};
			_array;
		};

		/*
		Call a loopback parsing function and return sectors that are concerned
		Example of string parameter: "hasBuildingsAtSector" will return sector with buildings
		Parameters: 
			_this : array 
			_this select 0 : array containg sectors - array
			_this select 1 : name of the function to call back - string
		Return : array of sectors
		*/
		PUBLIC FUNCTION("array", "parseSectors") {
			private ["_result"];

			_result = [];
			{
				if(MEMBER((_this select 1), _x)) then {
					_result pushback _x;
				};
			} foreach (_this select 0);
			_result;
		};

		/*
		Translate a position to a sector
		Parameters: 
			_this : position array
		Return : sector : array
		*/
		PUBLIC FUNCTION("array", "getSectorFromPos") {
			private ["_xpos", "_ypos"];

			_xpos = floor(((_this select 0) - MEMBER("xgrid",nil)) / MEMBER("xsectorsize", nil));
			_ypos = floor(((_this select 1) - MEMBER("ygrid",nil)) / MEMBER("ysectorsize", nil));

			[_xpos, _ypos];
		};

		/*
		Translate a sector to a position
		Parameters: array - sector array
		Return : array position
		*/
		PUBLIC FUNCTION("array", "getPosFromSector") {		
			private ["_x", "_y"];

			_x = ((_this select 0) * MEMBER("xsectorsize", nil)) + (MEMBER("xsectorsize", nil) / 2) + MEMBER("xgrid", nil);
			_y = ((_this select 1) * MEMBER("ysectorsize", nil)) + (MEMBER("ysectorsize", nil) / 2)+ MEMBER("ygrid", nil);;

			[_x,_y];
		};		

		/*
		Retrieve the center position of a sector, from a position
		Parameters: array - position
		Return : array position of the sector center
		*/
		PUBLIC FUNCTION("array", "getSectorCenterPos") {
			MEMBER("getPosFromSector", MEMBER("getSectorFromPos", _this));
		};

		/*
		Get all sectors around one sector
		Parameters: array - array sector
		Return : array containing all sectors
		*/		
		PUBLIC FUNCTION("array", "getSectorsAroundSector") {
			private ["_grid"];

			_grid = [
				[(_this select 0) -1, (_this select 1) - 1],
				[(_this select 0), (_this select 1) - 1],
				[(_this select 0) + 1, (_this select 1) -1],
				[(_this select 0)-1, (_this select 1)],
				[(_this select 0)+1, (_this select 1)],
				[(_this select 0)-1, (_this select 1) + 1],
				[(_this select 0), (_this select 1) + 1],
				[(_this select 0)+1, (_this select 1) + 1]
				];
			_grid;			
		};

		/*
		Get all sectors around one position
		Parameters: array - array position
		Return : array containing all sectors
		*/		
		PUBLIC FUNCTION("array", "getSectorsAroundPos") {
			MEMBER("getSectorsAroundSector", MEMBER("getSectorFromPos", _this));
		};

		
		/*
		Get cross sectors around a sector
		Parameters: 
			_this: sector - array 
		Return : array containing all sectors
		*/
		PUBLIC FUNCTION("array", "getSectorsCrossAroundSector") {
			private ["_grid"];

			_grid = [
				[(_this select 0), (_this select 1) - 1],
				[(_this select 0)-1, (_this select 1)],
				[(_this select 0)+1, (_this select 1)],
				[(_this select 0), (_this select 1) + 1]
				];
			_grid;
		};

		/*
		Get cross sectors around a position
		Parameters: array - array position
		Return : array containing all sectors
		*/
		PUBLIC FUNCTION("array", "getSectorsCrossAroundPos") {
			MEMBER("getSectorsCrossAroundSector", MEMBER("getSectorFromPos", _this));
		};

		/*
		Get all sectors around a sector at scale sector distance
		Parameters: _
			_this : array
			_this select 0 : _sector - array
			_this select 1: _scale - int 
		Return : array containing all sectors
		*/
		PUBLIC FUNCTION("array", "getAllSectorsAroundSector") {
			private ["_grid", "_botx", "_boty", "_topx", "_topy", "_x", "_y"];

			_botx = ((_this select 0) select 0) - (_this select 1);
			_boty = ((_this select 0) select 1) - (_this select 1);
			_topx = ((_this select 0) select 0) + (_this select 1);
			_topy = ((_this select 0) select 1) + (_this select 1);

			_grid = [];
			
			for "_y" from _boty to _topy do {
				for "_x" from _botx to _topx do {
					_grid pushBack [_x, _y]; 
				};
			};
			_grid = _grid - [(_this select 0)];
			_grid;
		};

		/*
		Get all sectors around a sector at scale sector distance
		Parameters: 
			_this select 0 : position array
			_this select 1 : scale int
		Return : array containing all sectors
		*/
		PUBLIC FUNCTION("array", "getAllSectorsAroundPos") {
			private ["_array"];
			_array = [MEMBER("getSectorFromPos", _this select 0), _this select 1];
			MEMBER("getAllSectorsAroundSector", _array);
		};

		/*
		Check if sector has building
		Parameters : _this : sector array
		Return : boolean
		*/		
		PUBLIC FUNCTION("array", "hasBuildingsAtSector") {
			private ["_positions"];
			_positions = MEMBER("getPositionsBuilding", MEMBER("getPosFromSector", _this));
			if (count _positions > 10) then { true;} else { false;};
		};

		/*
		Check from a position if there are buildings in sector
		Parameters: _this : position array
		Return : boolean
		*/	
		PUBLIC FUNCTION("array", "hasBuildingsAtPos") {
			private ["_positions"];
			_positions = MEMBER("getPositionsBuilding", _this);
			if (count _positions > 10) then { true;} else { false;};
		};


		/*
		Retrieve indexed building in the sector position
		Parameters: _this : position array
		Return : array containing all positions in building
		*/
		PUBLIC FUNCTION("array", "getPositionsBuilding") {
			private ["_index", "_buildings", "_positions"];

			_positions = [];
			
			if!(surfaceIsWater _this) then {
				_buildings = nearestObjects[_this,["House_F"], MEMBER("xsectorsize", nil)];
	
				{
					_index = 0;
					while { format ["%1", _x buildingPos _index] != "[0,0,0]" } do {
						_positions = _positions + [(_x buildingPos _index)];
						_index = _index + 1;
						sleep 0.0001;
					};
					sleep 0.0001;
				}foreach _buildings;
			};
			_positions;
		};

		PUBLIC FUNCTION("","deconstructor") { 
			DELETE_VARIABLE("xgrid");
			DELETE_VARIABLE("ygrid");
			DELETE_VARIABLE("xgridsize");
			DELETE_VARIABLE("ygridsize");
			DELETE_VARIABLE("xsectorsize");
			DELETE_VARIABLE("ysectorsize");
		};
	ENDCLASS;