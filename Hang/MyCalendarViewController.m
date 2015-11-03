//
//  MyCalendarViewController.m
//  Hang
//
//  Created by iCoderz_Ankit on 9/10/15.
//  Copyright (c) 2015 iCoderz. All rights reserved.
//

#import "MyCalendarViewController.h"

#import "CalendarRSVP_T1_TableViewCell.h"
#import "CalendarRSVP_T2_TableViewCell.h"
#import "CalendarConfirmed_TableViewCell.h"

#import <QuartzCore/QuartzCore.h>
#import "CMPopTipView.h"
#import "EventDetails.h"
#import "UserObject.h"
#import "UIImageView+WebCache.h"
#import "InviteViewController.h"
#import "MenuViewController.h"
#import "EventDetailViewController.h"

@interface MyCalendarViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, CMPopTipViewDelegate, WebNetworkingDelegate>
{
    NSMutableDictionary *_eventsByDate;
    
    NSDate *_todayDate;
    NSDate *_minDate;
    NSDate *_maxDate;
    
    
    
    //CMPopTipViewDelegate
    NSMutableArray	*visiblePopTipViews;
    
}

@end

@implementation MyCalendarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [appDelegate setMenuBarButtonInController:self];
    
    _calendarManager = [JTCalendarManager new];
    _calendarManager.delegate = self;
    _calendarManager.dateHelper.weekStartDay = appDelegate.indexWeekStart+1;//For picker in settings it's start with 0 but for sunday in calendar it's start with 1(sunday) to 7(saturaday).So we need to add 1 before setting weekStartDay;
    _dateSelected = [NSDate date];
    
    // Create a min and max date for limit the calendar, optional
    [self createMinAndMaxDate];
    
    [_calendarManager setContentView:_calendarContentView];
    [_calendarManager setDate:_todayDate];
    
    [self didGoTodayTouch];
    
    arrProfile = [NSMutableArray new];
    
    [sBar setBackgroundImage:[appDelegate imageWithColor:[UIColor clearColor]] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    
    vwToPull.layer.cornerRadius = 2;
    vwToPull.layer.masksToBounds = YES;
    
    [self didChangeModeTouch];
    
    [appDelegate setBackbuttonIfNeededInController:self];
    
    [self registerForAPNS];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

- (void)viewDidAppear:(BOOL)animated
{
    arrEvents = [NSMutableArray new];
    [self GetEvent:[self getStringFromDate:_dateSelected]];
}

- (NSString *)getStringFromDate:(NSDate *)date
{
    NSDateFormatter *dtFormatter = [NSDateFormatter new];
    [dtFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dtFormatter stringFromDate:date];
}

-(void)registerForAPNS{
    
    NSString *strDEviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"DeviceToken"];
    
    [[WebNetworking new] sendRequestWithUrl:makeUserURL(RegisterForAPNS)
                                 parameater:@{@"UserID":appDelegate.getUserObject.user_id,
                                              @"DeviceToken":strDEviceToken,
                                              @"Type":@"I"}
                                   delegate:nil
                            withRequestName:@"RegisterForAPNS"];
    
}

- (void)viewDidLayoutSubviews
{
    
}

-(NSString*)getFacebookDate:(NSString*)strDate{
    
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSDate *d = [df dateFromString:strDate];
    
    if (!d) {
        [df setDateFormat:@"yyyy-MM-dd"];
        NSDate *dNew = [df dateFromString:strDate];
        return dNew?strDate:@"0000-00-00";
    }
    
    [df setDateFormat:@"yyyy-MM-dd"];
    return [df stringFromDate:d];
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"invite"]) {
        
        NSUInteger index = ((UIButton*)sender).tag - 1000;
        
        InviteViewController *obj = (InviteViewController*)[segue destinationViewController];
        obj.objEvent = arrEvents[index];
    }
    else if ([segue.identifier isEqualToString:@"showDetail1"] | [segue.identifier isEqualToString:@"showDetail2"] | [segue.identifier isEqualToString:@"showDetail3"]){
        
        NSUInteger index = [tblView indexPathForSelectedRow].row;
        
        EventDetailViewController *obj = (EventDetailViewController*)[segue destinationViewController];
        obj.objEvent = arrEvents[index];
        obj.strDate = [self getStringFromDate:_dateSelected];
    }
}


#pragma mark - UISearchBar

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    return NO;
}

