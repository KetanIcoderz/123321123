//
//  CreateEventViewController.h
//  Hang
//
//  Created by iCoderz_Ankit on 9/10/15.
//  Copyright (c) 2015 iCoderz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateEventViewController : UIViewController
{
    IBOutlet UITextField *tfName;
    IBOutlet UITextView *tfDetail;
    IBOutlet UIButton *btnStartDate,*btnEndDate,*btnStartTime,*btnEndTime,*btnLocation,*btnShareFriend,*btnShareGroup;
    IBOutlet UISwitch *swEdit,*swInvite;
    IBOutlet UIScrollView *sv;
    IBOutlet UIView *viewOptional,*viewRepeat,*viewInner;
    IBOutlet NSLayoutConstraint *constrainOptionalHeight,*constrainRepeatHeight;
    IBOutlet UILabel *lblOptionView;
    IBOutlet UICollectionView *cvRepeat,*cvRemind,*cvOptional;
    
    NSIndexPath *indexRepeat,*indexRemind,*indexMonthDay;
    NSMutableArray *arrRepeat,*arrReminder,*arrWeekDays,*arrSelectedWeekDays,*arrMonthDay;
    NSDate *dateStartDate,*dateEndDate,*dateStartTime,*dateEndTime;
    
    UILabel*lbl;
}

@property (nonatomic,strong) NSString *strLocation;
@property CLLocationCoordinate2D cord;
@property (nonatomic,strong) NSMutableArray *arrFriend,*arrGroup;

@end
