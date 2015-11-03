//
//  CreateEventViewController.m
//  Hang
//
//  Created by iCoderz_Ankit on 9/10/15.
//  Copyright (c) 2015 iCoderz. All rights reserved.
//

#import "CreateEventViewController.h"

#import "SizeCollectionViewCell.h"
#import "ActionSheetDatePicker.h"
#import "ShareWithViewController.h"
#import "MyCalendarViewController.h"

#define optionalViewFullHeight 109.0
#define repeatViewFullHeight 72.0

@interface CreateEventViewController ()<WebNetworkingDelegate>

@end

@implementation CreateEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"save"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(CreateEvent:)];
    
    UIView *viewLeft = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, tfName.frame.size.height)];
    tfName.leftView = viewLeft;
    tfName.leftViewMode = UITextFieldViewModeAlways;
    UIView *viewRight = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, tfName.frame.size.height)];
    tfName.rightView = viewRight;
    tfName.rightViewMode = UITextFieldViewModeAlways;
    
//    UIView *viewLeft1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, tfDetail.frame.size.height)];
//    tfDetail.leftView = viewLeft1;
//    tfDetail.leftViewMode = UITextFieldViewModeAlways;
//    UIView *viewRight1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, tfDetail.frame.size.height)];
//    tfDetail.rightView = viewRight1;
//    tfDetail.rightViewMode = UITextFieldViewModeAlways;
    
    tfName.layer.borderColor = [UIColor lightGrayColor].CGColor;
    tfName.layer.borderWidth = 1.0;
    
    tfDetail.layer.borderColor = [UIColor lightGrayColor].CGColor;
    tfDetail.layer.borderWidth = 1.0;
    
    btnStartDate.layer.borderColor = [UIColor lightGrayColor].CGColor;
    btnStartDate.layer.borderWidth = 1.0;
    btnStartDate.titleLabel.numberOfLines = 2;
    btnStartDate.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    btnEndDate.layer.borderColor = [UIColor lightGrayColor].CGColor;
    btnEndDate.layer.borderWidth = 1.0;
    btnEndDate.titleLabel.numberOfLines = 2;
    btnEndDate.titleLabel.textAlignment = NSTextAlignmentCenter;

    btnStartTime.layer.borderColor = [UIColor lightGrayColor].CGColor;
    btnStartTime.layer.borderWidth = 1.0;
    btnStartTime.titleLabel.numberOfLines = 2;
    btnStartTime.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    btnEndTime.layer.borderColor = [UIColor lightGrayColor].CGColor;
    btnEndTime.layer.borderWidth = 1.0;
    btnEndTime.titleLabel.numberOfLines = 2;
    btnEndTime.titleLabel.textAlignment = NSTextAlignmentCenter;

    btnShareFriend.layer.borderColor = [UIColor lightGrayColor].CGColor;
    btnShareFriend.layer.borderWidth = 1.0;
    btnShareFriend.titleLabel.textAlignment = NSTextAlignmentCenter;
    btnShareFriend.titleLabel.numberOfLines = 2;

    btnShareGroup.layer.borderColor = [UIColor lightGrayColor].CGColor;
    btnShareGroup.layer.borderWidth = 1.0;
    btnShareGroup.titleLabel.textAlignment = NSTextAlignmentCenter;
    btnShareGroup.titleLabel.numberOfLines = 2;
    
    btnLocation.layer.borderColor = [UIColor lightGrayColor].CGColor;
    btnLocation.layer.borderWidth = 1.0;
    btnLocation.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    btnLocation.titleLabel.numberOfLines = 2;
    btnLocation.titleLabel.minimumScaleFactor = 0.5;
    
    [self setArray];
    
    [self setBtnShareFriend];
    [self setBtnShareGroup];
    
    [tfName setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
//    [tfDetail setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    self.strLocation = @"Event Location";

    [appDelegate setBackbuttonIfNeededInController:self];
    
    lbl = [[UILabel alloc]initWithFrame:CGRectMake(10 , 0, tfDetail.frame.size.width, 52)];
    lbl.text = @"Event Notes";
    lbl.font = [UIFont fontWithName:@"HelveticaNeue-Italic" size:16.0];
    lbl.textColor = [UIColor lightGrayColor];
    lbl.backgroundColor = [UIColor clearColor];
    
    tfDetail.textContainerInset = UIEdgeInsetsMake(16, 5, 0, 0);
    [tfDetail addSubview:lbl];
    
    indexRemind = [NSIndexPath indexPathForRow:appDelegate.indexAlert inSection:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [btnLocation setTitle:self.strLocation forState:UIControlStateNormal];
    if (![self.strLocation isEqualToString:@"Event Location"]) {
        [btnLocation setTitleColor:[UIColor colorWithRed:65.0/255.0 green:125.0/255.0 blue:177.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    }
    
}

-(void)viewDidLayoutSubviews{
    sv.contentSize = CGSizeMake(sv.frame.size.width, viewInner.frame.size.height);

}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([sender isEqual:btnShareFriend]) {
    
        UINavigationController *nav = (UINavigationController*)[segue destinationViewController];
        ShareWithViewController *obj = (ShareWithViewController*)[nav.viewControllers firstObject];
        
        obj.isFriend = YES;
        obj.arraySelected = _arrFriend;
    }
    else if ([sender isEqual:btnShareGroup]){
        
        UINavigationController *nav = (UINavigationController*)[segue destinationViewController];
        ShareWithViewController *obj = (ShareWithViewController*)[nav.viewControllers firstObject];
        
        obj.isFriend = NO;
        obj.arraySelected = _arrGroup;
    }
    
}

#pragma mark -

-(void)resetAllButton{
    
    [btnStartTime setAttributedTitle:[[NSAttributedString alloc] initWithString:@"From"] forState:UIControlStateNormal];
    dateStartTime = nil;
    
    [btnEndTime setAttributedTitle:[[NSAttributedString alloc] initWithString:@"To"] forState:UIControlStateNormal];
    dateEndTime = nil;

    
    [btnStartDate setAttributedTitle:[[NSAttributedString alloc] initWithString:@"Occurs From"] forState:UIControlStateNormal];
    dateStartDate = nil;

    [btnEndDate setAttributedTitle:[[NSAttributedString alloc] initWithString:@"Until"] forState:UIControlStateNormal];
    dateEndDate = nil;

}

-(void)setArray{
    
    arrReminder = [[NSMutableArray alloc]init];

    NSString *strToAdd;
    NSRange rangeToAdd;
    NSMutableAttributedString *att;
    
    strToAdd = @"NONE";
    rangeToAdd = NSMakeRange(0, strToAdd.length);
    att = [[NSMutableAttributedString alloc] initWithString:strToAdd];
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:rangeToAdd];
    [att addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Semibold" size:14.0] range:rangeToAdd];
    [arrReminder addObject:att];
    
    strToAdd = @"ON\nTIME";
    rangeToAdd = NSMakeRange(0, strToAdd.length);
    att = [[NSMutableAttributedString alloc] initWithString:strToAdd];
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:rangeToAdd];
    [att addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Semibold" size:14.0] range:rangeToAdd];
    [arrReminder addObject:att];
    
    strToAdd = @"10\nMinutes";
    rangeToAdd = [strToAdd rangeOfString:@"10"];
    att = [[NSMutableAttributedString alloc] initWithString:strToAdd];
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:rangeToAdd];
    [att addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Semibold" size:30.0] range:rangeToAdd];
    rangeToAdd = [strToAdd rangeOfString:@"Minutes"];
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:rangeToAdd];
    [att addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Semibold" size:10.0] range:rangeToAdd];
    [arrReminder addObject:att];

    strToAdd = @"30\nMinutes";
    rangeToAdd = [strToAdd rangeOfString:@"30"];
    att = [[NSMutableAttributedString alloc] initWithString:strToAdd];
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:rangeToAdd];
    [att addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Semibold" size:30.0] range:rangeToAdd];
    rangeToAdd = [strToAdd rangeOfString:@"Minutes"];
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:rangeToAdd];
    [att addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Semibold" size:10.0] range:rangeToAdd];
    [arrReminder addObject:att];

    strToAdd = @"1\nHour";
    rangeToAdd = [strToAdd rangeOfString:@"1"];
    att = [[NSMutableAttributedString alloc] initWithString:strToAdd];
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:rangeToAdd];
    [att addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Semibold" size:30.0] range:rangeToAdd];
    rangeToAdd = [strToAdd rangeOfString:@"Hour"];
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:rangeToAdd];
    [att addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Semibold" size:10.0] range:rangeToAdd];
    [arrReminder addObject:att];

    strToAdd = @"1\nDay";
    rangeToAdd = [strToAdd rangeOfString:@"1"];
    att = [[NSMutableAttributedString alloc] initWithString:strToAdd];
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:rangeToAdd];
    [att addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Semibold" size:30.0] range:rangeToAdd];
    rangeToAdd = [strToAdd rangeOfString:@"Day"];
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:rangeToAdd];
    [att addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Semibold" size:10.0] range:rangeToAdd];
    [arrReminder addObject:att];

    //*****
    arrRepeat = [[NSMutableArray alloc]init];
    
    strToAdd = @"NONE";
    rangeToAdd = NSMakeRange(0, strToAdd.length);
    att = [[NSMutableAttributedString alloc] initWithString:strToAdd];
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:rangeToAdd];
    [att addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Semibold" size:14.0] range:rangeToAdd];
    [arrRepeat addObject:att];

    strToAdd = @"Daily";
    rangeToAdd = NSMakeRange(0, strToAdd.length);
    att = [[NSMutableAttributedString alloc] initWithString:strToAdd];
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:rangeToAdd];
    [att addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Semibold" size:14.0] range:rangeToAdd];
    [arrRepeat addObject:att];

    strToAdd = @"Weekly";
    rangeToAdd = NSMakeRange(0, strToAdd.length);
    att = [[NSMutableAttributedString alloc] initWithString:strToAdd];
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:rangeToAdd];
    [att addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Semibold" size:14.0] range:rangeToAdd];
    [arrRepeat addObject:att];

    strToAdd = @"Bi\nWeekly";
    rangeToAdd = NSMakeRange(0, strToAdd.length);
    att = [[NSMutableAttributedString alloc] initWithString:strToAdd];
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:rangeToAdd];
    [att addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Semibold" size:14.0] range:rangeToAdd];
    [arrRepeat addObject:att];

    strToAdd = @"Monthly";
    rangeToAdd = NSMakeRange(0, strToAdd.length);
    att = [[NSMutableAttributedString alloc] initWithString:strToAdd];
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:rangeToAdd];
    [att addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Semibold" size:14.0] range:rangeToAdd];
    [arrRepeat addObject:att];

//    strToAdd = @"Yearly";
//    rangeToAdd = NSMakeRange(0, strToAdd.length);
//    att = [[NSMutableAttributedString alloc] initWithString:strToAdd];
//    [att addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:rangeToAdd];
//    [att addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Semibold" size:14.0] range:rangeToAdd];
//    [arrRepeat addObject:att];
    
    //*****
    arrWeekDays = [[NSMutableArray alloc]init];
    
    strToAdd = @"SUN";
    rangeToAdd = NSMakeRange(0, strToAdd.length);
    att = [[NSMutableAttributedString alloc] initWithString:strToAdd];
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:rangeToAdd];
    [att addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Semibold" size:14.0] range:rangeToAdd];
    [arrWeekDays addObject:att];
    
    strToAdd = @"MON";
    rangeToAdd = NSMakeRange(0, strToAdd.length);
    att = [[NSMutableAttributedString alloc] initWithString:strToAdd];
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:rangeToAdd];
    [att addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Semibold" size:14.0] range:rangeToAdd];
    [arrWeekDays addObject:att];
    
    strToAdd = @"TUE";
    rangeToAdd = NSMakeRange(0, strToAdd.length);
    att = [[NSMutableAttributedString alloc] initWithString:strToAdd];
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:rangeToAdd];
    [att addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Semibold" size:14.0] range:rangeToAdd];
    [arrWeekDays addObject:att];
    
    strToAdd = @"WED";
    rangeToAdd = NSMakeRange(0, strToAdd.length);
    att = [[NSMutableAttributedString alloc] initWithString:strToAdd];
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:rangeToAdd];
    [att addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Semibold" size:14.0] range:rangeToAdd];
    [arrWeekDays addObject:att];
    
    strToAdd = @"THU";
    rangeToAdd = NSMakeRange(0, strToAdd.length);
    att = [[NSMutableAttributedString alloc] initWithString:strToAdd];
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:rangeToAdd];
    [att addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Semibold" size:14.0] range:rangeToAdd];
    [arrWeekDays addObject:att];
    
    strToAdd = @"FRI";
    rangeToAdd = NSMakeRange(0, strToAdd.length);
    att = [[NSMutableAttributedString alloc] initWithString:strToAdd];
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:rangeToAdd];
    [att addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Semibold" size:14.0] range:rangeToAdd];
    [arrWeekDays addObject:att];
    
    strToAdd = @"SAT";
    rangeToAdd = NSMakeRange(0, strToAdd.length);
    att = [[NSMutableAttributedString alloc] initWithString:strToAdd];
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:rangeToAdd];
    [att addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Semibold" size:14.0] range:rangeToAdd];
    [arrWeekDays addObject:att];

    //*****
    arrMonthDay = [[NSMutableArray alloc]init];
    
    for (int i = 1; i <= 31; i++) {
        
        strToAdd = [NSString stringWithFormat:@"%d",i];
        rangeToAdd = NSMakeRange(0, strToAdd.length);
        att = [[NSMutableAttributedString alloc] initWithString:strToAdd];
        [att addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:rangeToAdd];
        [att addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Semibold" size:30.0] range:rangeToAdd];
        [arrMonthDay addObject:att];
        
    }
    
    //*****
    
    arrSelectedWeekDays = [NSMutableArray new];
    
    self.arrFriend = [[NSMutableArray alloc]init];
    self.arrGroup = [[NSMutableArray alloc]init];
}

-(void)setBtnShareFriend{
    NSString *temp = @"Share with\nFriends";
    
    NSRange rangeStart = NSMakeRange(0 , [@"Share with" length]);
    NSRange rangeEnd = NSMakeRange([@"Share with" length] , [@"\nFriends" length]);
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:temp];
    
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:158.0/255.0 green:154.0/255.0 blue:154.0/255.0 alpha:1.0] range:rangeStart];
    [att addAttribute:NSFontAttributeName value:[UIFont fontWithName:kFontOpenSans size:12.0] range:rangeStart];
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:65.0/255.0 green:125.0/255.0 blue:177.0/255.0 alpha:1.0] range:rangeEnd];
    [att addAttribute:NSFontAttributeName value:[UIFont fontWithName:kFontOpenSans size:18.0] range:rangeEnd];
    
    [btnShareFriend setAttributedTitle:att forState:UIControlStateNormal];

}

