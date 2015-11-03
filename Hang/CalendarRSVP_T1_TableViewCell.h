//
//  CalendarRSVP_TableViewCell.h
//  Calender
//
//  Created by iCoderz_Binal on 18/09/15.
//  Copyright (c) 2015 iCoderz_Binal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarRSVP_T1_TableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *lbl_EventTime;
@property (nonatomic, weak) IBOutlet UILabel *lbl_TimeRemaining;
@property (nonatomic, weak) IBOutlet UILabel *lbl_EventName;
@property (nonatomic, weak) IBOutlet UILabel *lbl_EventDescription;

@property (nonatomic, weak) IBOutlet UIButton *btn_Share;
@property (nonatomic, weak) IBOutlet UIButton *btn_Message;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *conTitleHeight;

@end
