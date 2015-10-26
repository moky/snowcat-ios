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
//  Class: Object
//
//  Functions:
//        1. json()
//        2. toString()
//
!function(snowcat) {
	
	/**
	 *  flat the element into a json string
	 */
	var json = function(element) {
		var type = typeof(element);
		if (type === "object") {
			if (element instanceof Array) {
				type = "array";
			} else {
				type = "dictionary";
			}
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
		} else if (type === "dictionary") {
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
	
	/**
	 *  flat the element into a string
	 */
	var desc = function(element, indent) {
		indent = indent || "";
		var _INDENT_ = indent + "\t";
		var _CRLF_ = "\r\n";
		
		var type = typeof(element);
		if (type === "object") {
			if (element instanceof Array) {
				type = "array";
			} else {
				type = "dictionary";
			}
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
		} else if (type === "dictionary") {
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
	
	if (typeof(snowcat.Object) !== "object") {
		
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
		
	}
	
}(window.snowcat);