-(void)setBtnShareGroup{
    NSString *temp = @"Share with\nGroups";
    
    NSRange rangeStart = NSMakeRange(0 , [@"Share with" length]);
    NSRange rangeEnd = NSMakeRange([@"Share with" length] , [@"\nGroups" length]);
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:temp];
    
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:158.0/255.0 green:154.0/255.0 blue:154.0/255.0 alpha:1.0] range:rangeStart];
    [att addAttribute:NSFontAttributeName value:[UIFont fontWithName:kFontOpenSans size:12.0] range:rangeStart];
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:65.0/255.0 green:125.0/255.0 blue:177.0/255.0 alpha:1.0] range:rangeEnd];
    [att addAttribute:NSFontAttributeName value:[UIFont fontWithName:kFontOpenSans size:18.0] range:rangeEnd];
    
    [btnShareGroup setAttributedTitle:att forState:UIControlStateNormal];
    
}

-(IBAction)CreateEvent:(id)sender{
    
    if (tfName.text.length == 0) {
//        [appDelegate hideActivityWithInfo:@"please enter event title"];
        
        [UIView animateWithDuration:0.2 animations:^{
            tfName.transform = CGAffineTransformMakeScale(1.05, 1.05);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                tfName.transform = CGAffineTransformMakeScale(1.0, 1.0);
            }completion:^(BOOL finished) {
                [tfName becomeFirstResponder];
            }];
        }];

    }
    else if([self.strLocation isEqualToString:@"Event Location"]){
//        [appDelegate hideActivityWithInfo:@"please select event location"];
        [UIView animateWithDuration:0.2 animations:^{
            btnLocation.transform = CGAffineTransformMakeScale(1.05, 1.05);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                btnLocation.transform = CGAffineTransformMakeScale(1.0, 1.0);
            }completion:^(BOOL finished) {
                
            }];
        }];

    }
    else if(!dateStartTime){
//        [appDelegate hideActivityWithInfo:@"please select start time"];
        [UIView animateWithDuration:0.2 animations:^{
            btnStartTime.transform = CGAffineTransformMakeScale(1.05, 1.05);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                btnStartTime.transform = CGAffineTransformMakeScale(1.0, 1.0);
            }completion:^(BOOL finished) {
                
            }];
        }];

    }
    else if(!dateEndTime){
//        [appDelegate hideActivityWithInfo:@"please select end time"];
        [UIView animateWithDuration:0.2 animations:^{
            btnEndTime.transform = CGAffineTransformMakeScale(1.05, 1.05);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                btnEndTime.transform = CGAffineTransformMakeScale(1.0, 1.0);
            }completion:^(BOOL finished) {
                
            }];
        }];
    }
    else if(!dateStartDate && (indexRepeat.row == 1 || indexRepeat.row == 2 || indexRepeat.row == 3 || indexRepeat.row == 4)){
        //        [appDelegate hideActivityWithInfo:@"please select start date"];
        [UIView animateWithDuration:0.2 animations:^{
            btnStartDate.transform = CGAffineTransformMakeScale(1.05, 1.05);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                btnStartDate.transform = CGAffineTransformMakeScale(1.0, 1.0);
            }completion:^(BOOL finished) {
                
            }];
        }];
        
    }
    else if(!dateEndDate && (indexRepeat.row == 1 || indexRepeat.row == 2 || indexRepeat.row == 3 || indexRepeat.row == 4)){
        //        [appDelegate hideActivityWithInfo:@"please select end date"];
        [UIView animateWithDuration:0.2 animations:^{
            btnEndDate.transform = CGAffineTransformMakeScale(1.05, 1.05);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                btnEndDate.transform = CGAffineTransformMakeScale(1.0, 1.0);
            }completion:^(BOOL finished) {
                
            }];
        }];
    }
    else if ((indexRepeat.row == 2 || indexRepeat.row == 3) && arrSelectedWeekDays.count == 0){
        [UIView animateWithDuration:0.2 animations:^{
            cvOptional.transform = CGAffineTransformMakeScale(1.05, 1.05);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                cvOptional.transform = CGAffineTransformMakeScale(1.0, 1.0);
            }completion:^(BOOL finished) {
                
            }];
        }];

    }
