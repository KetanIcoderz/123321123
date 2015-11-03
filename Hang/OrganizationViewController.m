//
//  OrganizationViewController.m
//  Hang
//
//  Created by iCoderz_Ankit on 10/9/15.
//  Copyright © 2015 iCoderz. All rights reserved.
//

#import "OrganizationViewController.h"
#import "OrganizationTableViewCell.h"
#import "OrganizationObject.h"

@interface OrganizationViewController ()<WebNetworkingDelegate>

@end

@implementation OrganizationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [appDelegate setMenuBarButtonInController:self];
    
    tblView.tableFooterView = [UIView new];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    
    array = [NSMutableArray new];
    [self getData];
}

- (void)getData
{
    
    [[WebNetworking new] sendRequestWithUrl:makeHangURL(GetFollowingOrganization)
                                 parameater:@{@"UserID":appDelegate.getUserObject.user_id}
                                   delegate:self
                            withRequestName:@"GetFollowingOrganization"];
    [appDelegate showActivityWithStatus:@"Getting Organization..."];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrganizationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL_Organization" forIndexPath:indexPath];
    
    OrganizationObject *obj = array[indexPath.row];
    
    cell.lbl_OrganizationName.text = obj.org_name;
    cell.lbl_OrganizationFollowers.text = [NSString stringWithFormat:@"Following: %@", obj.FollowersCount];
    
    cell.btn.layer.borderColor = [UIColor redColor].CGColor;
    
    if ([cell respondsToSelector:@selector(preservesSuperviewLayoutMargins)]) {
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.preservesSuperviewLayoutMargins = false;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    OrganizationObject *objOrganization = array[indexPath.row];
    
    [[WebNetworking new] sendRequestWithUrl:makeHangURL(FollowOrganization)
                                 parameater:@{@"UserID":appDelegate.getUserObject.user_id,
                                              @"OrganizationID":objOrganization.org_id,
                                              @"IsFollow":objOrganization.isFollowed?@"0":@"1"}
                                   delegate:self
                            withRequestName:@"FollowOrganization"
                                      extra:indexPath];

}

#pragma mark - WebNetworkingDelegate

- (void)webNetworkingSessionDidCompleteWithResult:(NSDictionary *)result forRequest:(NSString *)requesrName
{
    [appDelegate hideActivity];
    
    if([requesrName isEqualToString:@"GetFollowingOrganization"])//GetFollowingOrganization
    {
        
        if ([result[@"Status"] isEqualToString:@"TRUE"]) {
            
            NSArray *arrTemp = result[@"OrganizationDetail"];
            
            for (NSDictionary *dict in arrTemp) {
                
                OrganizationObject *objOrganization = [OrganizationObject new];
                objOrganization.org_id = dict[@"org_id"];
                objOrganization.org_creatorID = dict[@"org_creatorID"];
                objOrganization.org_name = dict[@"org_name"];
                objOrganization.org_detail = dict[@"org_detail"];
                objOrganization.org_dateCreated = dict[@"org_dateCreated"];
                objOrganization.FollowersCount = dict[@"FollowersCount"];
                objOrganization.org_isPrivate = [dict[@"org_isPrivate"] boolValue];
                objOrganization.org_allowToShare = [dict[@"org_allowToShare"] boolValue];
                objOrganization.org_isActive = [dict[@"org_isActive"] boolValue];
                objOrganization.isFollowed = [dict[@"MyFollowStatus"] boolValue];

                [array addObject:objOrganization];
            }
            
            NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"org_name" ascending:YES selector:@selector(caseInsensitiveCompare:)];
            [array sortUsingDescriptors:@[sd]];
            
            [tblView reloadData];
            
        }
        else{
            array = [NSMutableArray new];
            [tblView reloadData];
            
//            [appDelegate hideActivityWithError:result[@"Message"]];
        }
    }
}

- (void)webNetworkingSessionDidFailWithError:(NSError *)error forRequest:(NSString *)requesrName
{
    [appDelegate hideActivityWithError:error.localizedDescription];
}

#pragma mark extra

- (void)webNetworkingSessionDidCompleteWithResult:(NSDictionary*)result forRequest:(NSString*)requesrName extra:(id)extra{
    
    [appDelegate hideActivity];
    
    if ([requesrName isEqualToString:@"FollowOrganization"]) {
        
        if ([result[@"Status"] isEqualToString:@"TRUE"]) {
            
            NSIndexPath *indexPath = (NSIndexPath*)extra;
            ((OrganizationObject*)array[indexPath.row]).isFollowed = !((OrganizationObject*)array[indexPath.row]).isFollowed;
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
