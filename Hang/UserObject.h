//
//  UserObject.h
//  Hang
//
//  Created by iCoderz_Ankit on 9/18/15.
//  Copyright (c) 2015 iCoderz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserObject : NSObject

@property (nonatomic,strong) NSString *user_RegDate;
@property (nonatomic,strong) NSString *user_acccessToken;
@property (nonatomic,strong) NSString *user_email;
@property (nonatomic,strong) NSString *user_facebookSync;
@property (nonatomic,strong) NSString *user_firstName;
@property (nonatomic,strong) NSString *user_id;
@property (nonatomic,strong) NSString *user_isBlocked;
@property (nonatomic,strong) NSString *user_deviceInfo;
@property (nonatomic,strong) NSString *user_isPrivate;
@property (nonatomic,strong) NSString *user_lastChange;
@property (nonatomic,strong) NSString *user_lastLogin;
@property (nonatomic,strong) NSString *user_lastName;
@property (nonatomic,strong) NSString *user_mobileNo;
@property (nonatomic,strong) NSString *user_osVersion;
@property (nonatomic,strong) NSString *user_name;
@property (nonatomic,strong) NSString *user_profilePictureURL;
@property (nonatomic,strong) NSString *user_type;
@property (nonatomic,strong) NSString *ProfileImage;
@property BOOL isFriend;
@end