//    else if(tfDetail.text.length == 0){
////        [appDelegate hideActivityWithInfo:@"Please enter event notes."];
//        [UIView animateWithDuration:0.2 animations:^{
//            tfDetail.transform = CGAffineTransformMakeScale(1.05, 1.05);
//        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:0.2 animations:^{
//                tfDetail.transform = CGAffineTransformMakeScale(1.0, 1.0);
//            }completion:^(BOOL finished) {
//                [tfDetail becomeFirstResponder];
//            }];
//        }];
//    }
    else{
        
        NSString *strStartTime,*strEndTime,*strStartDate,*strEndDate;
        
        if (indexRepeat.row == 0)//None
        {
            strStartTime = [self getFulldate:dateStartTime];
            strEndTime = [self getFulldate:dateEndTime];
            strStartDate = @"";
            strEndDate = @"";
        }
        else if (indexRepeat.row == 1)//Daily
        {
            strStartTime = [NSString stringWithFormat:@"%@ %@",[self getOnlyDate:dateStartDate],[self getOnlyTime:dateStartTime]];
            strEndTime = [NSString stringWithFormat:@"%@ %@",[self getOnlyDate:dateEndDate],[self getOnlyTime:dateEndTime]];
            strStartDate = @"";
            strEndDate = @"";
        }
        else if (indexRepeat.row == 2)//Weekly
        {
            strStartTime = [NSString stringWithFormat:@"%@ %@",[self getOnlyDate:dateStartDate],[self getOnlyTime:dateStartTime]];
            strEndTime = [NSString stringWithFormat:@"%@ %@",[self getOnlyDate:dateEndDate],[self getOnlyTime:dateEndTime]];
            strStartDate = @"";
            strEndDate = @"";
        }
        else if (indexRepeat.row == 3)//Biweekly
        {
            strStartTime = [NSString stringWithFormat:@"%@ %@",[self getOnlyDate:dateStartDate],[self getOnlyTime:dateStartTime]];
            strEndTime = [NSString stringWithFormat:@"%@ %@",[self getOnlyDate:dateEndDate],[self getOnlyTime:dateEndTime]];
            strStartDate = @"";
            strEndDate = @"";
        }
        else if (indexRepeat.row == 4)
        {
            strStartTime = [self getFulldate:dateStartTime];
            strEndTime = [self getFulldate:dateEndTime];
            strStartDate = [self getOnlyDate:dateStartDate];
            strEndDate = [self getOnlyDate:dateEndDate];
        }
        else if (indexRepeat.row == 5)
        {
            strStartTime = @"";
            strEndTime = @"";
            strStartDate = @"";
            strEndDate = @"";
        }
        
        NSDictionary *dict = @{@"event_name":tfName.text.emojiEncode,
                               @"event_detail":tfDetail.text.emojiEncode,
                               @"event_location":btnLocation.titleLabel.text.emojiEncode,
                               @"event_latitiude":[NSString stringWithFormat:@"%f",self.cord.latitude].emojiEncode,
                               @"event_longitude":[NSString stringWithFormat:@"%f",self.cord.longitude].emojiEncode,
                               @"event_creatorID":appDelegate.getUserObject.user_id.emojiEncode,
                               @"event_organizationID":@"".emojiEncode,
                               @"event_isPrivate":@"0",
                               @"event_startTime":strStartTime.emojiEncode,
                               @"event_endTime":strEndTime.emojiEncode,
                               @"event_startmonthdate":strStartDate.emojiEncode,
                               @"event_endmonthdate":strEndDate.emojiEncode,
                               @"event_isRepeating":[NSString stringWithFormat:@"%ld",(long)indexRepeat.row],
                               @"event_repeatCount":@"0".emojiEncode,
                               @"event_reminder":[self getReminderTimeInSecond].emojiEncode,
                               @"event_allowToEdit":swEdit.isOn?@"1":@"0",
                               @"event_allowToInvite":swInvite.isOn?@"1":@"0".emojiEncode,
                               @"event_allowToshare":@"0",
                               @"event_isActive":@"1",
                               @"InvitedFriends":self.arrFriend,
                               @"InvitedGroup":self.arrGroup,
                               @"event_days":[self getEventDay].emojiEncode};
        
        [[WebNetworking new] sendRequestWithUrl:makeHangURL(CreateEvent)
                                     parameater:dict
                                       delegate:self
                                withRequestName:@"CreateEvent"];
        [appDelegate showActivityWithStatus:@"Creating Event..."];
        
    }
}

