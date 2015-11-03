//
//  AppDelegate.m
//  Hang
//
//  Created by iCoderz_Ankit on 9/9/15.
//  Copyright (c) 2015 iCoderz. All rights reserved.
//

#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import <sys/utsname.h>

@interface AppDelegate () <CLLocationManagerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    
    [self apperence];
    [self location];
    [self notification:application];
    [self setDefaults];
        
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    [appDelegate.arrFBEvents removeAllObjects];
    //Facebook event refresh every time user goes to background
    
    [appDelegate.locationManager startUpdatingLocation];
    
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

#pragma mark -

-(void)apperence{
    
    [[UINavigationBar appearance] setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:252.0/255.0 green:102.0/255.0 blue:33.0/255.0 alpha:1.0]] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"OpenSans-Semibold" size:18.0]}];
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    [[UINavigationBar appearance] setTranslucent:NO];
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-2000, 0) forBarMetrics:UIBarMetricsDefault];

}

-(void)location{
    
    BOOL locationAllowed = [CLLocationManager locationServicesEnabled];
    
    if (locationAllowed) {
        
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        if(IS_OS_8_OR_LATER) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        else{
            
        }
        
        [self.locationManager startUpdatingLocation];
        
    }
    else{
        
        appDelegate.currentLocation = [[CLLocation alloc] initWithLatitude:37.7577 longitude:-122.4376];//San Francisco Location
        
//        [`[MessageBarManager sharedInstance] showMessageWithTitle:appName
//                                                     description:@"No location available.\nPl ease turn Location services ON from Settings."
//                                                            type:MessageBarMessageTypeInfo];
        
    }
    
}

-(void)notification:(UIApplication*)application
{
    
    //-- Set Remote Notification
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        // iOS 8 Notifications
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
        [application registerForRemoteNotifications];
    }
    else
    {
        // iOS < 8 Notifications
        [application registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    }
}

-(void)setDefaults{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([[[defaults dictionaryRepresentation] allKeys] containsObject:key_indexWeekStart]) {
        self.indexWeekStart = [defaults integerForKey:key_indexWeekStart];
    }
    else
    {
        self.indexWeekStart = 0;//Sunday(1)
        [defaults setInteger:self.indexWeekStart forKey:key_indexWeekStart];
        [defaults synchronize];
    }
    
    if ([[[defaults dictionaryRepresentation] allKeys] containsObject:key_indexAlert]) {
        self.indexAlert= [defaults integerForKey:key_indexAlert];
    }
    else
    {
        self.indexAlert = 0;//None
        [defaults setInteger:self.indexAlert forKey:key_indexAlert];
        [defaults synchronize];
    }

}

#pragma mark - Push Notification

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *strDeviceToken = [deviceToken.description stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    strDeviceToken = [strDeviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
//    NSLog(@"My token is: %@", strDeviceToken);
    
    //    [[[UIAlertView alloc]initWithTitle:strDeviceToken message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    [[NSUserDefaults standardUserDefaults] setObject:strDeviceToken forKey:@"DeviceToken"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//        UIPasteboard *paste = [UIPasteboard generalPasteboard];
//        [paste setString:strDeviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    
    [[NSUserDefaults standardUserDefaults] setObject:@"TEMP_TOKEN" forKey:@"DeviceToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"%@",[error localizedDescription]);
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //    NSDictionary *appdic = userInfo[@"aps"];
    //    [[CommonMethods sharedManager] funShowAlert:[appdic valueForKey:@"alert"]];
}

#pragma mark - Location

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    if (!oldLocation ||
        (oldLocation.coordinate.latitude != newLocation.coordinate.latitude &&
         oldLocation.coordinate.longitude != newLocation.coordinate.longitude)) {
            
            self.currentLocation = newLocation;
            
        }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    
    NSLog(@"%@", error);
    
    appDelegate.currentLocation = [[CLLocation alloc] initWithLatitude:37.7577 longitude:-122.4376];//San Francisco Location
    
    if ([[error domain] isEqualToString:kCLErrorDomain] && [error code] == kCLErrorDenied) {
//        [[MessageBarManager sharedInstance] showMessageWithTitle:appName
//                                                     description:@"No location available.\nPlease turn Location services ON from Settings."
//                                                            type:MessageBarMessageTypeInfo];
    }
}

#pragma mark - Global Method

- (void)setMenuBarButtonInController:(UIViewController*)controller{
    
    [controller.view addGestureRecognizer:self.revealController.panGestureRecognizer];
    
    controller.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Menu"] style:UIBarButtonItemStylePlain target:controller.revealViewController action:@selector(revealToggleAnimated:)];
    
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)saveUserObject:(UserObject *)object {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:@"UserObject"];
    [defaults synchronize];
}

