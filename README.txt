	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2016-2018 Nicolas BOITEUX

	CLASS OO_PATHFIND - PATHFINDING CLASS
	
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

	Retrieve the way before A and B point according the weightfunction
	
	Usage:
		put the "oo_grid.sqf" and the "oop.h" files in your mission directory
		put the "oo_hashmap.sqf" in your mission directory
		put the "oo_pathfinding.sqf" in your mission directory
		put the "oo_queue.sqf" in your mission directory
		put this code into your mission init.sqf

		call compile preprocessFileLineNumbers "oo_grid.sqf";
		call compile preprocessFileLineNumbers "oo_queue.sqf";
		call compile preprocessFileLineNumbers "oo_hashmap.sqf";
		call compile preprocessFileLineNumbers "oo_pathfinding.sqf";

	See example mission in directory: init.sqf
	
	Licence: 
	You can share, modify, distribute this script but don't remove the licence and the name of the original author

	logs:
		0.4 - add new oo_queue
		0.3 - add new grid/hashmap/queue object
		0.2 - improve performance with last upgrade
		0.1 - OO PATHFINDING - first release