-(NSString*)getReminderTimeInSecond{
    
    NSString *strReminder;
    
    switch (indexRemind.row) {
        case 0:
            strReminder = @"";
            break;
        case 1:
            strReminder = @"0";
            break;
        case 2:
            strReminder = @"600";
            break;
        case 3:
            strReminder = @"1800";
            break;
        case 4:
            strReminder = @"3600";
            break;
        case 5:
            strReminder = @"86400";
            break;
        default:
            strReminder = @"0";
            break;
    }
    return strReminder;
}

-(NSString*)getEventDay{
    
    if (indexRepeat.row == 2 || indexRepeat.row == 3)//Weekly and Biweekly
    {
        NSMutableArray *arr1 = [NSMutableArray new];
        
        for (NSIndexPath *index in arrSelectedWeekDays) {
            [arr1 addObject:[NSString stringWithFormat:@"%ld",(long)index.row]];
        }
        
        return [arr1 componentsJoinedByString:@","];
    }
    else{
        return @"";
    }
}

-(NSString*)getFulldate:(NSDate*)date{
    
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    return [df stringFromDate:date];
}

-(NSString*)getOnlyDate:(NSDate*)date{
    
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    df.dateFormat = @"yyyy-MM-dd";
    
    return [df stringFromDate:date];
}

