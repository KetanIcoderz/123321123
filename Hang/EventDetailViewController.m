//
//  EventDetailViewController.m
//  Hang
//
//  Created by iCoderz_Ankit on 10/12/15.
//  Copyright © 2015 iCoderz. All rights reserved.
//

#import "EventDetailViewController.h"

#import "InviteViewController.h"

@interface EventDetailViewController () <WebNetworkingDelegate>

@end

@implementation EventDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [appDelegate setBackbuttonIfNeededInController:self];
    
    [self setLayout];
    
    self.title = self.objEvent.event_name;
    tfName.text = self.objEvent.event_name;

    tfDetail.text = self.objEvent.event_detail;
    [tfDetail setFont:[UIFont systemFontOfSize:16.0]];
    
    NSString *strOrganizer = [NSString stringWithFormat:@"Organizer: %@",[appDelegate setNameOfUserFromFirstName:self.objEvent.event_creatorName andUserName:self.objEvent.event_creatorUserName]];
    
    NSMutableAttributedString *attStrOrg = [[NSMutableAttributedString alloc]initWithString:strOrganizer];
    [attStrOrg setAttributes:@{NSForegroundColorAttributeName:kBlueColor} range:[strOrganizer rangeOfString:@"Organizer:"]];
    tfOrganizer.attributedText = attStrOrg;
    
    
    NSString *strInvite = [NSString stringWithFormat:@"Invited By: %@",[appDelegate setNameOfUserFromFirstName:self.objEvent.invitedBy[@"FullName"] andUserName:self.objEvent.invitedBy[@"user_name"]]];
    
    NSMutableAttributedString *attStrInv = [[NSMutableAttributedString alloc]initWithString:strInvite];
    [attStrInv setAttributes:@{NSForegroundColorAttributeName:kBlueColor} range:[strInvite rangeOfString:@"Invited By:"]];
    tfInvitedBy.attributedText = attStrInv;

    [btnLocation setTitle:self.objEvent.event_location forState:UIControlStateNormal];
    
    if ([self.objEvent.event_MyStatus isEqualToString:@""]) {
        btnMaybe.userInteractionEnabled = YES;
        btnNotGoing.userInteractionEnabled = YES;
        btnGoing.userInteractionEnabled = YES;
    }
    else{
        
        btnMaybe.userInteractionEnabled = NO;
        btnNotGoing.userInteractionEnabled = NO;
        btnGoing.userInteractionEnabled = NO;
        
        if ([self.objEvent.event_MyStatus isEqualToString:@"YES"]) {
            [btnGoing setBackgroundColor:kBlueColor];
            [btnGoing setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        else if ([self.objEvent.event_MyStatus isEqualToString:@"NO"]){
            [btnNotGoing setBackgroundColor:kBlueColor];
            [btnNotGoing setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        else if ([self.objEvent.event_MyStatus isEqualToString:@"MayBe"]){
            [btnMaybe setBackgroundColor:kBlueColor];
            [btnMaybe setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        
    }
    
    [self getParticiant];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews{
    
    CGFloat numberofcell = 5;
    CGFloat spacebetweenItem = 5;
    
    cellDimention = floorf((cv.frame.size.width - 20*2 - (numberofcell-1)*spacebetweenItem)/numberofcell);
    [cv reloadData];
    
    cvHeight.constant = cv.contentSize.height;
    
    [sv setContentSize:CGSizeMake(sv.contentSize.width, cvHeight.constant + 490)];
    
    CGPoint topOffset = CGPointMake(0, 0);
    [tfDetail setContentOffset:topOffset];
}

- (void)setLayout
{
    btnMaybe.layer.cornerRadius = 4.0;
    btnNotGoing.layer.cornerRadius = 4.0;
    btnGoing.layer.cornerRadius = 4.0;
    
    UIView *viewLeft = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, tfName.frame.size.height)];
    tfName.leftView = viewLeft;
    tfName.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *viewRight = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, tfName.frame.size.height)];
    tfName.rightView = viewRight;
    tfName.rightViewMode = UITextFieldViewModeAlways;
    
    UIView *viewLeft1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, tfName.frame.size.height)];
    tfInvitedBy.leftView = viewLeft1;
    tfInvitedBy.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *viewRight1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, tfName.frame.size.height)];
    tfInvitedBy.rightView = viewRight1;
    tfInvitedBy.rightViewMode = UITextFieldViewModeAlways;
    
    UIView *viewLeft2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, tfName.frame.size.height)];
    tfOrganizer.leftView = viewLeft2;
    tfOrganizer.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *viewRight2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, tfName.frame.size.height)];
    tfOrganizer.rightView = viewRight2;
    tfOrganizer.rightViewMode = UITextFieldViewModeAlways;
    
    tfName.layer.borderColor = [UIColor lightGrayColor].CGColor;
    tfName.layer.borderWidth = 1.0;
    
    tfDetail.layer.borderColor = [UIColor lightGrayColor].CGColor;
    tfDetail.layer.borderWidth = 1.0;
    
    tfInvitedBy.layer.borderColor = [UIColor lightGrayColor].CGColor;
    tfInvitedBy.layer.borderWidth = 1.0;
    
    tfOrganizer.layer.borderColor = [UIColor lightGrayColor].CGColor;
    tfOrganizer.layer.borderWidth = 1.0;
    
    btnStartDate.layer.borderColor = [UIColor lightGrayColor].CGColor;
    btnStartDate.layer.borderWidth = 1.0;
    btnStartDate.titleLabel.numberOfLines = 2;
    btnStartDate.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    btnEndDate.layer.borderColor = [UIColor lightGrayColor].CGColor;
    btnEndDate.layer.borderWidth = 1.0;
    btnEndDate.titleLabel.numberOfLines = 2;
    btnEndDate.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    btnShareFriend.layer.borderColor = [UIColor lightGrayColor].CGColor;
    btnShareFriend.layer.borderWidth = 1.0;
    btnShareFriend.titleLabel.textAlignment = NSTextAlignmentCenter;
    btnShareFriend.titleLabel.numberOfLines = 2;
    
    btnShareGroup.layer.borderColor = [UIColor lightGrayColor].CGColor;
    btnShareGroup.layer.borderWidth = 1.0;
    btnShareGroup.titleLabel.textAlignment = NSTextAlignmentCenter;
    btnShareGroup.titleLabel.numberOfLines = 2;
    
    btnMaybe.layer.borderColor = [UIColor lightGrayColor].CGColor;
    btnMaybe.layer.borderWidth = 1.0;
    btnMaybe.titleLabel.textAlignment = NSTextAlignmentCenter;
    btnMaybe.titleLabel.numberOfLines = 2;
    
    btnGoing.layer.borderColor = [UIColor lightGrayColor].CGColor;
    btnGoing.layer.borderWidth = 1.0;
    btnGoing.titleLabel.textAlignment = NSTextAlignmentCenter;
    btnGoing.titleLabel.numberOfLines = 2;
    
    btnNotGoing.layer.borderColor = [UIColor lightGrayColor].CGColor;
    btnNotGoing.layer.borderWidth = 1.0;
    btnNotGoing.titleLabel.textAlignment = NSTextAlignmentCenter;
    btnNotGoing.titleLabel.numberOfLines = 2;
    
    btnShareGroup.layer.borderColor = [UIColor lightGrayColor].CGColor;
    btnShareGroup.layer.borderWidth = 1.0;
    btnShareGroup.titleLabel.textAlignment = NSTextAlignmentCenter;
    btnShareGroup.titleLabel.numberOfLines = 2;
    
    btnLocation.layer.borderColor = [UIColor lightGrayColor].CGColor;
    btnLocation.layer.borderWidth = 1.0;
    btnLocation.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    btnLocation.titleLabel.numberOfLines = 2;
    btnLocation.titleLabel.minimumScaleFactor = 0.5;

    [self setBtnShareFriend];
    [self setBtnShareGroup];
    
    [btnStartDate setAttributedTitle:[self setDateFromDate:self.objEvent.event_startTime] forState:UIControlStateNormal];
    [btnEndDate setAttributedTitle:[self setDateFromDate:self.objEvent.event_endTime] forState:UIControlStateNormal];

}

