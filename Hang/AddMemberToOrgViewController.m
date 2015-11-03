//
//  AddMemberToOrgViewController.m
//  Hang
//
//  Created by iCoderz_Ankit on 9/21/15.
//  Copyright (c) 2015 iCoderz. All rights reserved.
//

#import "AddMemberToOrgViewController.h"
#import "ShareWithTableViewCell.h"

@interface AddMemberToOrgViewController ()<WebNetworkingDelegate>

@end

@implementation AddMemberToOrgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [appDelegate setBackbuttonIfNeededInController:self];
    
    array = [NSMutableArray new];
    
    tblView.tableFooterView = [UIView new];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
        
}

- (void)viewDidAppear:(BOOL)animated
{
    [[WebNetworking new] sendRequestWithUrl:makeHangURL(GetMyFriendsForInviteOrganization)
                                 parameater:@{@"OrganizationID":self.objOrganization.org_id,
                                              @"UserID":appDelegate.getUserObject.user_id}
                                   delegate:self
                            withRequestName:@"GetMyFriendsForInviteOrganization"];
    [appDelegate showActivityWithStatus:@"Getting Friends.."];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    ShareWithTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    UserObject *objUser = array[indexPath.row];
    
    cell.btn.selected = objUser.isFriend;
    cell.lbl.text = [appDelegate setNameOfUserFromFirstName:objUser.user_firstName andUserName:objUser.user_name];
    cell.btn.layer.borderColor = cell.btn.selected?[UIColor colorWithRed:252.0/255.0 green:102.0/255.0 blue:33.0/255.0 alpha:0.9].CGColor:[UIColor colorWithRed:65.0/255.0 green:125.0/255.0 blue:177.0/255.0 alpha:0.9].CGColor;
    [cell.img setImageWithURL:[NSURL URLWithString:objUser.user_profilePictureURL]];

    if ([cell respondsToSelector:@selector(preservesSuperviewLayoutMargins)]) {
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.preservesSuperviewLayoutMargins = false;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserObject *objUser = array[indexPath.row];
    
    if (objUser.isFriend == YES) {
        return;
    }
    else{
        
        [[WebNetworking new] sendRequestWithUrl:makeHangURL(InviteFriendsToOrganization)
                                     parameater:@{@"UserID":appDelegate.getUserObject.user_id,
                                                  @"OrganizationID":self.objOrganization.org_id,
                                                  @"FriendUserID":objUser.user_id}
                                       delegate:self
                                withRequestName:@"InviteFriendsToOrganization"
                                          extra:indexPath];
    }
    
}

#pragma mark - WebNetworkingDelegate

- (void)webNetworkingSessionDidCompleteWithResult:(NSDictionary *)result forRequest:(NSString *)requesrName
{
    if([requesrName isEqualToString:@"GetMyFriendsForInviteOrganization"])//GetMyFriends
    {
        if ([result[@"Status"] isEqualToString:@"TRUE"])
        {
            [array removeAllObjects];
            for (NSDictionary *dict in result[@"UserDetails"])
            {
                
                UserObject *objUser = [UserObject new];
                objUser.user_id = dict[@"user_id"];
                objUser.user_name = dict[@"user_name"];
                objUser.user_firstName = dict[@"user_firstName"];
                objUser.user_profilePictureURL = dict[@"user_profilePictureURL"];
                objUser.isFriend = ([dict[@"FollowOrganization"] boolValue] | [dict[@"IsFriendInvited"] boolValue]);
                
                [array addObject:objUser];

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
    else
    {
        if ([result[@"Status"] isEqualToString:@"TRUE"])
        {
            
        }
        else
        {
            [appDelegate hideActivity];
            //            [appDelegate hideActivityWithError:result[@"Message"]];
        }
    }
}

- (void)webNetworkingSessionDidFailWithError:(NSError *)error forRequest:(NSString *)requesrName
{
    [appDelegate hideActivityWithError:error.localizedDescription];
}

#pragma mark Exra

- (void)webNetworkingSessionDidCompleteWithResult:(NSDictionary*)result forRequest:(NSString*)requesrName extra:(id)extra{
    
    if ([requesrName isEqualToString:@"InviteFriendsToOrganization"]) {
        
        if ([result[@"Status"] isEqualToString:@"TRUE"]) {
            
            NSIndexPath *indexPath = (NSIndexPath*)extra;
            ((UserObject*)array[indexPath.row]).isFriend = YES;
            [tblView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }
        else {
            [appDelegate hideActivityWithError:result[@"Message"]];
        }
        
    }
    else
    {
        [appDelegate hideActivity];
        if ([result[@"Status"] isEqualToString:@"TRUE"]) {
            
        }
        else{
            
        }
        
    }
}

- (void)webNetworkingSessionDidFailWithError:(NSError*)error forRequest:(NSString*)requesrName extra:(id)extra{
    
    [appDelegate hideActivityWithError:error.localizedDescription];
}


@end
