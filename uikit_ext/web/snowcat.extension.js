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
//  Description: Functions
//
//    1. request(object, method, parameters, handler)
//    2. postNotification(event, userInfo)
//
!function(snowcat) {
	
	var _handler = null;
	
	var response = function(event, data) {
		if (typeof(_handler) === "function") {
			_handler(data);
		}
		_handler = null;
	};
	snowcat.on("sys.response", response);
	
	/**
	 *  call object in Objective-C's space, waiting for response with handler
	 */
	var request = function(object, method, parameters, handler) {
		_handler = handler;
		snowcat.call(object, method, parameters);
	};
	
	/**
	 *  post notification to Objective-C's space via SnowCat framework
	 */
	var post = function(event, userInfo) {
		var parameters = "event=" + event;
		if (userInfo) {
			var obj = new snowcat.Object(userInfo);
			parameters += "&userInfo=" + obj.json();
		}
		snowcat.call("notification", "post", parameters);
	};
	
	//--------------------------------------------------------------------------
	
	if (typeof(snowcat.request) !== "function") {
		snowcat.request = request;
	}
	
	if (typeof(snowcat.post) !== "function") {
		snowcat.post = post;
	}
	
	// alias
	if (typeof(snowcat.postNotification) !== "function") {
		snowcat.postNotification = post;
	}
	
}(window.snowcat);
