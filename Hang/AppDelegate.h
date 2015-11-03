//
//  AppDelegate.h
//  Hang
//
//  Created by iCoderz_Ankit on 9/9/15.
//  Copyright (c) 2015 iCoderz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "UserObject.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) SWRevealViewController *revealController;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (nonatomic) NSInteger indexWeekStart,indexAlert;
@property (strong, nonatomic) NSMutableArray *arrFBEvents;
@property (strong, nonatomic) NSMutableArray *arrFacebookFrds;

- (UIImage *)imageWithColor:(UIColor *)color;
- (void)setMenuBarButtonInController:(UIViewController*)controller;

- (void)showActivity;
- (void)showActivityWithStatus:(NSString *)str;
- (void)hideActivityWithInfo:(NSString *)str;
- (void)hideActivityWithSuccess:(NSString *)str;
- (void)hideActivityWithError:(NSString *)str;
- (void)hideActivity;

- (void)saveUserObject:(UserObject *)object;
- (UserObject *)getUserObject;
- (void)deleteUserObject;

- (void)setBackbuttonIfNeededInController:(UIViewController*)vc;

- (NSString*)setNameOfUserFromFirstName:(NSString*)strFirstname andUserName:(NSString*)strUserName;

@end

@interface NSString (NSString_Extended)

- (NSString *)urlencode;
- (NSString *)emojiDecode;
- (NSString *)emojiEncode;
- (BOOL)isValidEmail;
- (BOOL)isValidPassword;



@end
