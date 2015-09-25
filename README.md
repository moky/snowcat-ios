# SnowCat

**SnowCat.framework for iOS application**
is a framework for developing apps via creating some '.plist' files simply.

It is based on [SlanissueToolkit.framework][slanissue-ios], copyright &copy;2015 [Slanissue.com][slanissue.com].

![Snowcat][snowcat.jpg]

---

## Example 1: "Hello world"

*Downloads* :

* [SlanissueToolkit.zip][slanissue-ios.zip]
* [SnowCat.zip][snowcat-ios.zip]

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
						center : "{center, middle - 100}"
					},
					{ /* view 2 */
						Class  : "ImageView",
						image  : "Icon.png",
						size   : "{50, 50}"
						center : "{center, middle}"
					},
					{ /* view 3 */
						Class  : "Button",
						title  : "click me",
						color  : "{0, 255, 0}",
						center : "{center, middle + 100}",
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

## Example 2: "Beva apps"

*Downloads* :

* [Beva Kids TV][beva.tv]
* [Beva Kids FM][beva.fm]

> All these [Beva][beva.com] apps are based on this framework,
> but I'm sorry that I cannot offer you these source codes, muhaha~ :P
> 
> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
> -- by [moKy][moky] @ Sept. 25, 2015 (Mid-Autumn Festival)


[slanissue.com]: http://www.slanissue.com/ "Beijing Slanissue Technology Co., Ltd."
[beva.com]: http://www.beva.com/ "Beva.com"

[moky]: http://moky.github.com/ "About me"

[slanissue-ios]: https://github.com/moky/slanissue-ios "Slanissue Toolkit for iOS"

[slanissue-ios.zip]: https://github.com/moky/slanissue-ios/archive/master.zip "Slanissue Toolkit for iOS"
[snowcat-ios.zip]: https://github.com/moky/snowcat-ios/archive/master.zip "SnowCat for iOS"

[beva.tv]: https://itunes.apple.com/cn/app/bei-wa-er-ge2015/id716603240?mt=8 "AppStore"
[beva.fm]: https://itunes.apple.com/cn/app/bei-wa-ting-ting/id989100723?mt=8 "AppStore"

[snowcat.jpg]: http://img.diytrade.com/cdimg/860989/8004577/0/1234846770.jpg "Snowcat"
