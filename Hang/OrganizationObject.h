//
//  OrganizationObject.h
//  Calender
//
//  Created by iCoderz_Binal on 28/09/15.
//  Copyright © 2015 iCoderz_Binal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrganizationObject : NSObject

@property (nonatomic, strong) NSString *org_id;
@property (nonatomic, strong) NSString *org_creatorID;
@property (nonatomic, strong) NSString *org_name;
@property (nonatomic, strong) NSString *org_detail;
@property BOOL org_isPrivate,org_allowToShare,org_isActive;
@property (nonatomic, strong) NSString *org_dateCreated;
@property (nonatomic, strong) NSString *FollowersCount;
@property (nonatomic, strong) NSString *mutualCount;
@property BOOL isFollowed;

@end
