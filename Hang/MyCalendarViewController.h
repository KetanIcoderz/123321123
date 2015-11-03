//
//  MyCalendarViewController.h
//  Hang
//
//  Created by iCoderz_Ankit on 9/10/15.
//  Copyright (c) 2015 iCoderz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTCalendar.h"

@interface MyCalendarViewController : UIViewController<JTCalendarDelegate>
{
    IBOutlet UIView *vwTouchToMove,*vwToPull;
    IBOutlet UISearchBar *sBar;
    IBOutlet UITableView *tblView;
    NSMutableArray *arrProfile;
    
    NSMutableArray *arrEvents;
}

@property (weak, nonatomic) IBOutlet JTHorizontalCalendarView *calendarContentView;
@property (strong, nonatomic) JTCalendarManager *calendarManager;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendarContentViewHeight;
@property NSDate *dateSelected;
@end
