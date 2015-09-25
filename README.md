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
		CGRect frame = [[UIScreen mainScreen] bounds]];
		self.window = [[[UIWindow alloc] initWithFrame:frame autorelease];
		// Override point for customization after application launch.
		
		NSString * entrance = @"main.plist";
		entrance = [SCApplicationDirectory() stringByAppendingPathComponent:entrance];
		[SCWindow launch:entrance withWindow:self.window];
		
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
				/* defined 'page1' in another 'Node' file */
				rootViewController : 'include file="page1.plist" replace="name: girl"'
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
					/* view 2, defined in another 'Node' file, in order to reuse */
					'include file="btn1.plist" attributes="center: {center, middle}"',
					{ /* view 3 */
						Class  : "ImageView",
						image  : "Icon.png",
						size   : "{100, 100}"
						center : "{center, middle + 100}",
						events : {
							"msg.page1.button1.clicked" : [
								{ /* action 1 */
									name    : "ToggleVisibility",
									target  : "self"
								}
								/* more actions, see 'snowcat-ios/uikit/actions/' */
							]
						},
						notifications : [
							/* all these notifications will be transfered to events */
							"msg.page1.button1.clicked"
						]
					}
				] /* EOF 'subviews' */
			} /* EOF 'view' */
		}
	}

> Resources/btn1.plist

	Root: {
		Node : {
			Class   : "Button",
			comment : "This is button 1",
			title   : "click me",
			color   : "{255, 0, 0}",
			events  : {
				onClick : [
					{ /* action 1 */
						name    : "Alert",
						title   : "Hey ${name}",
						message : "Should I date you?",
						ok      : "Of course!"
					},
					{ /* action 2 */
						name    : "Notification",
						event   : "msg.page1.button1.clicked"
					}
				]
			}
		}
	}


## Example 2: "Beva apps"

*Downloads* :

* [Beva Kids TV][beva.tv]
* [Beva Kids FM][beva.fm]

> All these [Beva][beva.com] apps are based on this framework,
> but you know, I cannot offer you these source codes, *BAZINGA!~ :P*

&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
*-- by [moKy][moky] @ Sept. 25, 2015 (Mid-Autumn Festival)*



[slanissue.com]: http://www.slanissue.com/ "Beijing Slanissue Technology Co., Ltd."
[beva.com]: http://www.beva.com/ "Beva.com"

[moky]: http://moky.github.com/ "About me"

[slanissue-ios]: https://github.com/moky/slanissue-ios "Slanissue Toolkit for iOS"

[slanissue-ios.zip]: https://github.com/moky/slanissue-ios/archive/master.zip "Slanissue Toolkit for iOS"
[snowcat-ios.zip]: https://github.com/moky/snowcat-ios/archive/master.zip "SnowCat for iOS"

[beva.tv]: https://itunes.apple.com/cn/app/bei-wa-er-ge2015/id716603240?mt=8 "AppStore"
[beva.fm]: https://itunes.apple.com/cn/app/bei-wa-ting-ting/id989100723?mt=8 "AppStore"

[snowcat.jpg]: http://img.diytrade.com/cdimg/860989/8004577/0/1234846770.jpg "Snowcat"
