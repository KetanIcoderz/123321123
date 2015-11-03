//
//  AddFriendsViewController.m
//  Calender
//
//  Created by iCoderz_Binal on 25/09/15.
//  Copyright © 2015 iCoderz_Binal. All rights reserved.
//

#import "FriendsViewController.h"
#import "FriendTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@interface FriendsViewController ()<WebNetworkingDelegate>

@end

@implementation FriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [appDelegate setMenuBarButtonInController:self];
    
    tblView.tableFooterView = [UIView new];
    array = [NSMutableArray new];
    
    [self getData];
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
#pragma mark - 

-(void)getData{
    
    [[WebNetworking new] sendRequestWithUrl:makeHangURL(GetMyFriends)
                                 parameater:@{@"UserID":appDelegate.getUserObject.user_id}
                                   delegate:self
                            withRequestName:@"GetMyFriends"];
    [appDelegate showActivityWithStatus:@"Getting friends.."];
    
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    UserObject *objUser = array[indexPath.row];
    
    cell.lbl.text = [appDelegate setNameOfUserFromFirstName:objUser.user_firstName andUserName:objUser.user_name];
    [cell.img setImageWithURL:[NSURL URLWithString:objUser.user_profilePictureURL]];
    [cell.btn addTarget:self action:@selector(selectMessage:) forControlEvents:UIControlEventTouchUpInside];
    
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
    
    if ([requesrName isEqualToString:@"GetMyFriends"]) {
        
        if ([result[@"Status"] isEqualToString:@"TRUE"]) {
            
            NSArray *arrTemp = result[@"UserDetails"];
            
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