-(NSString*)getOnlyTime:(NSDate*)date{
    
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    df.dateFormat = @"HH:mm:ss";
    
    return [df stringFromDate:date];
}


-(IBAction)StartTime:(id)sender{
    
    [self.view endEditing:YES];
    
    NSUInteger mode;
    
    if (indexRepeat.row == 0) {
        mode = UIDatePickerModeDateAndTime;
    }
    else if (indexRepeat.row == 1){
        mode = UIDatePickerModeTime;
    }
    else if (indexRepeat.row == 2){
        mode = UIDatePickerModeTime;
    }
    else if (indexRepeat.row == 3){
        mode = UIDatePickerModeTime;
    }
    else if (indexRepeat.row == 4){
        mode = UIDatePickerModeDateAndTime;
    }
    
    
    ActionSheetDatePicker *datePicker = [[ActionSheetDatePicker alloc]
                                         initWithTitle:@"From"
                                         datePickerMode:mode
                                         selectedDate:dateStartTime?dateStartTime:[NSDate date]
                                         target:self
                                         action:@selector(startTimeWasSelected:element:)
                                         origin:btnStartTime
                                         cancelAction:nil];
    
    if (indexRepeat.row == 0) {
        datePicker.minimumDate = [NSDate date];
    }
    else if (indexRepeat.row == 1){
    }
    else if (indexRepeat.row == 2){
    }
    else if (indexRepeat.row == 3){
    }
    else if (indexRepeat.row == 4){
        datePicker.minimumDate = [NSDate date];
    }

    [datePicker showActionSheetPicker];
    
}

- (void)startTimeWasSelected:(NSDate *)selectedDate element:(id)element{
    
    dateStartTime = selectedDate;
    
    
    if (indexRepeat.row == 0 | indexRepeat.row == 4) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EEE MMM dd"];
        NSString *strTop = [[dateFormatter stringFromDate:dateStartTime] uppercaseString];
        [dateFormatter setDateFormat:@"hh:mm a"];
        NSString *strBotttom = [[dateFormatter stringFromDate:dateStartTime] uppercaseString];
        
        
        NSString *temp = [NSString stringWithFormat:@"%@\n%@",strTop,strBotttom];
        NSRange rangeStart = NSMakeRange(0 , [strTop length]);
        NSRange rangeEnd = NSMakeRange([strTop length]+1 , [strBotttom length]);
        
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:temp];
        
        [att addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:rangeStart];
        [att addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Medium" size:11.0] range:rangeStart];
        [att addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:65.0/255.0 green:125.0/255.0 blue:177.0/255.0 alpha:1.0] range:rangeEnd];
        [att addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Medium" size:18.0] range:rangeEnd];
        
        [btnStartTime setAttributedTitle:att forState:UIControlStateNormal];
        
        if (indexRepeat.row == 4) {
            [self startDateWasSelected:dateStartTime element:btnStartDate];
        }
    
    }
    else if (indexRepeat.row == 1 | indexRepeat.row == 2 | indexRepeat.row == 3){
    
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"hh:mm a"];
        
        NSString *strTop = [[dateFormatter stringFromDate:dateStartTime] uppercaseString];
        NSRange rangeStart = NSMakeRange(0 , [strTop length]);
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:strTop];
        
        [att addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:65.0/255.0 green:125.0/255.0 blue:177.0/255.0 alpha:1.0] range:rangeStart];
        [att addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Medium" size:18.0] range:rangeStart];
        
        [btnStartTime setAttributedTitle:att forState:UIControlStateNormal];
    }
    
}


-(IBAction)EndTime:(id)sender{
    
    [self.view endEditing:YES];
    
    if (!dateStartTime)//If start time is not selected before end time
    {
       
        [UIView animateWithDuration:0.2 animations:^{
            btnStartTime.transform = CGAffineTransformMakeScale(1.05, 1.05);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                btnStartTime.transform = CGAffineTransformMakeScale(1.0, 1.0);
            }completion:^(BOOL finished) {

            }];
        }];
        
        return ;
    }
    
    NSUInteger mode;
    
    if (indexRepeat.row == 0) {
        mode = UIDatePickerModeDateAndTime;
    }
    else if (indexRepeat.row == 1){
        mode = UIDatePickerModeTime;
    }
    else if (indexRepeat.row == 2){
        mode = UIDatePickerModeTime;
    }
    else if (indexRepeat.row == 3){
        mode = UIDatePickerModeTime;
    }
    else if (indexRepeat.row == 4){
        mode = UIDatePickerModeDateAndTime;
    }
    
    ActionSheetDatePicker *datePicker = [[ActionSheetDatePicker alloc]
                                         initWithTitle:@"To"
                                         datePickerMode:mode
                                         selectedDate:dateEndTime?dateEndTime:[NSDate date]
                                         target:self
                                         action:@selector(endTimeWasSelected:element:)
                                         origin:btnEndTime
                                         cancelAction:nil];
    datePicker.minimumDate = dateStartTime;
    
    if (indexRepeat.row == 4) {
        datePicker.maximumDate = [dateStartTime dateByAddingTimeInterval:28*24*60*60];
    }
    
    [datePicker showActionSheetPicker];

    
}

