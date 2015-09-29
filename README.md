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
	
	...
	
	- (BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
	{
		CGRect frame = [[UIScreen mainScreen] bounds];
		self.window = [[[UIWindow alloc] initWithFrame:frame] autorelease];
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

## Example 2: "Notifications & Callback"

I suggest you controlling the UI via **notifications**, but **not codes**, the best habit is NOT write any UI codes in your controllers.

You can do some calculating works in your codes (e.g.: a singleton instance),
and send out a notification to notice all guys that interest in the results.
As all `SnowCat` *views & controllers* can define a '**notifications**' list and do some **actions** when these '**events**' happen,
we can let the framework to do the UI works.

Meanwhile, you should send out a notification when some events happen in UI level (e.g.: a button clicked),
so that guys interest in it will do their works when received this notification.

There are two ways to callback from the UI level:

1. Notification
2. CallFunc

> Classes/controller/MyController.h

	#import "SnowCat.h"
	
	#define MSG_BUTTON1_CLICKED @"msg.page1.button1.clicked"
	#define MSG_XXX             @"msg.whatever"
	
	@interface MyController : SCViewController
	
	@end

> Classes/controller/MyController.m

	#import "MyController.h"
	
	@implementation MyController
	
	- (void) dealloc
	{
		NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
		[center removeObserver:self
		                  name:MSG_BUTTON1_CLICKED
		                object:nil];
		
		[super dealloc];
	}
	
	/* the designated initializer */
	- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
	{
		self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
		if (self) {
			NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
			[center addObserver:self
			           selector:@selector(_button1Notification:)
				           name:MSG_BUTTON1_CLICKED
				         object:nil];
		}
		return self;
	}
	
	- (void) _button1Notification:(NSNotification *)notification
	{
		// TODO: handle button1 clicked notification here.
		
		// the 'userInfo' is a dictionary of the action's definition,
		// you can get all message you need here
		NSDictionary * aDict = [notification userInfo];
		SCLog(@"user info: %@", aDict);
		
		NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
		[center postNotificationName:MSG_XXX object:nil userInfo:aDict];
	}
	
	@end

> Classes/view/MyButton.h

	#import "SnowCat.h"
	
	@interface MyButton : SCButton
	
	@end

> Classes/view/MyButton.m

	#import "MyButton.h"
	
	@implementation MyButton
	
	- (instancetype) initWithDictionary:(NSDictionary *)dict
	{
		self = [super initWithDictionary:dict];
		if (self) {
			// TODO: initialize your button here
			// the parameters 'dict' is the dictionary defined in plist
		}
		return self;
	}
	
	- (BOOL) setAttributes:(NSDictionary *)dict
	{
		if (![super setAttributes:dict]) {
			SCLog(@"definition error: %@", dict);
			return NO;
		}
		// TODO: set extra attributes for your button
		// the parameters 'dict' is the dictionary defined in plist
		
		// NOTICE: this function will be called after added to superview.
		return YES;
	}
	
	- (void) onClick:(id)sender
	{
		[super onClick:sender];
		
		// TODO: handle 'onClick:' event here
		
		// sender is the self button
		SCLog(@"sender: %@", sender);
	}
	
	- (void) _click:(NSObject *)object
	{
		// TODO: handle 'CallFunc' action here
		
		// you can also call a function without parameter, or two parameters
		NSString * str = (NSString *)object;
		SCLog(@"object: %@", str);
	}
	
	@end

> Resources/btn1.plist

	Root: {
		Node : {
			Class  : "Button",
			title  : "click button 1",
			color  : "{255, 0, 0}",
			events : {
				onClick : [
					{
						name     : "Notification",
						event    : "msg.page1.button1.clicked"
					}
				],
				"msg.whatever" : [
					{
						name     : "View",
						target   : "parent",
						selector : "addSubview:",
						view     : 'include file="btn2.plist" attributes="center: {200, 100}"'
					},
					{
						name     : "Hide",
						target   : "self"
					}
				]
			},
			notifications : [
				"msg.whatever"
			]
		}
	}


> Resources/btn2.plist

	Root: {
		Node : {
			Class  : "MyButton",
			title  : "click button 2",
			color  : "{0, 255, 0}",
			events : {
				onClick : [
					{
						name     : "CallFunc",
						selector : "_click:",
						object   : "${name}"
					}
				]
			}
		}
	}

## Example 3: "Beva apps"

*Downloads* :

* [Beva Kids TV][beva.tv]
* [Beva Kids FM][beva.fm]

> All these [Beva][beva.com] apps are based on this framework,
> but you know, I cannot offer you these source codes, *BAZINGA!~ :P*

&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
*-- by [moKy][moky] @ Sept. 25, 2015 (Mid-Autumn Festival Eve)*



[slanissue.com]: http://www.slanissue.com/ "Beijing Slanissue Technology Co., Ltd."
[beva.com]: http://www.beva.com/ "Beva.com"

[moky]: http://moky.github.com/ "About me"

[slanissue-ios]: https://github.com/moky/slanissue-ios "Slanissue Toolkit for iOS"

[slanissue-ios.zip]: https://github.com/moky/slanissue-ios/archive/master.zip "Slanissue Toolkit for iOS"
[snowcat-ios.zip]: https://github.com/moky/snowcat-ios/archive/master.zip "SnowCat for iOS"

[beva.tv]: https://itunes.apple.com/cn/app/bei-wa-er-ge2015/id716603240?mt=8 "AppStore"
[beva.fm]: https://itunes.apple.com/cn/app/bei-wa-ting-ting/id989100723?mt=8 "AppStore"

[snowcat.jpg]: http://img.diytrade.com/cdimg/860989/8004577/0/1234846770.jpg "Snowcat"
