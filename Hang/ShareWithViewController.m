//
//  ShareWithViewController.m
//  Hang
//
//  Created by iCoderz_Ankit on 9/21/15.
//  Copyright (c) 2015 iCoderz. All rights reserved.
//

#import "ShareWithViewController.h"

#import "ShareWithTableViewCell.h"
#import "CreateEventViewController.h"
#import "EventDetailViewController.h"

#define errorUnknown @"Sorry! Something went wrong,Please try again."

@interface ShareWithViewController ()<WebNetworkingDelegate>

@end

@implementation ShareWithViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationItem.rightBarButtonItem setTarget:self];
    [self.navigationItem.rightBarButtonItem setAction:@selector(done)];
    
    [self.navigationItem.leftBarButtonItem setTarget:self];
    [self.navigationItem.leftBarButtonItem setAction:@selector(cancel)];
    
    
//    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 24)];
//    btn.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.3];
//    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
//    btn.layer.cornerRadius = btn.frame.size.height/2;
//    btn.layer.masksToBounds = YES;
//    [btn setTitleColor:[UIColor colorWithRed:252.0/255.0 green:102.0/255.0 blue:33.0/255.0 alpha:1.0] forState:UIControlStateNormal];
//    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
//    array = [NSMutableArray arrayWithArray:@[@{@"id":@"1",@"name":@"Ankit"},@{@"id":@"2",@"name":@"Raju"},@{@"id":@"3",@"name":@"Ketan"}]];
    
    array = [NSMutableArray new];
    
    
    if (!self.arraySelected) {
        self.arraySelected = [NSMutableArray new];
    }
    
    tblView.tableFooterView = [UIView new];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    
    if (self.isFriend) {
        self.title = @"Add Friends to Share";
    }
    else{
        self.title = @"Add Groups to Share";
    }
    
    [self setNumber];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (self.isFriend) {
        [self GetMyFriends];
    }
    else{
        [self GetMyGroup];
    }

}

-(void)setNumber{
    
//    UIButton *btn = (UIButton*)self.navigationItem.leftBarButtonItem.customView;
//    [btn setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)self.arraySelected.count] forState:UIControlStateNormal];
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

-(void)cancel{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)done{
    
    CreateEventViewController *obj = (CreateEventViewController*)[((UINavigationController*)((SWRevealViewController*)[((UINavigationController*)self.presentingViewController).viewControllers lastObject]).frontViewController).viewControllers lastObject];
    
    if (self.isFriend) {
        obj.arrFriend = self.arraySelected;
    }
    else{
        obj.arrGroup = self.arraySelected;
    }
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}


-(void)remove{
    
    UIView *v = [appDelegate.window viewWithTag:5000];
    
    [v removeFromSuperview];
    
}
#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    ShareWithTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.btn.selected = [self.arraySelected containsObject:array[indexPath.row][@"id"]];
    cell.lbl.text = array[indexPath.row][@"name"];
    cell.btn.layer.borderColor = cell.btn.selected?[UIColor colorWithRed:252.0/255.0 green:102.0/255.0 blue:33.0/255.0 alpha:0.9].CGColor:[UIColor colorWithRed:65.0/255.0 green:125.0/255.0 blue:177.0/255.0 alpha:0.9].CGColor;
    [cell.img setImageWithURL:[NSURL URLWithString:array[indexPath.row][@"avatar"]]];

    if ([cell respondsToSelector:@selector(preservesSuperviewLayoutMargins)]) {
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.preservesSuperviewLayoutMargins = false;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.arraySelected containsObject:array[indexPath.row][@"id"]])
    {
        [self.arraySelected removeObject:array[indexPath.row][@"id"]];
    }
    else
    {
        [self.arraySelected addObject:array[indexPath.row][@"id"]];
    }
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self setNumber];
}

- (void)GetMyFriends
{
//    http://mobappbuddy.com/icoderz_dev/phpwork/manoj/Hang/webservice/HangServices.php?action=GetMyFriends
//    {"UserID":"c383dea8-6064-11e5-8558-002590d1d110"}
    
    [[WebNetworking new] sendRequestWithUrl:makeHangURL(GetMyFriends)
                                 parameater:@{@"UserID":appDelegate.getUserObject.user_id}
                                   delegate:self
                            withRequestName:@"GetMyFriends"];
    [appDelegate showActivityWithStatus:@"Getting Friends..."];
}

- (void)GetMyGroup
{
//    http://mobappbuddy.com/icoderz_dev/phpwork/manoj/Hang/webservice/HangServices.php?action=GetMyGroup
//    {"group_creatorID":"c383dea8-6064-11e5-8558-002590d1d110"}
    
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
            [array removeAllObjects];
            for (NSDictionary *dict in result[@"UserDetails"])
            {
                [array addObject:@{
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
        }

    }
    else if([requesrName isEqualToString:@"GetMyGroup"])//GetMyGroup
    {
        if ([result[@"Status"] isEqualToString:@"TRUE"])
        {
            [array removeAllObjects];
            for (NSDictionary *dict in result[@"GroupDetail"])
            {
                [array addObject:@{
                                   @"id":dict[@"group_id"],
                                   @"name":dict[@"group_name"],
                                   @"avatar":@"http://mobappbuddy.com/icoderz_dev/phpwork/manoj/Hang/webservice/Profile_Image/",
                                   }];
            }
            NSLog(@"array : %@", array);
            [appDelegate hideActivity];
            [tblView reloadData];
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
    [appDelegate hideActivity];
}

@end
