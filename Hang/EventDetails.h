//
//  EventDetails.h
//  Hang
//
//  Created by iCoderz_Binal on 26/09/15.
//  Copyright © 2015 iCoderz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventDetails : NSObject

@property (nonatomic, strong) NSString *event_id;
@property (nonatomic, strong) NSString *event_name;
@property (nonatomic, strong) NSString *event_location;
@property (nonatomic, strong) NSString *event_isRepeating;
@property (nonatomic, strong) NSString *event_startTime;
@property (nonatomic, strong) NSString *event_endTime;
@property (nonatomic, strong) NSString *event_creatorName;
@property (nonatomic, strong) NSString *event_creatorUserName;
@property (nonatomic, strong) NSString *event_invitorName;
@property (nonatomic, strong) NSString *event_invitorUserName;
@property (nonatomic, strong) NSString *event_MyStatus;
@property (nonatomic, strong) NSString *event_yes_count;
@property (nonatomic, strong) NSString *event_no_count;
@property (nonatomic, strong) NSString *event_maybe_count;
@property (nonatomic, strong) NSString *event_allowToInvite;
@property (nonatomic, strong) NSString *event_allowToEdit;
@property (nonatomic, strong) NSString *event_detail;
@property (nonatomic, strong) NSMutableArray *Participant;
@property (nonatomic, strong) NSString *event_date;
@property (nonatomic, strong) NSDictionary *invitedBy;
@property BOOL isFBEvent;


@end
