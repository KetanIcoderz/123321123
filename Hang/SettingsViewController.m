//
//  SettingsViewController.m
//  Hang
//
//  Created by iCoderz_Ankit on 9/10/15.
//  Copyright (c) 2015 iCoderz. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()<UIActionSheetDelegate,WebNetworkingDelegate>

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [appDelegate setMenuBarButtonInController:self];
    
    swFacebook = [[UISwitch alloc]initWithFrame:CGRectMake(0, 0, swFacebook.frame.size.width, swFacebook.frame.size.height)];
    swFacebook.on = [appDelegate.getUserObject.user_facebookSync isEqualToString:@"1"];
    [swFacebook addTarget:self action:@selector(facebookSyncChanged) forControlEvents:UIControlEventValueChanged];
    
    arrayNames = [[NSMutableArray alloc]initWithObjects:@"My Profile",@"Profile Picture",@"Permissions",@"Notifications",@"About",@"Event Reminder",@"Facebook Events Sync",@"Sync Facebook Event Now",@"Week Start Day",@"Search Radius",@"Logout", nil];
    
    tblView.tableFooterView = [UIView new];
    
    arrayWeekDays = [[NSMutableArray alloc]initWithObjects:@"Sunday",@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday", nil];
    arrayAlert = [[NSMutableArray alloc]initWithObjects:@"No Alerts",@"Start of Event",@"10 Minutes Before",@"30 Minutes Before",@"1 hour Before",@"1 Day Before", nil];
    arraySearchRadius = [[NSMutableArray alloc]initWithObjects:@"5 Miles",@"10 Miles",@"15 Miles",@"20 Miles",@"25 Miles",@"50 Miles", nil];

    indexSearchRadius = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)facebookSyncChanged{
    
    UserObject *obj = appDelegate.getUserObject;
    obj.user_facebookSync = swFacebook.isOn?@"1":@"0";
    [appDelegate saveUserObject:obj];
    
    [tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:7 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    if (swFacebook.isOn) {
        [self syncFacebookEventFromController:self];
    }

}

- (void)syncFacebookEventFromController:(id)controller{
    
//    [appDelegate showActivityWithStatus:@"Getting Facebook events.."];
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    login.loginBehavior = FBSDKLoginBehaviorSystemAccount;
    [login logInWithReadPermissions: @[@"public_profile",@"email",@"user_friends"]
                 fromViewController:self
                            handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         
         
         
         if (error) {
             [appDelegate hideActivityWithError:error.localizedDescription];
             NSLog(@"Process error");
//             [[[UIAlertView alloc]initWithTitle:appName message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
             
             
         } else if (result.isCancelled) {
             [appDelegate hideActivityWithError:@"User cancelled syncing."];
             NSLog(@"Cancelled");
//             [[[UIAlertView alloc]initWithTitle:@"Facebook" message:@"The user hasn't authorized the application to perform this action." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
             
         } else {
             
             NSLog(@"Logged in");
             
             appDelegate.arrFBEvents = [[NSMutableArray alloc] init];
             
             FBSDKGraphRequest *request1 = [[FBSDKGraphRequest alloc]
                                            initWithGraphPath:@"/me/events"
                                            parameters:@{ @"fields": @"description,start_time,end_time,name,place,id,rsvp_status,attending_count,maybe_count,owner,declined_count,can_guests_invite,attending.limit(10){name,picture{url}}",}
                                            HTTPMethod:@"GET"];
             
             [request1 startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                                    id result,
                                                    NSError *error) {
                 
                 if (!error){
                     
                     NSArray *arrFBEvent = result[@"data"];
                     NSMutableArray *tempArray = [NSMutableArray new];
                     
                     for (NSDictionary *dict in arrFBEvent)
                     {
                         NSMutableDictionary *dictEvent = [NSMutableDictionary new];
                         dictEvent[@"UserID"] = appDelegate.getUserObject.user_id;
                         dictEvent[@"FbEventID"] = dict[@"id"]?dict[@"id"]:@"";
                         dictEvent[@"FBUserID"] = dict[@"owner"][@"id"]?dict[@"owner"][@"id"]:@"";
                         dictEvent[@"event_creatorName"] = dict[@"owner"][@"name"]?dict[@"owner"][@"name"]:@"";
                         dictEvent[@"event_name"] = dict[@"name"]?dict[@"name"]:@"";
                         dictEvent[@"event_detail"] = dict[@"description"]?dict[@"description"]:@"";
                         dictEvent[@"event_startTime"] = [self getFacebookTime:dict[@"start_time"]];
                         dictEvent[@"event_endTime"] = [self getFacebookTime:dict[@"end_time"]];
                         dictEvent[@"event_location"] = dict[@"place"][@"name"]?dict[@"place"][@"name"]:@"";
                         dictEvent[@"event_latitiude"] = dict[@"place"][@"location"][@"latitude"]?dict[@"place"][@"location"][@"latitude"]:@"";
                         dictEvent[@"event_longitude"] = dict[@"place"][@"location"][@"longitude"]?dict[@"place"][@"location"][@"longitude"]:@"";
                         
                         [tempArray addObject:dictEvent];
                     }
                     
                     [appDelegate showActivityWithStatus:@"Syncing Facebook Events.."];
                     [[WebNetworking new] sendRequestWithUrl:makeHangURL(FBEventSync)
                                                  parameater:@{@"FacebookSync":tempArray}
                                                    delegate:controller
                                             withRequestName:@"FacebookSync"];
                     
                 }
                 else {
                     [appDelegate hideActivityWithError:error.localizedDescription];
                     NSLog(@"result: %@",[error description]);
                 }
             }];
         }
     }];
    
}