#pragma mark - Buttons callback

- (void)didGoTodayTouch
{
    [_calendarManager setContentView:_calendarContentView];
    [_calendarManager setDate:_todayDate];
    
    NSDateFormatter *dtFormatter = [NSDateFormatter new];
    dtFormatter.dateFormat = @"MMMM yyyy";
    NSString *str = [dtFormatter stringFromDate:_calendarContentView.date];
    self.title = str;
    
}

- (void)didChangeModeTouch
{
    _calendarManager.settings.weekModeEnabled = !_calendarManager.settings.weekModeEnabled;
    [_calendarManager reload];
    
    CGFloat newHeight = _calendarContentViewHeight.constant;
    if(_calendarManager.settings.weekModeEnabled)
    {
        newHeight = (newHeight/6)*2;//85;
    }
    else{
        newHeight = (newHeight*6)/2;
    }
    
    self.calendarContentViewHeight.constant = newHeight;

}

#pragma mark - CalendarManager delegate

// Exemple of implementation of prepareDayView method
// Used to customize the appearance of dayView
- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    dayView.hidden = NO;
        
    // Other month
    if([dayView isFromAnotherMonth] && !calendar.settings.weekModeEnabled){
        dayView.hidden = YES;
    }
    
    //    // Today
    //    if([_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]){
    //        dayView.circleView.hidden = NO;
    //        dayView.circleView.backgroundColor = [UIColor whiteColor];
    //        dayView.dotView.backgroundColor = [UIColor whiteColor];
    //        dayView.textLabel.textColor = [UIColor orangeColor];
    //    }
    // Selected date
    if(_dateSelected && [_calendarManager.dateHelper date:_dateSelected isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor whiteColor];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = kOrangeColor;
    }
    // Other month
    else if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor colorWithRed:202.0/255.0 green:201.0/255.0 blue:201.0/255.0 alpha:1.0];
    }
    // Another day of the current month
    else{
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor colorWithRed:202.0/255.0 green:201.0/255.0 blue:201.0/255.0 alpha:1.0];
    }
    
    if([self haveEventForDay:dayView.date]){
        dayView.dotView.hidden = NO;
    }
    else{
        dayView.dotView.hidden = YES;
    }
}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    if (tblView.isDecelerating || tblView.tracking || tblView.dragging) {
        return;
    }
    
    [arrEvents removeAllObjects];
    
    //    dayView.manager.
    _dateSelected = dayView.date;
    
    // Animation for the circleView
    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    [UIView transitionWithView:dayView
                      duration:.3
                       options:0
                    animations:^{
                        dayView.circleView.transform = CGAffineTransformIdentity;
                        [_calendarManager reload];
                    } completion:nil];
    
    
    // Load the previous or next page if touch a day from another month
    
    if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]  && !_calendarManager.settings.weekModeEnabled){
        if([_calendarContentView.date compare:dayView.date] == NSOrderedAscending){
            [_calendarContentView loadNextPageWithAnimation];
        }
        else{
            [_calendarContentView loadPreviousPageWithAnimation];
        }
    }
    
//    NSString *nameformatString = [NSString stringWithFormat:@"event_date contains[c] '%@'", [self getStringFromDate:_dateSelected]];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:nameformatString];
//    NSMutableArray *arr = appDelegate.arrFBEvents;
//    NSArray *arrTemp = [arr filteredArrayUsingPredicate:predicate];
    
//    [arrEvents addObjectsFromArray:arrTemp];
    
    [self GetEvent:[self getStringFromDate:_dateSelected]];
}

#pragma mark - CalendarManager delegate - Page mangement

// Used to limit the date for the calendar, optional
- (BOOL)calendar:(JTCalendarManager *)calendar canDisplayPageWithDate:(NSDate *)date
{
    return TRUE;
    //    return [_calendarManager.dateHelper date:date isEqualOrAfter:_minDate andEqualOrBefore:_maxDate];
}

- (void)calendarDidLoadNextPage:(JTCalendarManager *)calendar
{
    NSDateFormatter *dtFormatter = [NSDateFormatter new];
    dtFormatter.dateFormat = @"MMMM yyyy";
    NSString *str = [dtFormatter stringFromDate:calendar.contentView.date];
    self.title = str;
}

