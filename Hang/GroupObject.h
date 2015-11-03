//
//  GroupObject.h
//  Hang
//
//  Created by iCoderz_Ankit on 10/5/15.
//  Copyright © 2015 iCoderz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupObject : NSObject

@property (nonatomic,strong) NSString *group_id;
@property (nonatomic,strong) NSString *group_name;
@property (nonatomic,strong) NSString *group_creatorID;
@property (nonatomic,strong) NSString *group_allowToInvite;
@property (nonatomic,strong) NSString *group_dateCreated;
@property (nonatomic,strong) NSString *group_isActive;
@property (nonatomic,strong) NSString *group_status;

@end