-(NSString*)getFacebookTime:(NSString*)strDate{
    
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSDate *d = [df dateFromString:strDate];
    
    if (d) {
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        return [df stringFromDate:d];
    }
    else
    {
        [df setDateFormat:@"yyyy-MM-dd"];
        d = [df dateFromString:strDate];
        
        if (d)
        {
            [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            return [df stringFromDate:d];
        }
        else{
            return @"";
            
        }
    }
}


#pragma mark - UItableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrayNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell;
    
    if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cellBasic" forIndexPath:indexPath];
    }
    else if (indexPath.row == 5){
        cell = [tableView dequeueReusableCellWithIdentifier:@"cellRightdetail" forIndexPath:indexPath];
        
        cell.detailTextLabel.text = arrayAlert[appDelegate.indexAlert];
    }
    else if(indexPath.row == 6){
        cell = [tableView dequeueReusableCellWithIdentifier:@"cellCustom" forIndexPath:indexPath];
        cell.accessoryView = swFacebook;
    }
    else if(indexPath.row == 7){
        cell = [tableView dequeueReusableCellWithIdentifier:@"cellCustom" forIndexPath:indexPath];
        if (swFacebook.isOn) {
            cell.textLabel.textColor = [UIColor blackColor];
        }
        else{
            cell.textLabel.textColor = [UIColor lightGrayColor];
        }
    }
    else if (indexPath.row == 8){
        cell = [tableView dequeueReusableCellWithIdentifier:@"cellRightdetail" forIndexPath:indexPath];
        cell.detailTextLabel.text = arrayWeekDays[appDelegate.indexWeekStart];
    }
    else if (indexPath.row == 9){
        cell = [tableView dequeueReusableCellWithIdentifier:@"cellRightdetail" forIndexPath:indexPath];
        cell.detailTextLabel.text = arraySearchRadius[indexSearchRadius];
    }
    else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"cellCustom" forIndexPath:indexPath];
    }
    
    cell.textLabel.text = arrayNames[indexPath.row];
    
    if ([cell respondsToSelector:@selector(preservesSuperviewLayoutMargins)]){
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.preservesSuperviewLayoutMargins = false;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        [self performSegueWithIdentifier:@"myProfile" sender:nil];
    }
    else if (indexPath.row == 1) {
        [self performSegueWithIdentifier:@"profilePicture" sender:nil];
    }
    else if (indexPath.row == 3) {
        [self performSegueWithIdentifier:@"notification" sender:nil];
    }
    else if (indexPath.row == 5) {
        UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:@"Alert" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        
        for (NSString *str in arrayAlert) {
            [sheet addButtonWithTitle:str];
        }
        
        sheet.cancelButtonIndex = [sheet addButtonWithTitle:@"Cancel"];
        
        sheet.tag = 101;
        sheet.destructiveButtonIndex = appDelegate.indexAlert;
        [sheet showInView:self.view];
    }
    else if(indexPath.row == 7){
        
        if (swFacebook.isOn) {
            [self syncFacebookEventFromController:self];
        }
        else{
            
        }
        
    }
    else if (indexPath.row == 8) {
        UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:@"Week Start Day" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        
        for (NSString *str in arrayWeekDays) {
            [sheet addButtonWithTitle:str];
        }
        
        sheet.cancelButtonIndex = [sheet addButtonWithTitle:@"Cancel"];
        
        sheet.tag = 102;
        sheet.destructiveButtonIndex = appDelegate.indexWeekStart;
        [sheet showInView:self.view];
    }
    else if (indexPath.row == 9) {
        UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:@"Search Radius" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        
        for (NSString *str in arraySearchRadius) {
            [sheet addButtonWithTitle:str];
        }
        
        sheet.cancelButtonIndex = [sheet addButtonWithTitle:@"Cancel"];
        
        sheet.tag = 103;
        sheet.destructiveButtonIndex = indexSearchRadius;
        [sheet showInView:self.view];
    }
    else if (indexPath.row == 10) {
        
        UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:@"Are you sure you want to logout?" delegate:self cancelButtonTitle:@"No" destructiveButtonTitle:nil otherButtonTitles:@"Logout", nil];
        sheet.tag = 100;
        sheet.destructiveButtonIndex = 0;
        [sheet showInView:self.view];
        
    }
}