- (void)calendarDidLoadPreviousPage:(JTCalendarManager *)calendar
{
    NSDateFormatter *dtFormatter = [NSDateFormatter new];
    dtFormatter.dateFormat = @"MMMM yyyy";
    NSString *str = [dtFormatter stringFromDate:calendar.contentView.date];
    self.title = str;
}

#pragma mark - Fake data

- (void)createMinAndMaxDate
{
    _todayDate = [NSDate date];
    
    // Min date will be 2 month before today
    _minDate = _todayDate;
    
    // Max date will be 2 month after today
    _maxDate = [_calendarManager.dateHelper addToDate:_todayDate months:24];
}

// Used only to have a key for _eventsByDate
- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"dd-MM-yyyy";
    }
    return dateFormatter;
}

- (BOOL)haveEventForDay:(NSDate *)date
{
    NSString *key = [[self dateFormatter] stringFromDate:date];
    
    if(_eventsByDate[key] && [_eventsByDate[key] count] > 0){
        return YES;
    }
    
    return NO;
    
}

- (IBAction)SwipeUp:(id)sender
{
    if(!_calendarManager.settings.weekModeEnabled)
    {
        [_calendarManager setContentView:_calendarContentView];
        [_calendarManager setDate:_dateSelected];
        
        _calendarManager.settings.weekModeEnabled = YES;
        
        [_calendarManager reload];
        
        CGFloat newHeight = _calendarContentViewHeight.constant;
        newHeight = (newHeight/6)*2;//85;
        self.calendarContentViewHeight.constant = newHeight;
        [self.view layoutIfNeeded];
        
        [self setTitleString];
    }
    
    
}

- (IBAction)SwipeDown:(id)sender
{
    if(_calendarManager.settings.weekModeEnabled)
    {
        [_calendarManager setContentView:_calendarContentView];
        [_calendarManager setDate:_dateSelected];
        
        _calendarManager.settings.weekModeEnabled = NO;
        [_calendarManager reload];
        
        CGFloat newHeight = _calendarContentViewHeight.constant;
        newHeight = (newHeight*6)/2;
        self.calendarContentViewHeight.constant = newHeight;
        [self.view layoutIfNeeded];
        
        [self setTitleString];
    }
}

