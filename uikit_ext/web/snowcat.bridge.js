;
/*!
 * SnowCat JavaScript Bridge v1.0.0
 * http://www.slanissue.com/
 *
 * Copyright 2015 moKy at slanissue.com
 * Released under the MIT license
 * http://jquery.org/license
 *
 * Date: 2015-2-13 T15:53Z
 */

if (typeof(window.snowcat) !== "object") {
	window.snowcat = {};
}

////////////////////////////////////////////////////////////////////////////
//
//  Description: Bridges
//
//    1. on(event, handler)
//    2. fire(event, data)
//    3. call(object, method, parameters)
//
!function(snowcat) {
	
	var contains = function(array, object) {
		var idx = array.length - 1;
		for (; idx >= 0; --idx) {
			if (array[idx] === object) {
				return true;
			}
		}
		return false;
	};
	
	var _event_handlers = {};
	
	/**
	 *  set handler for event
	 */
	var on = function(event, handler) {
		if (typeof(event) !== "string" || typeof(handler) !== "function") {
			alert("parameters error: " + event + ", " + handler);
			return;
		}
		var array = _event_handlers[event];
		if (array) {
			if (!contains(array, handler)) {
				array.push(handler);
			}
		} else {
			_event_handlers[event] = [handler];
		}
	};
	
	/**
	 *  trigger all handlers with event name
	 */
	var fire = function(event, data) {
		var array = _event_handlers[event];
		var count = array.length;
		for (var index = 0; index < count; ++index) {
			array[index](event, data);
		}
	};
	
	/**
	 *  call function in Objective-C's space via SnowCat framework
	 */
	var call = function(object, method, parameters) {
		var url = "snowcat://" + object + "/" + method;
		if (parameters) {
			if (typeof(parameters) !== "string") {
				var obj = new snowcat.Object(parameters);
				parameters = obj.json();
			}
			url += "?" + parameters;
		}
		document.location.href = url;
	};
	
	//--------------------------------------------------------------------------
	
	if (typeof(snowcat.on) !== "function") {
		snowcat.on = on;
	}
	if (typeof(snowcat.fire) !== "function") {
		snowcat.fire = fire;
	}
	if (typeof(snowcat.call) !== "function") {
		snowcat.call = call;
	}
	
}(window.snowcat);