- (void)endTimeWasSelected:(NSDate *)selectedDate element:(id)element{
    
    dateEndTime = selectedDate;
    
    if (indexRepeat.row == 0 | indexRepeat.row == 4) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EEE MMM dd"];
        NSString *strTop = [[dateFormatter stringFromDate:dateEndTime] uppercaseString];
        [dateFormatter setDateFormat:@"hh:mm a"];
        NSString *strBotttom = [[dateFormatter stringFromDate:dateEndTime] uppercaseString];
        
        
        NSString *temp = [NSString stringWithFormat:@"%@\n%@",strTop,strBotttom];
        NSRange rangeStart = NSMakeRange(0 , [strTop length]);
        NSRange rangeEnd = NSMakeRange([strTop length]+1 , [strBotttom length]);
        
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:temp];
        
        [att addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:rangeStart];
        [att addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Medium" size:11.0] range:rangeStart];
        [att addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:65.0/255.0 green:125.0/255.0 blue:177.0/255.0 alpha:1.0] range:rangeEnd];
        [att addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Medium" size:18.0] range:rangeEnd];
        
        [btnEndTime setAttributedTitle:att forState:UIControlStateNormal];
        
    }
    else if (indexRepeat.row == 1 | indexRepeat.row == 2 | indexRepeat.row == 3){
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"hh:mm a"];
        
        NSString *strTop = [[dateFormatter stringFromDate:dateEndTime] uppercaseString];
        NSRange rangeStart = NSMakeRange(0 , [strTop length]);
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:strTop];
        
        [att addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:65.0/255.0 green:125.0/255.0 blue:177.0/255.0 alpha:1.0] range:rangeStart];
        [att addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Medium" size:18.0] range:rangeStart];
        
        [btnEndTime setAttributedTitle:att forState:UIControlStateNormal];
        
    }
}

-(IBAction)StartDate:(id)sender{
    
    if (!dateStartTime)//If start time is not selected before end time
    {
        
        [UIView animateWithDuration:0.2 animations:^{
            btnStartTime.transform = CGAffineTransformMakeScale(1.05, 1.05);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                btnStartTime.transform = CGAffineTransformMakeScale(1.0, 1.0);
            }completion:^(BOOL finished) {
                
            }];
        }];
        
        return ;
    }
    
    if (indexRepeat.row == 4) {
        return;
    }
    
    [self.view endEditing:YES];
    
    ActionSheetDatePicker *datePicker = [[ActionSheetDatePicker alloc]
                                         initWithTitle:@"Occurs From"
                                         datePickerMode:UIDatePickerModeDate
                                         selectedDate:dateStartDate?dateStartDate:[NSDate date]
                                         target:self
                                         action:@selector(startDateWasSelected:element:)
                                         origin:btnStartDate
                                         cancelAction:nil];

    datePicker.minimumDate = (indexRepeat.row == 4)?dateStartTime:[NSDate date];
    [datePicker showActionSheetPicker];
    
}

- (void)startDateWasSelected:(NSDate *)selectedDate element:(id)element{
    
    dateStartDate = selectedDate;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE"];
    NSString *strTop = [[dateFormatter stringFromDate:dateStartDate] uppercaseString];
    [dateFormatter setDateFormat:@"dd MMM yy"];
    NSString *strBotttom = [[dateFormatter stringFromDate:dateStartDate] uppercaseString];
    
    
    NSString *temp = [NSString stringWithFormat:@"%@\n%@",strTop,strBotttom];
    NSRange rangeStart = NSMakeRange(0 , [strTop length]);
    NSRange rangeEnd = NSMakeRange([strTop length]+1 , [strBotttom length]);
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:temp];
    
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:rangeStart];
    [att addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Medium" size:11.0] range:rangeStart];
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:65.0/255.0 green:125.0/255.0 blue:177.0/255.0 alpha:1.0] range:rangeEnd];
    [att addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Medium" size:18.0] range:rangeEnd];
    
    [btnStartDate setAttributedTitle:att forState:UIControlStateNormal];
    
}


-(IBAction)EndDate:(id)sender{
    
    if (!dateStartTime)//If start time is not selected before end time
    {
        
        [UIView animateWithDuration:0.2 animations:^{
            btnStartTime.transform = CGAffineTransformMakeScale(1.05, 1.05);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                btnStartTime.transform = CGAffineTransformMakeScale(1.0, 1.0);
            }completion:^(BOOL finished) {
                
            }];
        }];
        
        return ;
    }
    else if (!dateEndTime)//If start time is not selected before end time
    {
        
        [UIView animateWithDuration:0.2 animations:^{
            btnEndTime.transform = CGAffineTransformMakeScale(1.05, 1.05);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                btnEndTime.transform = CGAffineTransformMakeScale(1.0, 1.0);
            }completion:^(BOOL finished) {
                
            }];
        }];
        
        return ;
    }
    else if (!dateStartDate)//If start time is not selected before end time
    {
        
        [UIView animateWithDuration:0.2 animations:^{
            btnStartDate.transform = CGAffineTransformMakeScale(1.05, 1.05);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                btnStartDate.transform = CGAffineTransformMakeScale(1.0, 1.0);
            }completion:^(BOOL finished) {
                
            }];
        }];
        
        return ;
    }

    [self.view endEditing:YES];
    
    ActionSheetDatePicker *datePicker = [[ActionSheetDatePicker alloc]
                                         initWithTitle:@"Until"
                                         datePickerMode:UIDatePickerModeDate
                                         selectedDate:dateEndDate?dateEndDate:[NSDate date]
                                         target:self
                                         action:@selector(endDateWasSelected:element:)
                                         origin:btnEndDate
                                         cancelAction:nil];
    datePicker.minimumDate = (indexRepeat.row == 4)?dateEndTime:dateStartDate;
    [datePicker showActionSheetPicker];

}