- (void)setTitleString
{
    NSDateFormatter *dtFormatter = [NSDateFormatter new];
    dtFormatter.dateFormat = @"MMMM yyyy";
    NSString *str = [dtFormatter stringFromDate:_calendarContentView.date];
    self.title = str;
}
#pragma mark - UItableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrEvents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    EventDetails *objEvent = [arrEvents objectAtIndex:indexPath.row];
    if([objEvent.event_MyStatus isEqualToString:@""])
    {
        CalendarConfirmed_TableViewCell *cell = (CalendarConfirmed_TableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CELL_Calendar_confirmed" forIndexPath:indexPath];
        
        cell.btn_Share.enabled = [objEvent.event_allowToInvite isEqualToString:@"1"];
        
        [cell.btn_Share addTarget:self action:@selector(selectShare:) forControlEvents:UIControlEventTouchUpInside];
        cell.btn_Share.tag = 1000 + indexPath.row;
        
        [cell.btn_Message addTarget:self action:@selector(selectMessage:) forControlEvents:UIControlEventTouchUpInside];
        cell.btn_Message.tag = 2000 + indexPath.row;
        
        [cell.btn_YES addTarget:self action:@selector(selectYes:) forControlEvents:UIControlEventTouchUpInside];
        cell.btn_YES.tag = 3000 + indexPath.row;
        
        [cell.btn_MAYBE addTarget:self action:@selector(selectMaybe:) forControlEvents:UIControlEventTouchUpInside];
        cell.btn_MAYBE.tag = 4000 + indexPath.row;
        
        [cell.btn_NO addTarget:self action:@selector(selectNo:) forControlEvents:UIControlEventTouchUpInside];
        cell.btn_NO.tag = 5000 + indexPath.row;
        
        cell.lbl_EventName.text = objEvent.event_name;
        cell.lbl_EventName.textColor = objEvent.isFBEvent?[UIColor colorWithRed:70.0/255.0 green:90.0/255.0 blue:160.0/255.0 alpha:1.0]:[UIColor blackColor];
        cell.lbl_EventDescription.text = objEvent.event_detail;
        
        if ([objEvent.event_isRepeating isEqualToString:@"0"] || [objEvent.event_isRepeating isEqualToString:@"4"]) {
            cell.lbl_EventTime.text = [self getOnlyTime:objEvent.event_startTime].uppercaseString;
        }
        else{
            cell.lbl_EventTime.text = objEvent.event_startTime.uppercaseString;
        }
        
        cell.lbl_TimeRemaining.text = [self funGetDuration:objEvent.event_startTime :objEvent.event_endTime isReapting:objEvent.event_isRepeating];
        
        if ([_dateSelected compare:[self dateAtStartOfDay]] == NSOrderedAscending) {
            cell.btn_Share.hidden = YES;
            cell.btn_YES.hidden = YES;
            cell.btn_NO.hidden = YES;
            cell.btn_MAYBE.hidden = YES;
        }
        else{
            cell.btn_Share.hidden = NO;
            cell.btn_YES.hidden = NO;
            cell.btn_NO.hidden = NO;
            cell.btn_MAYBE.hidden = NO;
        }

        
        if ([cell respondsToSelector:@selector(preservesSuperviewLayoutMargins)]){
            cell.layoutMargins = UIEdgeInsetsZero;
            cell.preservesSuperviewLayoutMargins = false;
        }

        
        return cell;
    }
    else if(([objEvent.event_MyStatus isEqualToString:@"YES"] | [objEvent.event_MyStatus isEqualToString:@"NO"] | [objEvent.event_MyStatus isEqualToString:@"MayBe"]) && objEvent.Participant.count>5)
    {
        CalendarRSVP_T1_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL_Calendar_rsvp_t1" forIndexPath:indexPath];
        
        cell.btn_Share.enabled = [objEvent.event_allowToInvite isEqualToString:@"1"];
        
        NSString *strAttnValue = objEvent.event_yes_count;
        NSString *strMaybeValue = objEvent.event_maybe_count;
        NSString *strNoValue = objEvent.event_no_count;
        
        cell.lbl_EventDescription.attributedText = [self setDescriptionTextForAttend:strAttnValue Maybe:strMaybeValue No:strNoValue];
        
        [cell.btn_Share addTarget:self action:@selector(selectShare:) forControlEvents:UIControlEventTouchUpInside];
        cell.btn_Share.tag = 1000 + indexPath.row;
        
        [cell.btn_Message addTarget:self action:@selector(selectMessage:) forControlEvents:UIControlEventTouchUpInside];
        cell.btn_Message.tag = 2000 + indexPath.row;
        
        cell.lbl_EventName.text = objEvent.event_name;
        cell.lbl_EventName.textColor = objEvent.isFBEvent?[UIColor colorWithRed:70.0/255.0 green:90.0/255.0 blue:160.0/255.0 alpha:1.0]:[UIColor blackColor];
        cell.lbl_TimeRemaining.text = [self funGetDuration:objEvent.event_startTime :objEvent.event_endTime isReapting:objEvent.event_isRepeating];
        
        if ([objEvent.event_isRepeating isEqualToString:@"0"] || [objEvent.event_isRepeating isEqualToString:@"4"]) {
            cell.lbl_EventTime.text = [self getOnlyTime:objEvent.event_startTime].uppercaseString;
        }
        else{
            cell.lbl_EventTime.text = objEvent.event_startTime.uppercaseString;
        }
        
        if ([_dateSelected compare:[self dateAtStartOfDay]] == NSOrderedAscending) {
            cell.btn_Share.hidden = YES;
        }
        else{
            cell.btn_Share.hidden = NO;
        }

        
        if ([cell respondsToSelector:@selector(preservesSuperviewLayoutMargins)]){
            cell.layoutMargins = UIEdgeInsetsZero;
            cell.preservesSuperviewLayoutMargins = false;
        }
        
        return cell;
    }
    else if(([objEvent.event_MyStatus isEqualToString:@"YES"] | [objEvent.event_MyStatus isEqualToString:@"NO"] | [objEvent.event_MyStatus isEqualToString:@"MayBe"]) && objEvent.Participant.count<=5)
    {
        CalendarRSVP_T2_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL_Calendar_rsvp_t2" forIndexPath:indexPath];
        
        cell.btn_Share.enabled = [objEvent.event_allowToInvite isEqualToString:@"1"];
        
        [cell.btn_Share addTarget:self action:@selector(selectShare:) forControlEvents:UIControlEventTouchUpInside];
        cell.btn_Share.tag = 1000 + indexPath.row;
        
        [cell.btn_Message addTarget:self action:@selector(selectMessage:) forControlEvents:UIControlEventTouchUpInside];
        cell.btn_Message.tag = 2000 + indexPath.row;
        
        [arrProfile removeAllObjects];
        
        for (int i=0; i<objEvent.Participant.count; i++)
        {
            [arrProfile addObject:[[objEvent.Participant objectAtIndex:i] valueForKey:@"ProfileImage"]];
        }
        
        cell.collectionVw.tag = indexPath.row;
        cell.collectionVw.delegate = self;
        cell.collectionVw.dataSource = self;
        [cell.collectionVw reloadData];
        
        cell.lbl_EventName.text = objEvent.event_name;
        cell.lbl_EventName.textColor = objEvent.isFBEvent?[UIColor colorWithRed:70.0/255.0 green:90.0/255.0 blue:160.0/255.0 alpha:1.0]:[UIColor blackColor];
        cell.lbl_TimeRemaining.text = [self funGetDuration:objEvent.event_startTime :objEvent.event_endTime isReapting:objEvent.event_isRepeating];
        
        if ([objEvent.event_isRepeating isEqualToString:@"0"] || [objEvent.event_isRepeating isEqualToString:@"4"])
        {
            cell.lbl_EventTime.text = [self getOnlyTime:objEvent.event_startTime].uppercaseString;
        }
        else
        {
            cell.lbl_EventTime.text = objEvent.event_startTime.uppercaseString;
        }
        
        [cell.lbl_EventName sizeToFit];
        CGFloat height = cell.lbl_EventName.frame.size.height;
        cell.conTitleHeight.constant = MIN(44, height);
        
        if ([_dateSelected compare:[self dateAtStartOfDay]] == NSOrderedAscending) {
            cell.btn_Share.hidden = YES;
        }
        else{
            cell.btn_Share.hidden = NO;
        }

        
        if ([cell respondsToSelector:@selector(preservesSuperviewLayoutMargins)]){
            cell.layoutMargins = UIEdgeInsetsZero;
            cell.preservesSuperviewLayoutMargins = false;
        }
        
        return cell;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath{
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(NSString *)funGetDuration:(NSString *)strStart :(NSString *)strEnd isReapting:(NSString*)reapeating
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = ([reapeating isEqualToString:@"0"] | [reapeating isEqualToString:@"4"])?@"yyyy-MM-dd hh:mm a":@"hh:mm a";
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmt];
    NSDate *localDate = [dateFormatter dateFromString:strStart];
    NSDate *localDate1 = [dateFormatter dateFromString:strEnd];
    
    NSDateComponentsFormatter *dcf = [NSDateComponentsFormatter new];
    dcf.unitsStyle = NSDateComponentsFormatterUnitsStyleAbbreviated;
    dcf.maximumUnitCount = 2;

    NSString *interval = [dcf stringFromTimeInterval:[localDate1 timeIntervalSinceDate:localDate]];
    
    if ([interval containsString:@"m"] && [[NSDate date] timeIntervalSinceDate:localDate] > 3600) {
        
        interval = [interval uppercaseString];
    }
    
    
    return [NSString stringWithFormat:@"%@",interval];
    
}

-(NSString *)getOnlyTime:(NSString*)da{
    
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"yyyy-MM-dd hh:mm a"];
    NSDate *d = [df dateFromString:da];
    
    [df setDateFormat:@"hh:mm a"];
    return [df stringFromDate:d];
}