-(void)getParticiant{
    [[WebNetworking new] sendRequestWithUrl:makeHangURL(GetEventDetail)
                                 parameater:@{
                                              @"EventID":self.objEvent.event_id,
                                              @"UserID":appDelegate.getUserObject.user_id,
                                              @"SearchDate":self.strDate
                                              }
                                   delegate:self
                            withRequestName:@"GetEventDetail"];

}

-(void)setBtnShareFriend{
    
    NSString *temp = @"Share with\nFriends";
    
    NSRange rangeStart = NSMakeRange(0 ,[@"Share with" length]);
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

- (NSMutableAttributedString*)setDateFromDate:(NSString *)strDate{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm a"];
    NSDate *date = [dateFormatter dateFromString:strDate];
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE MMM dd"];
    NSString *strTop = [[dateFormatter stringFromDate:date] uppercaseString];
    [dateFormatter setDateFormat:@"hh:mm a"];
    NSString *strBotttom = [[dateFormatter stringFromDate:date] uppercaseString];
    
    NSString *temp = [NSString stringWithFormat:@"%@\n%@",strTop,strBotttom];
    NSRange rangeStart = NSMakeRange(0 , [strTop length]);
    NSRange rangeEnd = NSMakeRange([strTop length]+1 , [strBotttom length]);
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:temp];
    
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:rangeStart];
    [att addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Medium" size:11.0] range:rangeStart];
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:65.0/255.0 green:125.0/255.0 blue:177.0/255.0 alpha:1.0] range:rangeEnd];
    [att addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Medium" size:18.0] range:rangeEnd];
    
    return att;
}

