//
//  EventSearchViewController.m
//  EventDemo
//
//  Created by ketan_icoderz on 08/10/15.
//  Copyright © 2015 icoderz. All rights reserved.
//

#import "EventSearchViewController.h"
#import <sys/utsname.h>



@interface EventSearchViewController ()<WebNetworkingDelegate>
{
    int iAnimationNu;
}
@end

@implementation EventSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.navigationBarHidden=YES;
    
    IncreseValue=0;
    load=NO;
    Paging=NO;
   
    dict =[[NSMutableArray alloc]init];
    tblMain.tableFooterView = [UIView new];
    
    [appDelegate setMenuBarButtonInController:self];
    
    tblMain.scrollIndicatorInsets = UIEdgeInsetsMake(44.0f, 0.0f, 0.0f, 0.0f);
    
    [search setBackgroundImage:[appDelegate imageWithColor:kOrangeColor] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Event
-(IBAction)segMain:(id)sender{
    
    dictData = [NSMutableDictionary new];
    
    UISegmentedControl *Seg =(UISegmentedControl *)sender;
    NSInteger intSeg =Seg.selectedSegmentIndex;
    if (intSeg ==0) {
        IncreseValue=0;
        Paging=NO;
        [tblMain reloadData];
        if ([search.text length]>0) {
            [appDelegate showActivityWithStatus:@"Searching.."];
            [self GetData:search.text];
        }
    }else if (intSeg==1){
        IncreseValue=0;
        Paging=NO;
        [tblMain reloadData];
        if ([search.text length]>0) {
            [appDelegate showActivityWithStatus:@"Searching.."];
            [self GetData:search.text];
        }
    }
}

#pragma mark - tableview

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    iAnimationNu=0;
    NSMutableArray *aryCount =[dictData objectForKey:[aryKeys objectAtIndex:section]];
    return aryCount.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return dictData.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    EventSearchTableViewCell *Cell =[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    UILabel *lblTitle = Cell.lblTitle;
    UILabel *lblDate = Cell.lblDate;
    UILabel *lblGroup = Cell.lblGroup;
    UILabel *lblMile = Cell.lblMile;
    UILabel *lblNumberOfFriend = Cell.lblNumberOfFriend;
    UILabel *lblTime = Cell.lblTime;

    id key = [aryKeys objectAtIndex:indexPath.section];
    NSMutableArray *aryTemp = [dictData objectForKey:key];
  
    lblTitle.text =aryTemp[indexPath.row][@"event_name"];
    lblGroup.text =aryTemp[indexPath.row][@"event_detail"];
    lblNumberOfFriend.text =[NSString stringWithFormat:@"Attn %@ (%@ Friends)",aryTemp[indexPath.row][@"event_attend"],aryTemp[indexPath.row][@"event_attend_byfriends"]];

    NSRange rangeWord =[lblNumberOfFriend.text rangeOfString:@"("];
    NSRange range = NSMakeRange(0, rangeWord.location-1);

    NSMutableAttributedString *attan =[[NSMutableAttributedString alloc]initWithString:lblNumberOfFriend.text];
    [attan addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range];
    NSRange range1=NSMakeRange(rangeWord.location, lblNumberOfFriend.text.length-rangeWord.location);
    [attan addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:247/256.0 green:78/256.0 blue:26/256.0 alpha:1.0] range:range1];
    lblNumberOfFriend.attributedText =attan;
    lblNumberOfFriend.textAlignment =NSTextAlignmentLeft;
    
    
    CLLocation *clUsr =[[CLLocation alloc]initWithLatitude:appDelegate.currentLocation.coordinate.latitude longitude:appDelegate.currentLocation.coordinate.longitude];
    CLLocation *clEvent =[[CLLocation alloc]initWithLatitude:[aryTemp[indexPath.row][@"event_latitiude"] doubleValue] longitude:[aryTemp[indexPath.row][@"event_longitude"]doubleValue]];
    double dist =[clUsr distanceFromLocation:clEvent];
    lblMile.text=[NSString stringWithFormat:@"%.1fmiles",(dist/1609.344)];
    
    lblTime.text =[self funGetDuration:aryTemp[indexPath.row][@"event_startTime"] :aryTemp[indexPath.row][@"event_endTime"] isReapting:aryTemp[indexPath.row][@"event_isRepeating"]];
    
    if ([aryTemp[indexPath.row][@"event_isRepeating"] isEqualToString:@"0"] || [aryTemp[indexPath.row][@"event_isRepeating"] isEqualToString:@"4"]) {
        lblDate.text = [self getOnlyTime:aryTemp[indexPath.row][@"event_startTime"]];
    }
    else{
        lblDate.text = aryTemp[indexPath.row][@"event_startTime"];
    }
    
    Cell.selectionStyle =UITableViewCellSelectionStyleNone;
    return Cell;
}


- ( UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
   
    UILabel *lblTitle =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, tblMain.frame.size.width, 20)];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmt];
    NSDate *localDate = [dateFormatter dateFromString:[aryKeys objectAtIndex:section]];
    
    NSDate *currentdate = [NSDate date];
    NSTimeInterval timeZoneOffset = [[NSTimeZone defaultTimeZone] secondsFromGMT];
    currentdate = [currentdate dateByAddingTimeInterval:timeZoneOffset];
    NSString *strToday =[dateFormatter stringFromDate:currentdate];
//    currentdate = [dateFormatter dateFromString:[NSDate date]];
    currentdate= [dateFormatter dateFromString:strToday];

    
    if ([currentdate compare:localDate] ==NSOrderedSame) {
        lblTitle.text=@"Today's Events";
    }else{
        lblTitle.text=[self formateChangeHeader:[aryKeys objectAtIndex:section]];
    }
    lblTitle.textColor=[UIColor whiteColor];
    lblTitle.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    lblTitle.backgroundColor = kBlueColor;
    return lblTitle;
}




#pragma mark - View Call
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if(tblMain.contentSize.height<=tblMain.contentOffset.y+tblMain.frame.size.height && tblMain.contentOffset.y>=0)
    {
        Paging=YES;
        [self GetData:search.text];
    }
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [search resignFirstResponder];

}

#pragma mark - WebNetworking

-(void)webNetworkingSessionDidCompleteWithResult:(NSDictionary *)result forRequest:(NSString *)requesrName{
    
    
    NSDictionary *result_dic = result;
    if ([requesrName isEqualToString:@"user_upload"]) {
        if ([[result_dic objectForKey:@"Status"] isEqualToString:@"TRUE"]) {
            
            if (Paging==NO) {
                dictData=[[NSMutableDictionary alloc]init];
            }
            NSMutableArray *Dict =result_dic[@"EventDetail"];
            if (Dict.count !=0) {
                for (int count=0; count<Dict.count; count++) {
                    NSMutableDictionary *dicttTmp =[[NSMutableDictionary alloc]init];
                    [dicttTmp setObject:Dict[count][@"event_date"] forKey:@"event_date"];
                    [dicttTmp setObject:Dict[count][@"event_id"] forKey:@"event_id"];
                    [dicttTmp setObject:Dict[count][@"event_name"] forKey:@"event_name"];
                    [dicttTmp setObject:Dict[count][@"event_detail"] forKey:@"event_detail"];
                    [dicttTmp setObject:Dict[count][@"event_isRepeating"] forKey:@"event_isRepeating"];
                    [dicttTmp setObject:Dict[count][@"event_startTime"] forKey:@"event_startTime"];
                    [dicttTmp setObject:Dict[count][@"event_endTime"] forKey:@"event_endTime"];
                    [dicttTmp setObject:Dict[count][@"event_location"] forKey:@"event_location"];
                    [dicttTmp setObject:Dict[count][@"event_latitiude"] forKey:@"event_latitiude"];
                    [dicttTmp setObject:Dict[count][@"event_longitude"] forKey:@"event_longitude"];
                    [dicttTmp setObject:Dict[count][@"event_allowToEdit"] forKey:@"event_allowToEdit"];
                    [dicttTmp setObject:Dict[count][@"event_allowToInvite"] forKey:@"event_allowToInvite"];
                    [dicttTmp setObject:Dict[count][@"event_creatorName"] forKey:@"event_creatorName"];
                    [dicttTmp setObject:Dict[count][@"event_attend"] forKey:@"event_attend"];
                    [dicttTmp setObject:Dict[count][@"event_attend_byfriends"] forKey:@"event_attend_byfriends"];
                    [dicttTmp setObject:Dict[count][@"FriendParticipant"] forKey:@"FriendParticipant"];
                    //[dictData setObject:Array forKey:[NSString stringWithFormat:@"%@%d",Dict[count][@"event_id"],count]];
                    
                    NSString* key = [dicttTmp valueForKey:@"event_date"];
                    
                    if ([[dictData allKeys] containsObject:key]) {
                        NSMutableArray *arySub =dictData[key];
                        [arySub addObject:dicttTmp];
                        [dictData setObject:arySub forKey:key];
                    }
                    else
                    {
                        NSMutableArray *arySub = [[NSMutableArray alloc]init];
                        [arySub addObject:dicttTmp];
                        [dictData setObject:arySub forKey:key];
                    }
                }
                aryKeys =[[NSMutableArray alloc]initWithArray:[dictData allKeys]];
                NSSortDescriptor *descriptor=[[NSSortDescriptor alloc] initWithKey:@"self" ascending:YES];
                NSArray *descriptors=[NSArray arrayWithObject: descriptor];
                NSArray *reverseOrder=[aryKeys sortedArrayUsingDescriptors:descriptors];
                aryKeys =[[NSMutableArray alloc]initWithArray:reverseOrder];
                
                [self hideActivity];
                if (Paging==NO) {
                    [tblMain setContentOffset:CGPointZero animated:NO];
                }
                [tblMain reloadData];
                IncreseValue=IncreseValue+10;
            }else{
                if (Paging==NO) {
                    [appDelegate hideActivity];
                    //            [appDelegate hideActivityWithError:result[@"Message"]];
                }
            }
            
           
            
            
        }else{
            if (dict.count==0) {
            }
            
            
        }
    }
    load=NO;

}

