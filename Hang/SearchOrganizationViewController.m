//
//  SearchOrganizationViewController.m
//  Hang
//
//  Created by iCoderz_Ankit on 10/9/15.
//  Copyright © 2015 iCoderz. All rights reserved.
//

#import "SearchOrganizationViewController.h"
#import "OrganizationTableViewCell.h"
#import "OrganizationObject.h"

@interface SearchOrganizationViewController ()<UISearchBarDelegate,WebNetworkingDelegate>

@end

@implementation SearchOrganizationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [appDelegate setBackbuttonIfNeededInController:self];
    
    array = [NSMutableArray new];
    tblView.tableFooterView = [UIView new];
    
    [self.navigationItem.rightBarButtonItem setTarget:self];
    [self.navigationItem.rightBarButtonItem setAction:@selector(close)];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)close{
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - SearchBar

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [sBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    
    [array removeAllObjects];
    [tblView reloadData];
    
    if (searchBar.text.length == 0) {
        return;
    }
    
    [wn stopRequest];
    wn = [WebNetworking new];
    
    [wn sendRequestWithUrl:makeHangURL(SearchOrganization)
                                 parameater:@{@"UserID":appDelegate.getUserObject.user_id,
                                              @"SearchText":searchBar.text}
                                   delegate:self
                            withRequestName:@"SearchOrganization"];
//    [appDelegate showActivityWithStatus:@"Searching.."];

    
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrganizationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL_Organization" forIndexPath:indexPath];
    
    OrganizationObject *obj = array[indexPath.row];
    
    cell.lbl_OrganizationName.text = obj.org_name;
    
    NSString *str1 = [NSString stringWithFormat:@"Following: %@",obj.FollowersCount];
    NSString *str2 = [NSString stringWithFormat:@"(%@ Friends)",obj.mutualCount];
    NSString *strMain = [NSString stringWithFormat:@"%@ %@", str1,str2];
    
    NSMutableAttributedString *strAtt = [[NSMutableAttributedString alloc]initWithString:strMain];
    
    [strAtt setAttributes:@{NSForegroundColorAttributeName:kOrangeColor} range:[strMain rangeOfString:str2]];
    
    cell.lbl_OrganizationFollowers.attributedText = strAtt;
    
    cell.btn.layer.borderColor = obj.isFollowed?[UIColor redColor].CGColor:kBlueColor.CGColor;
    [cell.btn setTitleColor:obj.isFollowed?[UIColor redColor]:kBlueColor forState:UIControlStateNormal];
    [cell.btn setTitle:obj.isFollowed?@"Unfollow":@"Follow" forState:UIControlStateNormal];
    
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
//    [appDelegate hideActivity];
    
    if([requesrName isEqualToString:@"SearchOrganization"])//SearchOrganization
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
                objOrganization.mutualCount = dict[@"MyFriendsCount"];

                [array addObject:objOrganization];
            }
            
            NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"org_name" ascending:YES selector:@selector(caseInsensitiveCompare:)];
            [array sortUsingDescriptors:@[sd]];
            
            [tblView reloadData];
            
        }
        else{
            [appDelegate hideActivity];
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
            [tblView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
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
