# SnowCat

**SnowCat.framework for iOS application**
is a framework for developing apps via creating some '.plist' files simply.

It is based on [SlanissueToolkit.framework][slanissue-ios], copyright &copy;2015 [Slanissue.com][slanissue.com].

[slanissue-ios]: https://github.com/moky/slanissue-ios "Slanissue Toolkit for iOS"
[slanissue.com]: http://www.slanissue.com/ "Beijing Slanissue Technology Co., Ltd."

---

## Example 1: "Hello world"

*Downloads* :

* [SlanissueToolkit.zip][slanissue-ios.zip]
* [SnowCat.zip][snowcat-ios.zip]

[slanissue-ios.zip]: https://github.com/moky/slanissue-ios/archive/master.zip "Slanissue Toolkit for iOS"
[snowcat-ios.zip]: https://github.com/moky/snowcat-ios/archive/master.zip "SnowCat for iOS"

> Classes/AppDelegate.m

	#import "SnowCat.h"
	
	- (BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
	{
		self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
		// Override point for customization after application launch.
		
		NSString * entrance = @"main.plist";
		NSString * path = [SCApplicationDirectory() stringByAppendingPathComponent:entrance];
		[SCWindow launch:path withWindow:self.window];
		
		self.window.backgroundColor = [UIColor whiteColor];
		[self.window makeKeyAndVisible];
		return YES;
	}

> Resources/main.plist

	Root : {
		version : "1.0",
		Node : {
			comment : "Here is the main entrance",
			window : {
				rootViewController : 'include file="page1.plist" replace="name: girl; act: date"'
			}
		}
	}

> Resources/page1.plist

	Root : {
		Node : {
			Class   : "ViewController",
			comment : "This is page 1",
			view    : {
				subviews : [
					{ /* view 1 */
						Class  : "Label",
						text   : "Hello world!",
						color  : "{0, 0, 255}",
						center : "{center, middle - 50}"
					},
					{ /* view 2 */
						Class  : "Button",
						title  : "click me",
						color  : "{0, 255, 0}",
						center : "{center, middle + 50}",
						events : {
							onClick : [
								{ /* action 1 */
									name    : "Alert",
									title   : "Hey ${name}",
									message : "Should I ${act} you?",
									ok      : "Of course!"
								},
								{ /* action 2 */
									name    : "Notification",
									event   : "msg.page1.button1.clicked"
								}
							] /* EOF 'onClick' */
						} /* EOF 'events' */
					}
				] /* EOF 'subviews' */
			} /* EOF 'view' */
		}
	}