- (NSDate *) dateAtStartOfDay
{
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit) fromDate:[NSDate date]];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

-(IBAction)Search:(id)sender{
    
//    [appDelegate.revealController revealToggleAnimated:YES];
    MenuViewController *obj = [((UINavigationController*)appDelegate.revealController.rearViewController).viewControllers firstObject];
    [obj openSearch];
}

#pragma mark - Event Share
- (void)selectShare:(UIButton *)sender{
 
    [self performSegueWithIdentifier:@"invite" sender:sender];
}

#pragma mark - Event Message
- (void)selectMessage:(UIButton *)sender
{
    NSUInteger index = sender.tag - 2000;
    NSLog(@"Message index : %lu", (unsigned long)index);
    
}

#pragma mark - Event Message
- (void)selectYes:(UIButton *)sender
{
    
    NSUInteger index = sender.tag - 3000;
    EventDetails *objEvent = [arrEvents objectAtIndex:index];
    NSDictionary *dict = @{@"UserID":appDelegate.getUserObject.user_id,
                           @"EventDate":[self getStringFromDate:_dateSelected],
                           @"EventID":objEvent.event_id,
                           @"Status":@"1"};
    
    [[WebNetworking new] sendRequestWithUrl:makeHangURL(JoinEvent)
                                 parameater:dict
                                   delegate:self
                            withRequestName:@"YesEvent"];
    [appDelegate showActivityWithStatus:@"Loading..."];

}

