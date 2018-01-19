	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2016-2018 Nicolas BOITEUX

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
		PRIVATE VARIABLE("scalar","counter");
		
		PUBLIC FUNCTION("string","constructor") { 
			DEBUG(#, "OO_QUEUE::constructor")
			MEMBER("queue", []);
			MEMBER("counter", 0);
		};

		/*
		Return an array containing all the elements of the queue
		Return : array
		*/
		PUBLIC FUNCTION("", "toArray") {
			private _array = [];
			{ _array pushBack (_x select 2); true; } count MEMBER("queue", nil);
			_array;
		};

		/*
		Count the number of elements in the Queue
		Return : scalar
		*/
		PUBLIC FUNCTION("", "count") {
			DEBUG(#, "OO_QUEUE::count")
			count MEMBER("queue", nil);
		};

		/*
		Removes all of the elements from this priority queue
		Return : nothing
		*/
		PUBLIC FUNCTION("", "clearQueue") {
			DEBUG(#, "OO_QUEUE::clearQueue")
			MEMBER("queue", []);
			MEMBER("counter", 0);
		};

		/*
		Test if the priority queue is empty 
		Return : boolean 
		*/
		PUBLIC FUNCTION("", "isEmpty") {
			DEBUG(#, "OO_QUEUE::isEmpty")
			if(MEMBER("count", nil) > 0) then { false; } else { true;};
		};

		/*
		Get next first in element according its priority, and remove it
		Param : default return value, if queue is empty
		Return : default return value
		*/
		PUBLIC FUNCTION("", "get") {
			DEBUG(#, "OO_QUEUE::get")
			(MEMBER("queue", nil) deleteAt 0) select 2;
		};

		/*
		Insert an element in priority queue according its priority
		 params : array
		 	1 - priority - (0 highest priority)
		 	2 - Element to insert in the queue
		*/
		PUBLIC FUNCTION("array","put") {
			DEBUG(#, "OO_QUEUE::put")
			_counter = MEMBER("counter", nil) + 1;
			MEMBER("counter", _counter);
			MEMBER("queue", nil) pushBack [_this select 0, _counter, _this select 1];
			MEMBER("queue", nil) sort true;
		};

		PUBLIC FUNCTION("","deconstructor") { 
			DEBUG(#, "OO_QUEUE::deconstructor")
			DELETE_VARIABLE("queue");
			DELETE_VARIABLE("counter");
		};
	ENDCLASS;