-(void)webNetworkingSessionDidFailWithError:(NSError *)error forRequest:(NSString *)requesrName{
    
    [appDelegate hideActivityWithError:error.localizedDescription];
    
}






#pragma mark - GetData/PostData
-(void)GetData:(NSString *)strText{
    
    [[WebNetworking new] sendRequestWithUrl:makeHangURL(SearchEvent)
                                 parameater:@{@"UserID":appDelegate.getUserObject.user_id,
                                              @"Skip":[NSString stringWithFormat:@"%d",IncreseValue],
                                              @"TotalRecord":[NSString stringWithFormat:@"%d",10],
                                              @"SearchType":(segMain.selectedSegmentIndex==0)?@"Friends":@"Public",
                                              @"SearchText":strText}
                                   delegate:self
                            withRequestName:@"user_upload"];

}

- (void)showActivity
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
}

- (void)hideActivity
{
    [SVProgressHUD dismiss];
}


#pragma mark - UISearchBar

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    IncreseValue=0;
    Paging=NO;
    
    dictData = [NSMutableDictionary new];
    [tblMain reloadData];
    //    dictData =[[NSMutableDictionary alloc]initWithDictionary:dictData1];
    [appDelegate showActivityWithStatus:@"Searching.."];
    [self GetData:searchBar.text];
    [searchBar resignFirstResponder];

    
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{

    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    dictData = [NSMutableDictionary new];
//    dictData =[[NSMutableDictionary alloc]initWithDictionary:dictData1];
    [tblMain reloadData];
    
    [searchBar resignFirstResponder];
}


#pragma mark - Other File
- (NSString*)formatedDatefromDate:(NSString*)strDate{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm a";
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmt];
    NSDate *localDate = [dateFormatter dateFromString:strDate];
    
    NSDate *currentdate = [NSDate date];
    NSTimeInterval timeZoneOffset = [[NSTimeZone defaultTimeZone] secondsFromGMT];
    currentdate = [currentdate dateByAddingTimeInterval:timeZoneOffset];
    
    if (localDate!= nil) {
        NSDateComponentsFormatter *dcf = [NSDateComponentsFormatter new];
        dcf.unitsStyle = NSDateComponentsFormatterUnitsStyleAbbreviated;
        dcf.maximumUnitCount = 1;

        int i = [localDate timeIntervalSince1970];
        int j = [currentdate timeIntervalSince1970];
        
        double X = i-j;
        int days=(int)((double)X/(3600.0*24.00));
        
        if (days ==0) {
            NSString *string;
            NSInteger ti = (NSInteger)X ;
            NSInteger seconds = ti % 60;
            NSInteger minutes = (ti / 60) % 60;
            NSInteger hours = (ti / 3600);
            if (hours!=0) {
                string =[NSString stringWithFormat:@"%ldH",(long)hours];
            }else if (minutes!=0){
                string =[NSString stringWithFormat:@"%ldm",(long)minutes];
            }else{
                string =[NSString stringWithFormat:@"%lds",(long)seconds];
            }
            return string;
        }else{
            NSString *interval = [dcf stringFromTimeInterval:[currentdate timeIntervalSinceDate:localDate]];
            
            if ([interval containsString:@"m"] && [currentdate timeIntervalSinceDate:localDate] > 3600) {
                interval = [interval uppercaseString];
            }
            return interval;
        }
        
    }else{
        return @"";
    }
   
}

- (NSString*)formateChange:(NSString*)strDate{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm a";
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmt];
    NSDate *localDate = [dateFormatter dateFromString:strDate];
    
    if (localDate !=nil) {
        NSDateFormatter *dateFormatterConvert =[[NSDateFormatter alloc]init];
        [dateFormatterConvert setDateFormat:@"HH:mm a"];
        NSString *parsed = [dateFormatterConvert stringFromDate:localDate];
        return parsed;
    }
   return @"";
    
}
- (NSString*)formateChangeHeader:(NSString*)strDate{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmt];
    NSDate *localDate = [dateFormatter dateFromString:strDate];
    
    if (localDate !=nil) {
        NSDateFormatter *dateFormatterConvert =[[NSDateFormatter alloc]init];
        [dateFormatterConvert setDateFormat:@"MMMM dd, yyyy"];
        NSString *parsed = [dateFormatterConvert stringFromDate:localDate];
        return parsed;
    }
    return @"";
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