-(IBAction)shareFriend:(UIButton*)sender{
}

-(IBAction)shareGroup:(UIButton*)sender{
}

-(IBAction)yes:(id)sender{
    
    btnMaybe.userInteractionEnabled = NO;
    btnNotGoing.userInteractionEnabled = NO;
    btnGoing.userInteractionEnabled = NO;
    
    NSDictionary *dict = @{@"UserID":appDelegate.getUserObject.user_id,
                           @"EventDate":self.strDate,
                           @"EventID":self.objEvent.event_id,
                           @"Status":@"1"};
    
    [[WebNetworking new] sendRequestWithUrl:makeHangURL(JoinEvent)
                                 parameater:dict
                                   delegate:self
                            withRequestName:@"YesEvent"
                                      extra:sender];
    [appDelegate showActivityWithStatus:@"Loading..."];
    
}

-(IBAction)no:(id)sender{

    btnMaybe.userInteractionEnabled = NO;
    btnNotGoing.userInteractionEnabled = NO;
    btnGoing.userInteractionEnabled = NO;

    NSDictionary *dict = @{@"UserID":appDelegate.getUserObject.user_id,
                           @"EventDate":self.strDate,
                           @"EventID":self.objEvent.event_id,
                           @"Status":@"0"};
    
    [[WebNetworking new] sendRequestWithUrl:makeHangURL(JoinEvent)
                                 parameater:dict
                                   delegate:self
                            withRequestName:@"NoEvent"
                                      extra:sender];
    [appDelegate showActivityWithStatus:@"Loading..."];
    
}

-(IBAction)maybe:(id)sender{

    btnMaybe.userInteractionEnabled = NO;
    btnNotGoing.userInteractionEnabled = NO;
    btnGoing.userInteractionEnabled = NO;

    NSDictionary *dict = @{@"UserID":appDelegate.getUserObject.user_id,
                           @"EventDate":self.strDate,
                           @"EventID":self.objEvent.event_id,
                           @"Status":@"2"};
    
    [[WebNetworking new] sendRequestWithUrl:makeHangURL(JoinEvent)
                                 parameater:dict
                                   delegate:self
                            withRequestName:@"MaybeEvent"
                                      extra:sender];
    [appDelegate showActivityWithStatus:@"Loading..."];
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    InviteViewController*obj = (InviteViewController*)[segue destinationViewController];
    
    if ([segue.identifier isEqualToString:@"shareFriend"]) {
        obj.isGroup = NO;
    }
    else if ([segue.identifier isEqualToString:@"shareGroup"]){
        obj.isGroup = YES;
    }
}