#pragma mark - Event Message
- (void)selectMaybe:(UIButton *)sender
{
    NSUInteger index = sender.tag - 4000;
    EventDetails *objEvent = [arrEvents objectAtIndex:index];
    NSDictionary *dict = @{@"UserID":appDelegate.getUserObject.user_id,
                           @"EventDate":[self getStringFromDate:_dateSelected],
                           @"EventID":objEvent.event_id,
                           @"Status":@"2"};
    
    [[WebNetworking new] sendRequestWithUrl:makeHangURL(JoinEvent)
                                 parameater:dict
                                   delegate:self
                            withRequestName:@"MaybeEvent"];
    [appDelegate showActivityWithStatus:@"Loading..."];

}

#pragma mark - Event Message
- (void)selectNo:(UIButton *)sender
{
    NSUInteger index = sender.tag - 5000;
    EventDetails *objEvent = [arrEvents objectAtIndex:index];
    NSDictionary *dict = @{@"UserID":appDelegate.getUserObject.user_id,//,
                           @"EventDate":[self getStringFromDate:_dateSelected],
                           @"EventID":objEvent.event_id,
                           @"Status":@"0"};
    
    [[WebNetworking new] sendRequestWithUrl:makeHangURL(JoinEvent)
                                 parameater:dict
                                   delegate:self
                            withRequestName:@"NoEvent"];
    [appDelegate showActivityWithStatus:@"Loading..."];

}

#pragma mark - Attributed text
- (NSMutableAttributedString *)setDescriptionTextForAttend:(NSString *)strAttendValue Maybe:(NSString *)strMaybeValue No:(NSString *)strNoValue
{
    NSMutableAttributedString *mutableAttString = [[NSMutableAttributedString alloc] init];
    
    NSDictionary *dict_blackColor = [NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
    NSDictionary *dict_orangeColor = [NSDictionary dictionaryWithObject:kOrangeColor forKey:NSForegroundColorAttributeName];
    
    
    NSString *strAttn = @"Attn ";
    NSAttributedString *attString_Attn = [[NSAttributedString alloc] initWithString:strAttn attributes:dict_blackColor];
    [mutableAttString appendAttributedString:attString_Attn];
    
    NSString *strAttn_value = [NSString stringWithFormat:@"%@  ",strAttendValue];
    NSAttributedString *attString_Attn_value = [[NSAttributedString alloc] initWithString:strAttn_value attributes:dict_orangeColor];
    [mutableAttString appendAttributedString:attString_Attn_value];
    
    
    NSString *strMaybe = @"Maybe ";
    NSAttributedString *attString_maybe = [[NSAttributedString alloc] initWithString:strMaybe attributes:dict_blackColor];
    [mutableAttString appendAttributedString:attString_maybe];
    
    NSString *strMaybe_value = [NSString stringWithFormat:@"%@  ",strMaybeValue];
    NSAttributedString *attString_maybe_value = [[NSAttributedString alloc] initWithString:strMaybe_value attributes:dict_orangeColor];
    [mutableAttString appendAttributedString:attString_maybe_value];
    
    NSString *strNo = @"No ";
    NSAttributedString *attString_No = [[NSAttributedString alloc] initWithString:strNo attributes:dict_blackColor];
    [mutableAttString appendAttributedString:attString_No];
    
    NSString *strNo_value = [NSString stringWithFormat:@"%@  ",strNoValue];
    NSAttributedString *attString_No_value = [[NSAttributedString alloc] initWithString:strNo_value attributes:dict_orangeColor];
    [mutableAttString appendAttributedString:attString_No_value];
    
    return mutableAttString;
}

#pragma mark -
#pragma mark - UICollectionView DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    EventDetails *obj = arrEvents[collectionView.tag];
    return obj.Participant.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CELL";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    UIImageView *img = [[UIImageView alloc] init];
    
    img.frame = cell.bounds;
    img.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0];
    img.layer.borderColor = [[UIColor colorWithRed:151.0/255.0 green:151.0/255.0 blue:151.0/255.0 alpha:1.0] CGColor];
    img.layer.borderWidth = 1.0;
    img.layer.cornerRadius = img.frame.size.width/2;
    img.layer.masksToBounds = YES;

    cell.backgroundView = img;
    
    EventDetails *obj = arrEvents[collectionView.tag];
    UserObject *user = obj.Participant[indexPath.row];
    
    [img setImageWithURL:[NSURL URLWithString:user.ProfileImage] placeholderImage:[UIImage imageNamed:@"profile"]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];

    EventDetails *obj = arrEvents[collectionView.tag];
    UserObject *objUser = obj.Participant[indexPath.row];
    
    UIMenuItem *flag = [[UIMenuItem alloc] initWithTitle:[appDelegate setNameOfUserFromFirstName:objUser.user_firstName andUserName:objUser.user_name] action:@selector(flag:)];
    UIMenuController *menu = [UIMenuController sharedMenuController];
    
    [menu setMenuItems:[NSArray arrayWithObjects:flag, nil]];
    [menu setTargetRect:cell.frame inView:cell.superview];
    [menu setMenuVisible:YES animated:YES];

}

