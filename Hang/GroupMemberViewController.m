//
//  GroupMemberViewController.m
//  Calender
//
//  Created by iCoderz_Binal on 25/09/15.
//  Copyright © 2015 iCoderz. All rights reserved.
//

#import "GroupMemberViewController.h"
#import "GroupMemberTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "AddMemberViewController.h"

@interface GroupMemberViewController ()<WebNetworkingDelegate>

@end

@implementation GroupMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [appDelegate setBackbuttonIfNeededInController:self];
    
    tblView.tableFooterView = [UIView new];
    array = [NSMutableArray new];
    
    if (!self.isOwner)//if not Owner
    {
        self.navigationItem.rightBarButtonItem = nil;
        [btnDelete setTitle:@"Leave Group" forState:UIControlStateNormal];
    }
    else{
        [btnDelete setTitle:@"Delete Group" forState:UIControlStateNormal];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"addOtherMember"]) {
        
        AddMemberViewController *objAddMem = (AddMemberViewController*)[segue destinationViewController];
        objAddMem.strGroupID = self.strGroupID;
        objAddMem.arrGroupMember = [self getOnlyUserIDOfMember];
        objAddMem.title = self.title;
    }
}

-(void)viewDidAppear:(BOOL)animated{
    
    [array removeAllObjects];
    
    [self getData];
}

#pragma mark - 

-(NSMutableArray*)getOnlyUserIDOfMember{
    
    NSMutableArray *arr = [NSMutableArray new];
    for (UserObject *obj in array) {
        [arr addObject:obj.user_id];
    }
    return arr;
}

-(IBAction)DeleteGroup{
    
    if (!self.isOwner)//if not Owner
    {
        //Leave Group
        
        [[WebNetworking new] sendRequestWithUrl:makeHangURL(LeaveGroup)
                                     parameater:@{@"GroupID":self.strGroupID,
                                                  @"UserID":appDelegate.getUserObject.user_id}
                                       delegate:self
                                withRequestName:@"LeaveGroup"];
        [appDelegate showActivityWithStatus:@"Leaving group.."];

        
    }
    else
    {
        //Delete Group
        
        [[WebNetworking new] sendRequestWithUrl:makeHangURL(DeleteGroup)
                                     parameater:@{@"group_id":self.strGroupID,
                                                  @"group_creatorID":appDelegate.getUserObject.user_id}
                                       delegate:self
                                withRequestName:@"DeleteGroup"];
        [appDelegate showActivityWithStatus:@"Deleting group.."];

        
    }
    
}

-(void)getData{
    
    [[WebNetworking new] sendRequestWithUrl:makeHangURL(GetGroupMember)
                                 parameater:@{@"GroupID":self.strGroupID}
                                   delegate:self
                            withRequestName:@"GetGroupMember"];
    [appDelegate showActivityWithStatus:@"Getting group member.."];
    
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroupMemberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    UserObject *objUser = array[indexPath.row];
    
    cell.lbl.text = [appDelegate setNameOfUserFromFirstName:objUser.user_firstName andUserName:objUser.user_name];
    [cell.img setImageWithURL:[NSURL URLWithString:objUser.user_profilePictureURL]];
    [cell.btn addTarget:self action:@selector(selectMessage:) forControlEvents:UIControlEventTouchUpInside];

    if (!self.isOwner) {
        cell.btn.hidden = YES;
        cell.btnWidth.constant = 0;
    }
    else{
        cell.btn.hidden = NO;
        cell.btnWidth.constant = 80;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (!self.isOwner) {
        return;
    }
    else{
        
        UserObject *objUser = array[indexPath.row];
        
        [[WebNetworking new] sendRequestWithUrl:makeHangURL(LeaveGroup)
                                     parameater:@{@"GroupID":self.strGroupID,
                                                  @"UserID":objUser.user_id}
                                       delegate:self
                                withRequestName:@"RemoveFromGroup"
                                          extra:indexPath];
        [appDelegate showActivityWithStatus:@"Removing from group.."];

    }

    
}

#pragma mark - Event Message
- (void)selectMessage:(UIButton *)sender
{
    CGPoint touchPoint = [sender convertPoint:CGPointZero toView:tblView];
    NSIndexPath *indexPath = [tblView indexPathForRowAtPoint:touchPoint];
    NSLog(@"indexPath : %@", indexPath);
}

#pragma mark - WebNetworking Delegate

- (void)webNetworkingSessionDidCompleteWithResult:(NSDictionary*)result forRequest:(NSString*)requesrName{
    
    [appDelegate hideActivity];
    
    if ([requesrName isEqualToString:@"GetGroupMember"]) {
        
        if ([result[@"Status"] isEqualToString:@"TRUE"]) {
            
            NSArray *arrTemp = result[@"GroupMember"];
            
            for (NSDictionary *dict in arrTemp) {
                    
                UserObject *objUser = [UserObject new];
                objUser.user_id = dict[@"user_id"];
                objUser.user_name = dict[@"user_name"];
                objUser.user_firstName = dict[@"user_firstName"];
                objUser.user_profilePictureURL = dict[@"user_profilePictureURL"];
                
                [array addObject:objUser];
            }
            
            NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"user_firstName" ascending:YES selector:@selector(caseInsensitiveCompare:)];
            [array sortUsingDescriptors:@[sd]];
            
            [tblView reloadData];
            
        }
        else{
            [appDelegate hideActivity];
            //            [appDelegate hideActivityWithError:result[@"Message"]];
        }
        
    }
    else if ([requesrName isEqualToString:@"DeleteGroup"]) {
        
        if ([result[@"Status"] isEqualToString:@"TRUE"]) {
            
            [self.navigationController popViewControllerAnimated:YES];
            [appDelegate hideActivityWithSuccess:@"Group deleted successfully."];
        }
        else{
            [appDelegate hideActivityWithError:result[@"Message"]];
        }
        
    }
    else if ([requesrName isEqualToString:@"LeaveGroup"]) {
        
        if ([result[@"Status"] isEqualToString:@"TRUE"]) {
            
            [self.navigationController popViewControllerAnimated:YES];
            [appDelegate hideActivityWithSuccess:@"Group leaved successfully."];
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
    
    [appDelegate hideActivity];
}

#pragma mark extra

- (void)webNetworkingSessionDidCompleteWithResult:(NSDictionary*)result forRequest:(NSString*)requesrName extra:(id)extra{
    
    [appDelegate hideActivity];
    
    if ([requesrName isEqualToString:@"RemoveFromGroup"]) {
        
        if ([result[@"Status"] isEqualToString:@"TRUE"]) {
            
            [appDelegate hideActivityWithSuccess:@"Removed from group successfully."];
            
            NSIndexPath *indexPath = (NSIndexPath*)extra;
            [array removeObjectAtIndex:indexPath.row];
            [tblView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
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

- (void)webNetworkingSessionDidFailWithError:(NSError*)error forRequest:(NSString*)requesrName extra:(id)extra{
    
    [appDelegate hideActivityWithError:error.localizedDescription];
}




@end
