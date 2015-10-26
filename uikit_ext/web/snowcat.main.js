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
//  Description: main
//
!function(snowcat) {
	
	if (typeof(snowcat.onReady) === "function") {
		snowcat.onReady();
	}
	
}(window.snowcat);