#pragma mark -

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)flag:(id)sender
{
    
}

- (void)approve:(id)sender
{
    
}

- (void)deny:(id)sender
{
    
}

#pragma mark - CMPopTipViewDelegate methods
- (void)showUserName:(NSString *)str atCell:(UICollectionViewCell *)cell
{
    CMPopTipView *popTipView = [[CMPopTipView alloc] initWithMessage:str];
    popTipView.delegate = self;
    
    /* Some options to try.
     */
    //popTipView.disableTapToDismiss = YES;
    popTipView.preferredPointDirection = PointDirectionDown;
    popTipView.hasGradientBackground = NO;
    popTipView.cornerRadius = 2.0;
    //    popTipView.sidePadding = 10.0f;
    //    popTipView.topMargin = 20.0f;
    
    popTipView.bubblePaddingX = 2;
    popTipView.bubblePaddingY = 1;
    
    popTipView.pointerSize = 3.0f;
    popTipView.textFont = [UIFont boldSystemFontOfSize:10.0];
    popTipView.hasShadow = NO;
    
    popTipView.backgroundColor = [UIColor clearColor];
    popTipView.textColor = kBlueColor;
    popTipView.borderColor = kBlueColor;
    
    popTipView.animation = CMPopTipAnimationPop;//arc4random() % 2;
    popTipView.has3DStyle = YES;//(BOOL)(arc4random() % 2);
    
    popTipView.dismissTapAnywhere = YES;
    [popTipView autoDismissAnimated:YES atTimeInterval:3.0];
    
    [popTipView presentPointingAtView:cell inView:self.view animated:YES];
    
    //    [self.visiblePopTipViews addObject:popTipView];
    //    self.currentPopTipViewTarget = sender;
}

- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView
{
    [visiblePopTipViews removeObject:popTipView];
    //    self.currentPopTipViewTarget = nil;
}

- (void)willAnimateRotationToInterfaceOrientation:(__unused UIInterfaceOrientation)toInterfaceOrientation duration:(__unused NSTimeInterval)duration
{
    for (CMPopTipView *popTipView in visiblePopTipViews) {
        id targetObject = popTipView.targetObject;
        [popTipView dismissAnimated:NO];
        
        if ([targetObject isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)targetObject;
            [popTipView presentPointingAtView:button inView:self.view animated:NO];
        }
        else {
            UIBarButtonItem *barButtonItem = (UIBarButtonItem *)targetObject;
            [popTipView presentPointingAtBarButtonItem:barButtonItem animated:NO];
        }
    }
}

- (void)dismissAllPopTipViews
{
    while ([visiblePopTipViews count] > 0) {
        CMPopTipView *popTipView = [visiblePopTipViews objectAtIndex:0];
        [popTipView dismissAnimated:YES];
        [visiblePopTipViews removeObjectAtIndex:0];
    }
}

- (void)GetEvent:(NSString *)strDate
{
    NSLog(@"Date :%@", strDate);
    
    NSDictionary *dict = @{@"UserID":appDelegate.getUserObject.user_id,//,
                           @"SearchDate":strDate};

    [[WebNetworking new] sendRequestWithUrl:makeHangURL(GetEvent)
                                 parameater:dict
                                   delegate:self
                            withRequestName:@"GetEvent"];
//    [appDelegate showActivityWithStatus:@"Getting Event..."];
    [appDelegate showActivity];
}