- (UserObject *)getUserObject {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:@"UserObject"];
    UserObject *object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return object;
}

- (void)deleteUserObject {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"UserObject"];
}

- (void)setBackbuttonIfNeededInController:(UIViewController*)vc{
    
    if (vc.navigationController.viewControllers.count > 1) {
        
        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Back"] style:UIBarButtonItemStylePlain target:vc.navigationController action:@selector(popViewControllerAnimated:)];
        backButtonItem.tintColor = [UIColor whiteColor];
        vc.navigationItem.leftBarButtonItem = backButtonItem;
    }
}

- (NSString*)setNameOfUserFromFirstName:(NSString*)strFirstname andUserName:(NSString*)strUserName{
    
    if (!strFirstname) {
        strFirstname = @"";
    }
    
    if (!strUserName) {
        strUserName = @"";
    }
    
    if (strFirstname.length == 0) {
        return strUserName;
    }
    else{
        return strFirstname;
    }
}

#pragma mark -
#pragma mark - Application Loading

- (void)showActivity
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
}

- (void)showActivityWithStatus:(NSString *)str
{
    [SVProgressHUD showWithStatus:str maskType:SVProgressHUDMaskTypeBlack];
}

- (void)hideActivityWithSuccess:(NSString *)str
{
    [SVProgressHUD showSuccessWithStatus:str maskType:SVProgressHUDMaskTypeBlack];
}

- (void)hideActivityWithError:(NSString *)str
{
    [SVProgressHUD showErrorWithStatus:str maskType:SVProgressHUDMaskTypeBlack];
}

- (void)hideActivityWithInfo:(NSString *)str
{
    [SVProgressHUD showInfoWithStatus:str maskType:SVProgressHUDMaskTypeBlack];
}

- (void)hideActivity
{
    [SVProgressHUD dismiss];
}

@end


@implementation NSString (NSString_Extended)

- (NSString *)urlencode {
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[self UTF8String];
    unsigned long sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}

-(NSString *)emojiEncode{
        
    NSString *output = [NSString string];
    
    NSString *uniText = [NSString stringWithUTF8String:[[self stringByTrimmingCharactersInSet:[NSMutableCharacterSet whitespaceCharacterSet]] UTF8String]];
    NSData *msgData = [uniText dataUsingEncoding:NSNonLossyASCIIStringEncoding];
    output = [[NSString alloc] initWithData:msgData encoding:NSUTF8StringEncoding];
    
    return output;
    
}

-(NSString *)emojiDecode{
    
    NSString *output = [NSString string];
    
    const char *jsonString = [self UTF8String];
    NSData *jsonData = [NSData dataWithBytes:jsonString length:strlen(jsonString)];
    output = [[NSString alloc] initWithData:jsonData encoding:NSNonLossyASCIIStringEncoding];
    
    return output;
    
}

- (BOOL)isValidEmail{
    
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];

}

- (BOOL)isValidPassword{
    
    BOOL isValid = NO;
    isValid = (self.length>=6)?YES:NO;
    return isValid;
    
}



@end
