//
//  GroupsViewController.m
//  Hang
//
//  Created by iCoderz_Ankit on 10/5/15.
//  Copyright © 2015 iCoderz. All rights reserved.
//

#import "GroupsViewController.h"
#import "GroupsTableViewCell.h"
#import "GroupObject.h"
#import "GroupMemberViewController.h"

@interface GroupsViewController ()<WebNetworkingDelegate>

@end

@implementation GroupsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [appDelegate setMenuBarButtonInController:self];
    
    tblView.tableFooterView = [UIView new];
    array = [NSMutableArray new];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [self getData];
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     
     if ([segue.identifier isEqualToString:@"groupMember"]) {

         NSIndexPath *index = [tblView indexPathForSelectedRow];
         GroupObject *objGroup = (GroupObject*)array[index.row];
         
         GroupMemberViewController *obj = (GroupMemberViewController*)[segue destinationViewController];
         obj.strGroupID = objGroup.group_id;
         obj.isOwner = [objGroup.group_creatorID isEqualToString:appDelegate.getUserObject.user_id];
         obj.title = objGroup.group_name;
         
     }
 }

#pragma mark -

-(void)getData{
    
    [array removeAllObjects];
    
    [[WebNetworking new] sendRequestWithUrl:makeHangURL(GetMyGroup)
                                 parameater:@{@"group_creatorID":appDelegate.getUserObject.user_id}
                                   delegate:self
                            withRequestName:@"GetMyGroup"];
    [appDelegate showActivityWithStatus:@"Getting groups.."];
    
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroupsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    GroupObject *objGroup = array[indexPath.row];
    
    cell.lbl.text = objGroup.group_name;
    [cell.btn addTarget:self action:@selector(selectMessage:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([objGroup.group_creatorID isEqualToString:appDelegate.getUserObject.user_id]) {
        cell.btn.hidden = NO;
    }
    else{
        cell.btn.hidden = YES;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
    
    if ([requesrName isEqualToString:@"GetMyGroup"]) {
        
        if ([result[@"Status"] isEqualToString:@"TRUE"]) {
            
            NSArray *arrTemp = result[@"GroupDetail"];
            
            for (NSDictionary *dict in arrTemp) {
                
                GroupObject *objGroup = [GroupObject new];
                objGroup.group_id = dict[@"group_id"];
                objGroup.group_name = dict[@"group_name"];
                objGroup.group_creatorID = dict[@"group_creatorID"];
                objGroup.group_dateCreated = dict[@"group_dateCreated"];
                objGroup.group_allowToInvite = dict[@"group_allowToInvite"];
                objGroup.group_isActive = dict[@"group_isActive"];
                objGroup.group_status = dict[@"group_status"];
                [array addObject:objGroup];
            }
            
            [tblView reloadData];
            
        }
        else{
            [appDelegate hideActivity];
            //            [appDelegate hideActivityWithError:result[@"Message"]];
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



@end
