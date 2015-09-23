# SnowCat

SnowCat.framework for iOS application
is a framework for developing apps via creating some '.plist' files simply.

## Example 1: Hello world

> AppDelegate.m

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

> main.plist

	Root : {
		Node : {
			comment : "here is the main entrance",
			window : {
				rootViewController : 'include file="page1.plist"'
			}
		}
	}

> page1.plist

	Root : {
		Node : {
			Class : "ViewController",
			view : {
				subviews : [
					{
						Class  : "Label",
						text   : "Hello world!",
						color  : "{0, 0, 255}",
						center : "{center, middle - 50}"
					},
					{
						Class  : "Button",
						title  : "click me",
						color  : "{0, 255, 0}",
						center : "{center, middle + 50}",
						events : {
							onClick : [
								{
									name    : "Alert",
									message : "Hey girl?"
								},
								{
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
