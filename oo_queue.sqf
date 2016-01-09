	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2014-2016 Nicolas BOITEUX

	CLASS OO_QUEUE
	
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

	CLASS("OO_QUEUE")
		PRIVATE VARIABLE("array","queue");

		PUBLIC FUNCTION("string","constructor") { 
			MEMBER("clearQueue", nil);
		};

		/*
		Get queue
		*/
		PUBLIC FUNCTION("", "getQueue") {
			MEMBER("queue", nil);
		};

		/*
		Clear the queue
		*/
		PUBLIC FUNCTION("", "clearQueue") {
			_array = [];
			MEMBER("queue", _array);
		};

		/*
		Get priority element in the queue
		Return default return value
		*/
		PUBLIC FUNCTION("ANY", "getNextPrior") {
			private ["_index", "_result", "_defaultreturn", "_array"];
			
			if(isnil "_this") exitwith { hintc "OO_QUEUE: getNextPrior requires a return default value";};
			_defaultreturn = _this;

			{
				scopeName "oo_queue";
				if!(isnil "_x") then {
					If(count _x > 0) then {
						_index = _foreachindex;
						breakout "oo_queue";
					};
				};
				sleep 0.0001;
			} foreach MEMBER("queue", nil);
			if(isnil "_index") then {
				_result = _defaultreturn;
			} else {
				_array = [_index, _defaultreturn];
				_result = MEMBER("get", _array);
			};
			_result;
		};

		/*
		Retrieve the number of elements in the Queue
		*/
		PUBLIC FUNCTION("", "count") {
			private ["_count"];

			_count = 0;
			{
				if!(isnil "_x") then {
					_count = _count + count(_x);
				};
				sleep 0.0001;
			} foreach MEMBER("queue", nil);
			_count;
		};

		/*
		Get the first element with priority prior in the queue
		 params - array 
		 1- priority queue
		*/
		PUBLIC FUNCTION("array","get") {
			private ["_array", "_queue", "_queueid", "_element", "_defaultreturn"];

			_queueid = _this select 0;
			_defaultreturn = _this select 1;

			_queue = MEMBER("queue", nil) select _queueid;

			_element = _defaultreturn;
			if(count(_queue) > 0) then {
				_element = _queue deleteat 0;
			};
			
			MEMBER("queue", nil) set [_queueid, _queue];
			_element;
		};

		/*
		Add an element with priority in the right queue
		 params - array 
		 1- priority queue
		 2 - element
		*/
		PUBLIC FUNCTION("array","put") {
			private ["_queueid", "_element", "_queue"];
			
			_queueid = _this select 0;
			_element = _this select 1;

			if (count MEMBER("queue", nil)  < _queueid) then {
				_queue = [];
			} else {
				_queue = MEMBER("queue", nil)  select _queueid;
				if(isnil "_queue") then {
					_queue = [];
				};
			};			
			_queue = _queue + [_element];

			MEMBER("queue", nil) set [_queueid, _queue];
		};

		PUBLIC FUNCTION("","deconstructor") { 
			DELETE_VARIABLE("queue");
		};
	ENDCLASS;