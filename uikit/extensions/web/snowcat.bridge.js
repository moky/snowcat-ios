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

!function(snowcat) {
	
	if (snowcat.version && snowcat.version != "0.0.0") {
		// already implemented (upgraded)
		return;
	}
	snowcat.version = "1.0.0";
	
	////////////////////////////////////////////////////////////////////////////
	//
	//  Class: Object
	//
	//  Functions:
	//        1. json()
	//        2. toString()
	//
	
	// flat the element into a json string
	var json = function(element) {
		var type = typeof(element);
		if (type === "object" && element instanceof Array) {
			type = "array";
		}
		
		if (type === "array") {
			var string = "";
			for (var i = 0; i < element.length; ++i) {
				string += json(element[i]) + ",";
			}
			if (string.length > 0) {
				string = string.substr(0, string.length - 1); // erase last ','
			}
			return "[" + string + "]";
		} else if (type === "object") {
			var string = "";
			for (var key in element) {
				string += "\"" + key + "\":" + json(element[key]) + ",";
			}
			if (string.length > 0) {
				string = string.substr(0, string.length - 1); // erase last ','
			}
			return "{" + string + "}";
		} else if (type === "string") {
			var string = element;
			string = string.replace(/"/g, "\\\"");
			return "\"" + string + "\"";
		} else {
			return element;
		}
	};
	
	// flat the element into a string
	var desc = function(element, indent) {
		indent = indent || "";
		var _INDENT_ = indent + "\t";
		var _CRLF_ = "\r\n";
		
		var type = typeof(element);
		if (type === "object" && element instanceof Array) {
			type = "array";
		}
		
		if (type === "array") {
			var string = "";
			for (var i = 0; i < element.length; ++i) {
				string += _CRLF_ + _INDENT_ + "/* " + i + " */ " + desc(element[i], _INDENT_) + ",";
			}
			if (string.length > 0) {
				string = string.substr(0, string.length - 1); // erase last ','
			}
			return "[" + string + _CRLF_ + indent + "]";
		} else if (type === "object") {
			var string = "";
			for (var key in element) {
				string += _CRLF_ + _INDENT_ + "\"" + key + "\" : " + desc(element[key], _INDENT_) + ",";
			}
			if (string.length > 0) {
				string = string.substr(0, string.length - 1); // erase last ','
			}
			return "{" + string + _CRLF_ + indent + "}";
		} else if (type === "string") {
			var string = element;
			string = string.replace(/"/g, "\\\"");
			return "\"" + string + "\"";
		} else {
			return element;
		}
	};
	
	//--------------------------------------------------------------------------
	
	snowcat.Object = function(object) {
		this.data = object;
		return this;
	};
	
	snowcat.Object.prototype.json = function() {
		return json(this.data);
	};
	
	snowcat.Object.prototype.toString = function() {
		return desc(this.data);
	};
	
	////////////////////////////////////////////////////////////////////////////
	//
	//  Description: Bridges
	//
	//  Functions:
	//        1. call(object, method, parameters)
	//        2. on(event, handler)
	//        3. fire(event)
	//        4. postNotification(event, userInfo)
	//
	
	var _event_handlers = {};
	
	// set handler for event
	var on = function(event, handler) {
		if (typeof(event) !== "string" || typeof(handler) !== "function") {
			alert("parameters error: " + event + ", " + handler);
			return;
		}
		var array = _event_handlers[event];
		if (!array) {
			array = [];
			_event_handlers[event] = array;
		}
		array.push(handler);
	};
	
	// trigger all handlers with event name
	var fire = function(event) {
		var array = _event_handlers[event];
		var count = array.length;
		for (var index = 0; index < count; ++index) {
			array[index](event);
		}
	};
	
	// call function in Object-C's space via SnowCat framework
	var call = function(object, method, parameters) {
		var url = "snowcat://" + object + "/" + method;
		if (parameters) {
			url += "?" + parameters;
		}
		document.location.href = url;
	};
	
	// post notification to Object-C's space via SnowCat framework
	var postNotification = function(event, userInfo) {
		parameters = "event=" + event;
		if (userInfo) {
			var obj = new snowcat.Object(userInfo);
			parameters += "&userInfo=" + obj.json();
		}
		call("notification", "post", parameters);
	};
	
	//--------------------------------------------------------------------------
	
	snowcat.on = on;
	snowcat.fire = fire;
	snowcat.call = call;
	
	snowcat.postNotification = postNotification;
	
	////////////////////////////////////////////////////////////////////////////
	//
	//  Description: main
	//
	
	if (typeof(snowcat.onReady) === "function") {
		snowcat.onReady();
	}
	
}(window.snowcat);
