//
//  NotificationViewController.m
//  Hang
//
//  Created by iCoderz_Ankit on 9/11/15.
//  Copyright (c) 2015 iCoderz. All rights reserved.
//

#import "NotificationViewController.h"

@interface NotificationViewController ()

@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    arrayNames0 = [[NSMutableArray alloc]initWithObjects:@"All Friends’ Events",@"Customize Friends’ Notifications",@"All Groups’ Events",@"Customize Groups’ Notifications",@"All Organizations’ Events",@"Customize Organizations’ Notifications", nil];
    arrayNames1 = [[NSMutableArray alloc]initWithObjects:@"Notification for each message",@"1 Notification per chat", nil];
    
    swAllFriends = [UISwitch new];
    swAllGroup = [UISwitch new];
    swMessage = [UISwitch new];
    swChat = [UISwitch new];
    
//    [tblView setContentInset:UIEdgeInsetsMake(64, 0, 0, 0)];
    tblView.tableFooterView = [UIView new];
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

#pragma mark - UItableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return arrayNames0.count;
    }
    else{
        return arrayNames1.count;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tblView.frame.size.width, 60)];
    view.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.9];
    
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(15, 30, tblView.frame.size.width-30, 30)];
    lbl.font = [UIFont systemFontOfSize:20.0 weight:0.2];
    lbl.textColor = [UIColor colorWithRed:65.0/255.0 green:125.0/255.0 blue:177.0/255.0 alpha:1.0];
    [view addSubview:lbl];
    
    if (section == 0) {
        lbl.text = @"CALENDAR";
    }
    else{
        lbl.text = @"CHAT";
    }
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell;
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cellCustom" forIndexPath:indexPath];
        cell.accessoryView = swAllFriends;
    }
    else if (indexPath.section == 0 && indexPath.row == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cellBasic" forIndexPath:indexPath];
    }
    else if (indexPath.section == 0 && indexPath.row == 2) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cellCustom" forIndexPath:indexPath];
        cell.accessoryView = swAllGroup;
    }
    else if (indexPath.section == 0 && indexPath.row == 3) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cellBasic" forIndexPath:indexPath];
    }
    else if (indexPath.section == 0 && indexPath.row == 4) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cellBasic" forIndexPath:indexPath];
    }
    else if (indexPath.section == 0 && indexPath.row == 5) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cellBasic" forIndexPath:indexPath];
    }
    else if (indexPath.section == 1 && indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cellCustom" forIndexPath:indexPath];
        cell.accessoryView = swMessage;
    }
    else if (indexPath.section == 1 && indexPath.row == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cellCustom" forIndexPath:indexPath];
        cell.accessoryView = swChat;
    }
    
    cell.textLabel.text = (indexPath.section == 0)?arrayNames0[indexPath.row]:arrayNames1[indexPath.row];
    
    if ([cell respondsToSelector:@selector(preservesSuperviewLayoutMargins)]){
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.preservesSuperviewLayoutMargins = false;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
//        [self performSegueWithIdentifier:@"myProfile" sender:nil];
    }
}

@end