#pragma mark - UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return MIN(5, arrYes.count);
    }
    else if (section == 1){
        return MIN(5, arrMaybe.count);
    }
    else{
        return MIN(5, arrNo.count);
    }

}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        
        UILabel *lbl = (UILabel*)[headerView viewWithTag:201];
        
        switch (indexPath.section) {
            case 0:
                lbl.text = @"Attending";
                break;
            case 1:
                lbl.text = @"Maybe";
                break;
            case 2:
                lbl.text = @"Not Attending";
                break;
                
            default:
                lbl.text = @"";
                break;
        }
        
        reusableview = headerView;
    }
    
    return reusableview;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    return CGSizeMake(cellDimention, cellDimention);
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    NSMutableArray *arrayTemp;
    
    if (indexPath.section == 0) {
        arrayTemp = arrYes;
    }
    else if (indexPath.section == 1) {
        arrayTemp = arrMaybe;
    }
    else if (indexPath.section == 2) {
        arrayTemp = arrNo;
    }
    
    UIImageView *img = (UIImageView*)[cell viewWithTag:301];
    UILabel *lbl = (UILabel*)[cell viewWithTag:302];
    
    if (indexPath.row < 4 || arrayTemp.count == 5) {
        img.hidden = NO;
        lbl.hidden = YES;
        NSString *str = arrayTemp[indexPath.row][@"ProfileImage"];
        [img setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage new]];
    }
    else{
        img.hidden = YES;
        lbl.hidden = NO;
        lbl.text = [NSString stringWithFormat:@"+%lu\nMore",arrayTemp.count-4];
    }
    

    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
 
    UIImageView *img = (UIImageView*)[cell viewWithTag:301];
    img.layer.cornerRadius = cellDimention/2;
    img.layer.masksToBounds = YES;
    
    UILabel *lbl = (UILabel*)[cell viewWithTag:302];
    lbl.layer.cornerRadius = cellDimention/2;
    lbl.layer.masksToBounds = YES;
    
    [cell layoutIfNeeded];

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    NSMutableArray *arrayTemp;
    
    if (indexPath.section == 0) {
        arrayTemp = arrYes;
    }
    else if (indexPath.section == 1) {
        arrayTemp = arrMaybe;
    }
    else if (indexPath.section == 2) {
        arrayTemp = arrNo;
    }
    if (indexPath.row < 4 || arrayTemp.count == 5) {
        
        UIMenuItem *flag = [[UIMenuItem alloc] initWithTitle:[appDelegate setNameOfUserFromFirstName:arrayTemp[indexPath.row][@"FullName"] andUserName:arrayTemp[indexPath.row][@"user_name"]] action:@selector(flag:)];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        
        [menu setMenuItems:[NSArray arrayWithObjects:flag, nil]];
        [menu setTargetRect:cell.frame inView:cell.superview];
        [menu setMenuVisible:YES animated:YES];

    }
    
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}


- (void)flag:(id)sender
{
    
}

#pragma mark - WebNetworking Delegate

- (void)webNetworkingSessionDidCompleteWithResult:(NSDictionary*)result forRequest:(NSString*)requesrName{
    
    [appDelegate hideActivity];
    
    if ([requesrName isEqualToString:@"GetEventDetail"]) {
        
        if ([result[@"Status"] isEqualToString:@"TRUE"]) {
            
            arrYes = [NSMutableArray arrayWithArray:result[@"EventDetail"][@"YesParticipant"]];
            arrMaybe = [NSMutableArray arrayWithArray:result[@"EventDetail"][@"MayBeParticipant"]];
            arrNo = [NSMutableArray arrayWithArray:result[@"EventDetail"][@"NoParticipant"]];
            
            [cv reloadData];
            
        }
        else{
            
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

#pragma mark - WebNetworking Delegate

- (void)webNetworkingSessionDidCompleteWithResult:(NSDictionary*)result forRequest:(NSString*)requesrName extra:(id)extra{
    
    [appDelegate hideActivity];
    
    if ([requesrName isEqualToString:@"MaybeEvent"] | [requesrName isEqualToString:@"NoEvent"] | [requesrName isEqualToString:@"YesEvent"]) {
        
        if ([result[@"Status"] isEqualToString:@"TRUE"]) {
            
            [(UIButton *)extra setBackgroundColor:kBlueColor];
            [(UIButton *)extra setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
        }
        else
        {
            
            btnMaybe.userInteractionEnabled = YES;
            btnNotGoing.userInteractionEnabled = YES;
            btnGoing.userInteractionEnabled = YES;

            [appDelegate hideActivityWithError:result[@"Message"]];
        }

    }
    else
    {
        
        if ([result[@"Status"] isEqualToString:@"TRUE"]) {
            
        }
        else{
            
        }
        
    }
}

- (void)webNetworkingSessionDidFailWithError:(NSError*)error forRequest:(NSString*)requesrName extra:(id)extra{
    
    btnMaybe.userInteractionEnabled = YES;
    btnNotGoing.userInteractionEnabled = YES;
    btnGoing.userInteractionEnabled = YES;

    
    [appDelegate hideActivityWithError:error.localizedDescription];
}

@end