- (void)endDateWasSelected:(NSDate *)selectedDate element:(id)element{
    
    dateEndDate = selectedDate;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE"];
    NSString *strTop = [[dateFormatter stringFromDate:dateEndDate] uppercaseString];
    [dateFormatter setDateFormat:@"dd MMM yy"];
    NSString *strBotttom = [[dateFormatter stringFromDate:dateEndDate] uppercaseString];
    
    NSString *temp = [NSString stringWithFormat:@"%@\n%@",strTop,strBotttom];
    NSRange rangeStart = NSMakeRange(0 , [strTop length]);
    NSRange rangeEnd = NSMakeRange([strTop length]+1 , [strBotttom length]);
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:temp];
    
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:rangeStart];
    [att addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Medium" size:11.0] range:rangeStart];
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:65.0/255.0 green:125.0/255.0 blue:177.0/255.0 alpha:1.0] range:rangeEnd];
    [att addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Medium" size:18.0] range:rangeEnd];
    
    [btnEndDate setAttributedTitle:att forState:UIControlStateNormal];
    
}


-(void)setSelectedDateTocenter:(NSIndexPath*)indexPath{
    [cvOptional scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

#pragma mark - CollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (collectionView.tag == 101){
        return arrReminder.count;
    }
    else if (collectionView.tag == 201){
        return arrRepeat.count;
    }
    else if (collectionView.tag == 301){
        
        if (indexRepeat.row == 2 || indexRepeat.row == 3) //Weekly or BiWeekly Repeat
        {
            return arrWeekDays.count;
        }
        else if (indexRepeat.row == 4) //Monthly Repeat
        {
            return arrMonthDay.count;
        }
        else
        {
            return 0;
        }
    }
    else
        return 0;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SizeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        
    cell.btn.titleLabel.numberOfLines = 2;
    cell.btn.userInteractionEnabled = NO;
    cell.btn.layer.borderWidth = 1.0;
    cell.btn.layer.masksToBounds = YES;
    cell.btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    if (collectionView.tag == 101) {
        
        [cell.btn setAttributedTitle:arrReminder[indexPath.row] forState:UIControlStateNormal];
        
        if (indexPath.row == indexRemind.row) {
            cell.btn.selected = YES;
            cell.btn.backgroundColor = [UIColor colorWithRed:252.0/255.0 green:102.0/255.0 blue:33.0/255.0 alpha:1.0];
            cell.btn.layer.borderColor = [UIColor whiteColor].CGColor;
            
        }
        else{
            cell.btn.selected = NO;
            cell.btn.backgroundColor = [UIColor colorWithRed:216.0/255.0 green:216.0/255.0 blue:216.0/255.0 alpha:0.6];
            cell.btn.layer.borderColor = [UIColor colorWithRed:151.0/255.0 green:151.0/255.0 blue:151.0/255.0 alpha:1.0].CGColor;

        }
        
    }
    else if (collectionView.tag == 201){
        
        [cell.btn setAttributedTitle:arrRepeat[indexPath.row] forState:UIControlStateNormal];
        
        if (indexPath.row == indexRepeat.row) {
            cell.btn.selected = YES;
            cell.btn.backgroundColor = [UIColor colorWithRed:252.0/255.0 green:102.0/255.0 blue:33.0/255.0 alpha:1.0];
            cell.btn.layer.borderColor = [UIColor whiteColor].CGColor;

        }
        else{
            cell.btn.selected = NO;
            cell.btn.backgroundColor = [UIColor colorWithRed:216.0/255.0 green:216.0/255.0 blue:216.0/255.0 alpha:0.6];
            cell.btn.layer.borderColor = [UIColor colorWithRed:151.0/255.0 green:151.0/255.0 blue:151.0/255.0 alpha:1.0].CGColor;

        }
        
    }
    else if (collectionView.tag == 301){
        
        if (indexRepeat.row == 2 || indexRepeat.row == 3)//Weekly or BiWeekly Repeat
        {
            [cell.btn setAttributedTitle:arrWeekDays[indexPath.row] forState:UIControlStateNormal];
            
            if ([arrSelectedWeekDays containsObject:indexPath]) {
                cell.btn.selected = YES;
                cell.btn.backgroundColor = [UIColor colorWithRed:252.0/255.0 green:102.0/255.0 blue:33.0/255.0 alpha:1.0];
                cell.btn.layer.borderColor = [UIColor whiteColor].CGColor;
                
            }
            else{
                cell.btn.selected = NO;
                cell.btn.backgroundColor = [UIColor colorWithRed:216.0/255.0 green:216.0/255.0 blue:216.0/255.0 alpha:0.6];
                cell.btn.layer.borderColor = [UIColor colorWithRed:151.0/255.0 green:151.0/255.0 blue:151.0/255.0 alpha:1.0].CGColor;
                
            }

        }
        else if (indexRepeat.row == 4) //Monthly Repeat
        {
            [cell.btn setAttributedTitle:arrMonthDay[indexPath.row] forState:UIControlStateNormal];
            
            if (indexPath.row == indexMonthDay.row) {
                cell.btn.selected = YES;
                cell.btn.backgroundColor = [UIColor colorWithRed:252.0/255.0 green:102.0/255.0 blue:33.0/255.0 alpha:1.0];
                cell.btn.layer.borderColor = [UIColor whiteColor].CGColor;
                
            }
            else{
                cell.btn.selected = NO;
                cell.btn.backgroundColor = [UIColor colorWithRed:216.0/255.0 green:216.0/255.0 blue:216.0/255.0 alpha:0.6];
                cell.btn.layer.borderColor = [UIColor colorWithRed:151.0/255.0 green:151.0/255.0 blue:151.0/255.0 alpha:1.0].CGColor;
                
            }
        }
        else
        {
            return nil;
        }
    }
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 101)//Reminder
    {
        indexRemind = indexPath;
    }
    else if (collectionView.tag == 201)//Repeat
    {
        indexRepeat = indexPath;
        [self resetAllButton];
        
        if (indexRepeat.row == 0) {
            constrainOptionalHeight.constant = 0.0;
            constrainRepeatHeight.constant = 0.0;
        }
        else if (indexRepeat.row == 1) {
            constrainOptionalHeight.constant = 0.0;
            constrainRepeatHeight.constant = repeatViewFullHeight;
            
            dateStartDate = [NSDate date];
            [self startDateWasSelected:dateStartDate element:nil];
            
            [cvOptional reloadData];

        }
        else if (indexRepeat.row == 2) { //Weekly
            constrainOptionalHeight.constant = optionalViewFullHeight;
            constrainRepeatHeight.constant = repeatViewFullHeight;
            
            lblOptionView.text = @"Select days to repeat weekly";
            
            dateStartDate = [NSDate date];
            [self startDateWasSelected:dateStartDate element:nil];
            
            [cvOptional reloadData];
            [self setSelectedDateTocenter:[NSIndexPath indexPathForRow:0 inSection:0]];

        }
        else if (indexRepeat.row == 3) { //BiWeekly
            constrainOptionalHeight.constant = optionalViewFullHeight;
            constrainRepeatHeight.constant = repeatViewFullHeight;

            dateStartDate = [NSDate date];
            [self startDateWasSelected:dateStartDate element:nil];
            
            lblOptionView.text = @"Select days to repeat biweekly";
            
            [cvOptional reloadData];
            [self setSelectedDateTocenter:[NSIndexPath indexPathForRow:0 inSection:0]];
        }
        else if (indexRepeat.row == 4) { //Monthly
            constrainOptionalHeight.constant = 0.0;
            constrainRepeatHeight.constant = repeatViewFullHeight;

            lblOptionView.text = @"Select date to repeat monthly";
            
//            [cvOptional reloadData];
//            [self setSelectedDateTocenter:indexMonthDay];
        }
        else{
            constrainOptionalHeight.constant = 0.0;
            constrainRepeatHeight.constant = 0.0;
            
            [cvOptional reloadData];
        }
        
        [sv layoutIfNeeded];
//        viewOptional.hidden = (constrainOptionalHeight.constant==0.0)?YES:NO;
        
    }
    else if (collectionView.tag == 301)//Optional
    {
        
        if (indexRepeat.row == 2 || indexRepeat.row == 3)//Weekly or BiWeekly Repeat
        {
            if ([arrSelectedWeekDays containsObject:indexPath]) {
                [arrSelectedWeekDays removeObject:indexPath];
            }else{
                [arrSelectedWeekDays addObject:indexPath];
            }
        }
        else if (indexRepeat.row == 4) //Monthly Repeat
        {
            indexMonthDay = indexPath;
        }
        else
        {
            
        }
        
    }
    
    [collectionView reloadData];
}

