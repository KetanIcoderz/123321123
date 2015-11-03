//
//  AddMemberViewController.m
//  Hang
//
//  Created by iCoderz_Ankit on 9/21/15.
//  Copyright (c) 2015 iCoderz. All rights reserved.
//

#import "AddMemberViewController.h"

#import "ShareWithTableViewCell.h"
#import "CreateEventViewController.h"

#define errorUnknown @"Sorry! Something went wrong,Please try again."

@interface AddMemberViewController ()<WebNetworkingDelegate>

@end

@implementation AddMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"save"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(close)];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Back"] style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(popViewControllerAnimated:)];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 24)];
    btn.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn.layer.cornerRadius = btn.frame.size.height/2;
    btn.layer.masksToBounds = YES;
    [btn setTitleColor:[UIColor colorWithRed:252.0/255.0 green:102.0/255.0 blue:33.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    btnCount = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    self.navigationItem.leftBarButtonItems = @[backButtonItem,btnCount];
        
    array = [NSMutableArray new];
    
    if (!arraySelected) {
        arraySelected = [NSMutableArray new];
    }
    
    if (!self.arrGroupMember) {
        self.arrGroupMember = [NSMutableArray new];
    }
    
    tblView.tableFooterView = [UIView new];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
        
    [self setNumber];
}

- (void)viewDidAppear:(BOOL)animated
{
    [[WebNetworking new] sendRequestWithUrl:makeHangURL(GetMyFriends)
                                 parameater:@{@"UserID":appDelegate.getUserObject.user_id}
                                   delegate:self
                            withRequestName:@"GetMyFriends"];
    [appDelegate showActivityWithStatus:@"Getting Friends..."];
    
}

-(void)setNumber{
    
    UIButton *btn = (UIButton*)btnCount.customView;
    [btn setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)arraySelected.count+self.arrGroupMember.count] forState:UIControlStateNormal];
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

-(void)close{
    
    [[WebNetworking new] sendRequestWithUrl:makeHangURL(InviteGroupMembers)
                                 parameater:@{@"GroupID":self.strGroupID,
                                              @"ApplicationUser":arraySelected}
                                   delegate:self
                            withRequestName:@"InviteGroupMembers"];
    [appDelegate showActivityWithStatus:@"Adding member.."];

}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    ShareWithTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    UserObject *objUser = array[indexPath.row];
    
    cell.btn.selected = [arraySelected containsObject:objUser.user_id] | [self.arrGroupMember containsObject:objUser.user_id];
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
    
    if (![self.arrGroupMember containsObject:objUser.user_id]) {
        
        if ([arraySelected containsObject:objUser.user_id])
        {
            [arraySelected removeObject:objUser.user_id];
        }
        else
        {
            [arraySelected addObject:objUser.user_id];
        }
        
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self setNumber];
        
    }
    
}

#pragma mark - WebNetworkingDelegate

- (void)webNetworkingSessionDidCompleteWithResult:(NSDictionary *)result forRequest:(NSString *)requesrName
{
    if([requesrName isEqualToString:@"GetMyFriends"])//GetMyFriends
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
    else if([requesrName isEqualToString:@"InviteGroupMembers"])//InviteGroupMembers
    {
        if ([result[@"Status"] isEqualToString:@"TRUE"])
        {
            if (self.navigationController.presentingViewController)//While creating group
            {
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }
            else//While adding Other Member from group member listing page
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
            
            [appDelegate hideActivityWithSuccess:@"Friend add to group successfully."];
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
