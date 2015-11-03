//
//  RequestViewController.m
//  Hang
//
//  Created by iCoderz_Ankit on 10/8/15.
//  Copyright © 2015 iCoderz. All rights reserved.
//

#import "RequestViewController.h"
#import "RequestTableViewCell.h"

@interface RequestViewController ()<WebNetworkingDelegate>

@end

@implementation RequestViewController

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

- (void)viewDidAppear:(BOOL)animated{
    [self getData];
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
    
    [[WebNetworking new] sendRequestWithUrl:makeHangURL(GetMyInvitations)
                                 parameater:@{@"UserID":appDelegate.getUserObject.user_id}
                                   delegate:self
                            withRequestName:@"GetMyInvitations"];
    [appDelegate showActivityWithStatus:@"Getting requests.."];
    
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RequestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    NSDictionary *dict = array[indexPath.row];
    
    NSMutableAttributedString *attString;
    
    if ([dict[@"InviteType"] isEqualToString:@"F"]) {
        NSString *str = [NSString stringWithFormat:@"%@ would like to be your friend.",dict[@"SenderName"]];
        attString = [[NSMutableAttributedString alloc]initWithString:str];
        [attString setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16.0]} range:NSMakeRange(0, [dict[@"SenderName"] length])];

    }
    else{
        
        NSString *str = [NSString stringWithFormat:@"%@ want to add you in %@ oraganization.",dict[@"SenderName"],dict[@"OrganizationName"]];
        attString = [[NSMutableAttributedString alloc]initWithString:str];
        [attString setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16.0]} range:NSMakeRange(0, [dict[@"SenderName"] length])];
        [attString setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16.0]} range:[str rangeOfString:dict[@"OrganizationName"]]];
        
    }
    
    cell.lbl.attributedText = attString;
    [cell.img setImageWithURL:[NSURL URLWithString:dict[@"ProfilePicture"]]];

    cell.btnAccept.tag = indexPath.row;
    [cell.btnAccept addTarget:self action:@selector(Accept:) forControlEvents:UIControlEventTouchUpInside];

    cell.btnReject.tag = indexPath.row;
    [cell.btnReject addTarget:self action:@selector(Reject:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - Action
- (void)Accept:(UIButton *)sender
{
    
    CGPoint touchPoint = [sender convertPoint:CGPointZero toView:tblView];
    NSIndexPath *indexPath = [tblView indexPathForRowAtPoint:touchPoint];
    
    [[WebNetworking new] sendRequestWithUrl:makeHangURL(ResponceInvitation)
                                 parameater:@{@"UserID":appDelegate.getUserObject.user_id,
                                              @"SenderID":array[indexPath.row][@"SenderID"],
                                              @"InviteType":array[indexPath.row][@"InviteType"],
                                              @"OrganizationID":array[indexPath.row][@"OrganizationID"],
                                              @"ResponceStatus":@"1"}
                                   delegate:self
                            withRequestName:@"Response"
                                      extra:indexPath];
    
}

- (void)Reject:(UIButton *)sender
{
    
    CGPoint touchPoint = [sender convertPoint:CGPointZero toView:tblView];
    NSIndexPath *indexPath = [tblView indexPathForRowAtPoint:touchPoint];
    
    [[WebNetworking new] sendRequestWithUrl:makeHangURL(ResponceInvitation)
                                 parameater:@{@"UserID":appDelegate.getUserObject.user_id,
                                              @"SenderID":array[indexPath.row][@"SenderID"],
                                              @"InviteType":array[indexPath.row][@"InviteType"],
                                              @"OrganizationID":array[indexPath.row][@"OrganizationID"],
                                              @"ResponceStatus":@"0"
                                              }
                                   delegate:self
                            withRequestName:@"Response"
                                      extra:indexPath];
}

#pragma mark - WebNetworking Delegate

- (void)webNetworkingSessionDidCompleteWithResult:(NSDictionary*)result forRequest:(NSString*)requesrName{
    
    [appDelegate hideActivity];
    
    if ([requesrName isEqualToString:@"GetMyInvitations"]) {
        
        if ([result[@"Status"] isEqualToString:@"TRUE"]) {
            
            array = [NSMutableArray arrayWithArray:result[@"Invitation"]];
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
    
    [appDelegate hideActivityWithError:error.localizedDescription];
}

#pragma mark - WebNetworking Extra Delegate

- (void)webNetworkingSessionDidCompleteWithResult:(NSDictionary*)result forRequest:(NSString*)requesrName extra:(NSIndexPath*)extra{
    [appDelegate hideActivity];
    
    if ([requesrName isEqualToString:@"Response"]) {
        
        if ([result[@"Status"] isEqualToString:@"TRUE"]) {
            
            [array removeObjectAtIndex:extra.row];
            [tblView deleteRowsAtIndexPaths:@[extra] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        else{
            [appDelegate hideActivityWithError:result[@"Message"]];
        }
    }

}
- (void)webNetworkingSessionDidFailWithError:(NSError*)error forRequest:(NSString*)requesrName extra:(id)extra{
    [appDelegate hideActivityWithError:error.localizedDescription];
}




@end