#pragma mark - UITextView Delegate

- (void)textViewDidChange:(UITextView *)textView{
    
    lbl.hidden = (textView.text.length == 0)?NO:YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    CGFloat height = keyboardHeight;
    CGFloat top = MAX(0, textView.frame.origin.y - sv.contentOffset.y) + (textView.frame.size.height+10);
    CGFloat remainingSpaceHeight = self.view.frame.size.height - height;
    
    if (top > remainingSpaceHeight) {
        
        [UIView animateWithDuration:0.25
                              delay:0.0
                            options:(7 << 16)
                         animations:^{
                             CGFloat moveSpace = top - remainingSpaceHeight;
                             [sv setContentOffset:CGPointMake(sv.contentOffset.x, sv.contentOffset.y + moveSpace)];
                         }completion:^(BOOL finished) {
                         }];
    }
    else if (top < 64 + 20 + textView.frame.size.height){
        
        [UIView animateWithDuration:0.25
                              delay:0.0
                            options:(7 << 16)
                         animations:^{
                             [sv setContentOffset:CGPointMake(sv.contentOffset.x, 0)];
                         }completion:^(BOOL finished) {
                         }];
        
    }
    
    
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField*)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    CGFloat height = keyboardHeight;
    CGFloat top = MAX(0, textField.frame.origin.y - sv.contentOffset.y) + (textField.frame.size.height+10);
    CGFloat remainingSpaceHeight = self.view.frame.size.height - height;
    
    if (top > remainingSpaceHeight) {
        
        [UIView animateWithDuration:0.25
                              delay:0.0
                            options:(7 << 16)
                         animations:^{
                             CGFloat moveSpace = top - remainingSpaceHeight;
                             [sv setContentOffset:CGPointMake(sv.contentOffset.x, sv.contentOffset.y + moveSpace)];
                         }completion:^(BOOL finished) {
                         }];
    }
    else if (top < 64 + 20 + textField.frame.size.height){
        
        [UIView animateWithDuration:0.25
                              delay:0.0
                            options:(7 << 16)
                         animations:^{
                             [sv setContentOffset:CGPointMake(sv.contentOffset.x, 0)];
                         }completion:^(BOOL finished) {
                         }];
        
    }

    
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}

#pragma mark - WebNetworking Delegate

- (void)webNetworkingSessionDidCompleteWithResult:(NSDictionary*)result forRequest:(NSString*)requesrName{
    
    if ([requesrName isEqualToString:@"CreateEvent"]) {
        
        if ([result[@"Status"] isEqualToString:@"TRUE"]) {
            
            [appDelegate hideActivityWithSuccess:@"Event created succesfully."];
            
            MyCalendarViewController *obj = (MyCalendarViewController*)previousViewController;
            
            NSDate *dR;
            
            if (indexRepeat.row == 0) {
                dR =  dateStartTime;
            }
            else{
                dR = dateStartDate;
            }
            
            obj.dateSelected = dR;
            [obj.calendarManager setContentView:obj.calendarContentView];
            [obj.calendarManager setDate:dR];
            
            NSDateFormatter *dtFormatter = [NSDateFormatter new];
            dtFormatter.dateFormat = @"MMMM yyyy";
            NSString *str = [dtFormatter stringFromDate:obj.calendarContentView.date];
            obj.title = str;

            
            [self .navigationController popViewControllerAnimated:YES];
        }
        else{
            [appDelegate hideActivityWithError:result[@"Message"]];
        }
        
    }
    else{
        
        if ([result[@"Status"] isEqualToString:@"TRUE"]) {
            
        }
        else{
            
        }
        
    }
}

- (void)webNetworkingSessionDidFailWithError:(NSError*)error forRequest:(NSString*)requesrName{
    
    [appDelegate hideActivityWithError:error.localizedDescription];
}
 
@end
