//
//  AppDelegate.m
//  AlloChambre
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "Constants.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    NSString *nibName = @"MainViewController";
    if ([UIDeviceHardware IsDeviceHas4InchDisplay]) {
        NSLog(@"Device is iPhone 5");
        nibName = @"MainViewController_iPhone5";
    }
    self.viewController = [[[MainViewController alloc] initWithNibName:nibName bundle:nil] autorelease];
    
    // Setting UP Main Navigation Controller for App
    UINavigationController *mainNavController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    mainNavController.navigationBar.translucent = NO;
    [mainNavController.navigationBar setTintColor:kNavBarTintColor];
    
    self.window.rootViewController = mainNavController;
    [mainNavController release];
    mainNavController = nil;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
	if ([self.viewController.searchTF isFirstResponder]) {
		[self.viewController.searchTF resignFirstResponder];
	}
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
	if (! ([CLLocationManager locationServicesEnabled])
		|| ( [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)) {
		self.viewController.btnGeolocateMe.alpha = 0.4f;
	}
	else {
		self.viewController.btnGeolocateMe.alpha = 1.0f;
	}
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
