//
//  InviteViewController.m
//  Hang
//
//  Created by iCoderz_Ankit on 10/2/15.
//  Copyright © 2015 iCoderz. All rights reserved.
//

#import "InviteViewController.h"
#import "ShareWithTableViewCell.h"

@interface InviteViewController () <WebNetworkingDelegate>

@end

@implementation InviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [appDelegate setBackbuttonIfNeededInController:self];
    
    arrFriend = [NSMutableArray new];
    arrSelectedFriend = [NSMutableArray new];
    arrGroup = [NSMutableArray new];
    arrSelectedGroup = [NSMutableArray new];
    
    tblView.tableFooterView = [UIView new];
    tblView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
    
    [self setNumber];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    if (self.isGroup) {
        [sc setSelectedSegmentIndex:1];
    }
    else{
        [sc setSelectedSegmentIndex:0];
    }
    
}

-(void)viewDidAppear:(BOOL)animated{
    [self segmentChanged:sc];
    
}

-(void)setNumber{
    
    [sc setTitle:[NSString stringWithFormat:@"Friends (%lu)",(unsigned long)arrSelectedFriend.count] forSegmentAtIndex:0];
    [sc setTitle:[NSString stringWithFormat:@"Groups (%lu)",(unsigned long)arrSelectedGroup.count] forSegmentAtIndex:1];
}

- (IBAction)segmentChanged:(UISegmentedControl*)sender{
    
    if (sc.selectedSegmentIndex == 0) {
        [self GetMyFriends];
    }
    else
    {
        [self GetMyGroup];
    }
    
}

- (IBAction)share:(id)sender{
    
    if (arrSelectedFriend.count == 0 && arrSelectedGroup == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    [[WebNetworking new] sendRequestWithUrl:makeHangURL(ShareEvent)
                                 parameater:@{@"UserID":appDelegate.getUserObject.user_id,
                                              @"EventID":self.objEvent.event_id,
                                              @"FriendID":arrSelectedFriend,
                                              @"GroupID":arrSelectedGroup}
                                   delegate:self
                            withRequestName:@"ShareEvent"];
    [appDelegate showActivityWithStatus:@"Sharing with \nFriends/Groups.."];
    
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
    return (sc.selectedSegmentIndex == 0)?arrFriend.count:arrGroup.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShareWithTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    NSMutableArray *arrTemp = (sc.selectedSegmentIndex == 0)?arrFriend:arrGroup;
    NSMutableArray *arrSelectedTemp = (sc.selectedSegmentIndex == 0)?arrSelectedFriend:arrSelectedGroup;
    
    cell.btn.selected = [arrSelectedTemp containsObject:arrTemp[indexPath.row][@"id"]];
    cell.lbl.text = arrTemp[indexPath.row][@"name"];
    cell.btn.layer.borderColor = cell.btn.selected?[UIColor colorWithRed:252.0/255.0 green:102.0/255.0 blue:33.0/255.0 alpha:0.9].CGColor:[UIColor colorWithRed:65.0/255.0 green:125.0/255.0 blue:177.0/255.0 alpha:0.9].CGColor;
    [cell.img setImageWithURL:[NSURL URLWithString:arrTemp[indexPath.row][@"avatar"]]];
    
    if ([cell respondsToSelector:@selector(preservesSuperviewLayoutMargins)]) {
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.preservesSuperviewLayoutMargins = false;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (sc.selectedSegmentIndex == 0) {
        
        if ([arrSelectedFriend containsObject:arrFriend[indexPath.row][@"id"]])
        {
            [arrSelectedFriend removeObject:arrFriend[indexPath.row][@"id"]];
        }
        else
        {
            [arrSelectedFriend addObject:arrFriend[indexPath.row][@"id"]];
        }
        
    }
    else{
        
        if ([arrSelectedGroup containsObject:arrGroup[indexPath.row][@"id"]])
        {
            [arrSelectedGroup removeObject:arrGroup[indexPath.row][@"id"]];
        }
        else
        {
            [arrSelectedGroup addObject:arrGroup[indexPath.row][@"id"]];
        }
        
    }
    
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self setNumber];
}

- (void)GetMyFriends
{
    
    if (arrFriend.count > 0) {
        [tblView reloadData];
        return;
    }
    
    [[WebNetworking new] sendRequestWithUrl:makeHangURL(GetMyFriends)
                                 parameater:@{@"UserID":appDelegate.getUserObject.user_id}
                                   delegate:self
                            withRequestName:@"GetMyFriends"];
    [appDelegate showActivityWithStatus:@"Getting Friends..."];

    
}

- (void)GetMyGroup
{
    if (arrGroup.count > 0) {
        [tblView reloadData];
        return;
    }
    
    [[WebNetworking new] sendRequestWithUrl:makeHangURL(GetMyGroup)
                                 parameater:@{@"group_creatorID":appDelegate.getUserObject.user_id}
                                   delegate:self
                            withRequestName:@"GetMyGroup"];
    [appDelegate showActivityWithStatus:@"Getting Groups..."];
}

#pragma mark - WebNetworkingDelegate

- (void)webNetworkingSessionDidCompleteWithResult:(NSDictionary *)result forRequest:(NSString *)requesrName
{
    if([requesrName isEqualToString:@"GetMyFriends"])//GetMyFriends
    {
        if ([result[@"Status"] isEqualToString:@"TRUE"])
        {
            [arrFriend removeAllObjects];
            for (NSDictionary *dict in result[@"UserDetails"])
            {
                [arrFriend addObject:@{
                                   @"id":dict[@"user_id"],
                                   @"name":[appDelegate setNameOfUserFromFirstName:dict[@"user_firstName"] andUserName:dict[@"user_name"]],
                                   @"avatar":dict[@"user_profilePictureURL"]
                                   }];
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
    else if([requesrName isEqualToString:@"GetMyGroup"])//GetMyGroup
    {
        if ([result[@"Status"] isEqualToString:@"TRUE"])
        {
            [arrGroup removeAllObjects];
            for (NSDictionary *dict in result[@"GroupDetail"])
            {
                [arrGroup addObject:@{
                                   @"id":dict[@"group_id"],
                                   @"name":dict[@"group_name"],
                                   @"avatar":@"",
                                   }];
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
    else if([requesrName isEqualToString:@"ShareEvent"])
    {
        if ([result[@"Status"] isEqualToString:@"TRUE"])
        {
            [appDelegate hideActivityWithSuccess:@"Event shared successfully."];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [appDelegate hideActivityWithError:result[@"Message"]];
        }
    }
}

- (void)webNetworkingSessionDidFailWithError:(NSError *)error forRequest:(NSString *)requesrName
{
    [appDelegate hideActivityWithError:error.localizedDescription];
}


@end