#pragma mark - UIActionsheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;{
    if (buttonIndex==actionSheet.cancelButtonIndex) {
        return;
    }
    
    if (actionSheet.tag == 100) {
        [appDelegate deleteUserObject];
        [self.revealViewController.navigationController popToRootViewControllerAnimated:YES];
    }
    else if (actionSheet.tag == 101){
        appDelegate.indexAlert=buttonIndex;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:appDelegate.indexAlert forKey:key_indexAlert];
        [defaults synchronize];
        
        UITableViewCell *cell = [tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
        cell.detailTextLabel.text = [actionSheet buttonTitleAtIndex:buttonIndex];
    }
    else if (actionSheet.tag == 102){
        appDelegate.indexWeekStart=buttonIndex;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:appDelegate.indexWeekStart forKey:key_indexWeekStart];
        [defaults synchronize];
        
        UITableViewCell *cell = [tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:8 inSection:0]];
        cell.detailTextLabel.text = [actionSheet buttonTitleAtIndex:buttonIndex];
    }
    else if (actionSheet.tag == 103){
        indexSearchRadius=buttonIndex;
        UITableViewCell *cell = [tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:9 inSection:0]];
        cell.detailTextLabel.text = [actionSheet buttonTitleAtIndex:buttonIndex];
    }
    else{
        
    }
}

#pragma mark - WebNetworking Delegate

- (void)webNetworkingSessionDidCompleteWithResult:(NSDictionary*)result forRequest:(NSString*)requesrName{
    
    if ([requesrName isEqualToString:@"FacebookSync"]) {
        
        if ([result[@"Status"] isEqualToString:@"TRUE"]) {
            [appDelegate hideActivityWithSuccess:@"Facebook Event Sync Successfully."];
        }
        else{
            [appDelegate hideActivityWithError:result[@"Message"]];
        }
        
    }
    else{
        
        [appDelegate hideActivity];
        
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
