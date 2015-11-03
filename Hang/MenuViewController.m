//
//  MenuViewController.m
//  Hang
//
//  Created by iCoderz_Ankit on 9/10/15.
//  Copyright (c) 2015 iCoderz. All rights reserved.
//

#import "MenuViewController.h"

#import "MyCalendarViewController.h"
#import "SettingsViewController.h"
#import "FriendsViewController.h"
#import "OrganizationViewController.h"
#import "GroupsViewController.h"
#import "EventSearchViewController.h"
#import "RequestViewController.h"
#import "MyOrganizationsViewController.h"

@interface MenuViewController ()<WebNetworkingDelegate>

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [appDelegate setBackbuttonIfNeededInController:self];
    
    arrayNames = [[NSMutableArray alloc]initWithObjects:@"MY CALENDAR",@"SEARCH EVENTS",@"FRIENDS",@"GROUPS",@"ORGANIZATIONS",@"MY ORGANIZATIONS",@"FRIEND REQUESTS/\nINVITATIONS",@"SETTINGS",nil];
    
    self.tblView.tableFooterView = [UIView new];
    
//    [self.navigationController setNavigationBarHidden:YES];
//    self.tblView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [[WebNetworking new] sendRequestWithUrl:makeHangURL(GetCountRequest)
                                 parameater:@{@"UserID":appDelegate.getUserObject.user_id}
                                   delegate:self
                            withRequestName:@"GetCountRequest"];
    
}

-(void)viewDidAppear:(BOOL)animated{
    
//    self.view.frame = CGRectMake(0, 0, [[self revealViewController] rearViewRevealWidth], self.view.frame.size.height);
//    self.view.clipsToBounds=YES;

}

-(void)openSearch{
    
    SWRevealViewController *revealController = self.revealViewController;
    
    UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"navSearch"];
    [revealController setFrontViewController:navigationController animated:YES];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UItableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrayNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text = arrayNames[indexPath.row];
    
    if (indexPath.row == 6) {
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 26, 26)];
        lbl.backgroundColor = [UIColor colorWithRed:252.0/255.0 green:102./255.0 blue:33.0/255.0 alpha:1.0];
        lbl.layer.cornerRadius = lbl.frame.size.width/2;
        lbl.layer.masksToBounds = YES;
        lbl.font = [UIFont systemFontOfSize:14.0];
        lbl.text = @"";
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.textColor = [UIColor whiteColor];
        lbl.hidden =YES;
        
        cell.accessoryView = lbl;
    }
    else{
        cell.accessoryView = nil;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SWRevealViewController *revealController = self.revealViewController;
    UINavigationController *frontNavigationController = (id)revealController.frontViewController;
    
    {
        switch (indexPath.row) {
                
            case 0:{
                
                if (![frontNavigationController.topViewController isKindOfClass:[MyCalendarViewController class]])
                {
                    UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"navCalendar"];
                    [revealController setFrontViewController:navigationController animated:YES];
                }
                else
                {
                    [revealController revealToggle:self];
                }
                break;
                
            }
                
            case 1:{
                
                if (![frontNavigationController.topViewController isKindOfClass:[EventSearchViewController class]])
                {
                    UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"navSearch"];
                    [revealController setFrontViewController:navigationController animated:YES];
                }
                else
                {
                    [revealController revealToggle:self];
                }
                break;
                
            }
                
            case 2:{
                
                if (![frontNavigationController.topViewController isKindOfClass:[FriendsViewController class]])
                {
                    UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"navFriends"];
                    [revealController setFrontViewController:navigationController animated:YES];
                }
                else
                {
                    [revealController revealToggle:self];
                }
                break;
                
            }
                
            case 3:{
                
                if (![frontNavigationController.topViewController isKindOfClass:[GroupsViewController class]])
                {
                    UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"navGroups"];
                    [revealController setFrontViewController:navigationController animated:YES];
                }
                else
                {
                    [revealController revealToggle:self];
                }
                break;
                
            }
            
            case 4:{
                
                if (![frontNavigationController.topViewController isKindOfClass:[OrganizationViewController class]])
                {
                    UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"navOrg"];
                    [revealController setFrontViewController:navigationController animated:YES];
                }
                else
                {
                    [revealController revealToggle:self];
                }
                break;
                
            }
            
            case 5:{
                
                if (![frontNavigationController.topViewController isKindOfClass:[MyOrganizationsViewController class]])
                {
                    UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"navMyOrg"];
                    [revealController setFrontViewController:navigationController animated:YES];
                }
                else
                {
                    [revealController revealToggle:self];
                }
                break;
                
            }
            
            case 6:{
                
                if (![frontNavigationController.topViewController isKindOfClass:[RequestViewController class]])
                {
                    UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"navRequest"];
                    [revealController setFrontViewController:navigationController animated:YES];
                }
                else
                {
                    [revealController revealToggle:self];
                }
                break;
                
            }
                
            case 7:{
                
                if (![frontNavigationController.topViewController isKindOfClass:[SettingsViewController class]])
                {
                    UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"navSettings"];
                    [revealController setFrontViewController:navigationController animated:YES];
                }
                else
                {
                    [revealController revealToggle:self];
                }
                break;
                
            }

            default:
                break;
        }
    }
}


#pragma mark - WebNetworking Delegate

- (void)webNetworkingSessionDidCompleteWithResult:(NSDictionary*)result forRequest:(NSString*)requesrName{
    
    [appDelegate hideActivity];
    
    if ([requesrName isEqualToString:@"GetCountRequest"]) {
        
        UITableViewCell *cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]];
        
        ((UILabel*)cell.accessoryView).hidden = YES;
        
        if ([result.allKeys containsObject:@"InvitationCount"] && [result[@"InvitationCount"] integerValue] != 0) {
            ((UILabel*)cell.accessoryView).hidden = NO;
            ((UILabel*)cell.accessoryView).text = result[@"InvitationCount"];
        }
        else{
            ((UILabel*)cell.accessoryView).text = @"0";
        }
    }
}

- (void)webNetworkingSessionDidFailWithError:(NSError*)error forRequest:(NSString*)requesrName{
 
    UITableViewCell *cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]];
    ((UILabel*)cell.accessoryView).hidden = YES;
    ((UILabel*)cell.accessoryView).text = @"0";

}

@end