#pragma mark - WebNetworkingDelegate

- (void)webNetworkingSessionDidCompleteWithResult:(NSDictionary *)result forRequest:(NSString *)requesrName
{
    if([requesrName isEqualToString:@"GetEvent"])//GetMyGroup
    {
        if ([result[@"Status"] isEqualToString:@"TRUE"])
        {
            for (NSDictionary *dict in result[@"EventDetail"])
            {
                EventDetails *objEvent = [EventDetails new];
                objEvent.event_id = dict[@"event_id"];
                objEvent.event_name = dict[@"event_name"];
                objEvent.event_startTime = dict[@"event_startTime"];
                objEvent.event_isRepeating = dict[@"event_isRepeating"];
                objEvent.event_endTime = dict[@"event_endTime"];
                objEvent.event_allowToEdit = dict[@"event_allowToEdit"];
                objEvent.event_allowToInvite = dict[@"event_allowToInvite"];
                objEvent.event_creatorName = dict[@"event_creatorName"];
                objEvent.event_creatorUserName = dict[@"event_creatorUserName"];
                objEvent.event_MyStatus = dict[@"event_MyStatus"];
                objEvent.event_detail = dict[@"event_detail"];
                objEvent.event_maybe_count = dict[@"event_attend"][@"MayBe"];
                objEvent.event_yes_count = dict[@"event_attend"][@"YES"];
                objEvent.event_no_count = dict[@"event_attend"][@"NO"];
                objEvent.event_location = dict[@"event_location"];
                
                NSArray *arrTemp = dict[@"InvitedBy"];
                
                if (arrTemp.count > 0) {
                    objEvent.invitedBy = [arrTemp lastObject];
                }
                else{
                    objEvent.invitedBy = @{@"FullName":@"Facebook Synced Event",
                                           @"user_name":@"Facebook Synced Event"};
                }
                
                objEvent.Participant = [NSMutableArray new];
                
                for (NSDictionary *dict_Participant in dict[@"Participant"])
                {
                    UserObject *objUser = [UserObject new];
                    objUser.user_id = dict_Participant[@"user_id"];
                    objUser.user_name = dict_Participant[@"user_name"];
                    objUser.user_firstName = dict_Participant[@"FullName"];
                    objUser.ProfileImage = dict_Participant[@"ProfileImage"];
                    [objEvent.Participant addObject:objUser];
                }
                
                [arrEvents addObject:objEvent];
            }
            [appDelegate hideActivity];
            
            [tblView reloadData];
        }
        else
        {
            [appDelegate hideActivity];
            //            [appDelegate hideActivityWithError:result[@"Message"]];
        }
    }
    else if([requesrName isEqualToString:@"YesEvent"])//GetMyGroup
    {
        if ([result[@"Status"] isEqualToString:@"TRUE"])
        {
            [arrEvents removeAllObjects];
            [appDelegate hideActivityWithSuccess:result[@"Message"]];
            [self GetEvent:[self getStringFromDate:_dateSelected]];
        }
        else
        {
            [appDelegate hideActivityWithError:result[@"Message"]];
        }
    }
    else if([requesrName isEqualToString:@"MaybeEvent"])//GetMyGroup
    {
        if ([result[@"Status"] isEqualToString:@"TRUE"])
        {
            [arrEvents removeAllObjects];
            [appDelegate hideActivityWithSuccess:result[@"Message"]];
            [self GetEvent:[self getStringFromDate:_dateSelected]];
        }
        else
        {
            [appDelegate hideActivityWithError:result[@"Message"]];
        }
    }
    else if([requesrName isEqualToString:@"NoEvent"])//GetMyGroup
    {
        if ([result[@"Status"] isEqualToString:@"TRUE"])
        {
            [arrEvents removeAllObjects];
            [appDelegate hideActivityWithSuccess:result[@"Message"]];
            [self GetEvent:[self getStringFromDate:_dateSelected]];
        }
        else
        {
            [appDelegate hideActivityWithError:result[@"Message"]];
        }
    }

    
}

- (void)webNetworkingSessionDidFailWithError:(NSError *)error forRequest:(NSString *)requesrName
{
    [appDelegate hideActivityWithError:error.localizedDescription];
}

@end
