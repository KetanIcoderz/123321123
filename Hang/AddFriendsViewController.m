//
//  AddFriendsViewController.m
//  Calender
//
//  Created by iCoderz_Binal on 26/09/15.
//  Copyright © 2015 iCoderz_Binal. All rights reserved.
//

#import "AddFriendsViewController.h"
#import "AddFriendsTableViewCell.h"
//#import "ListFriendsViewController.h"

@interface AddFriendsViewController ()

@end

@implementation AddFriendsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [appDelegate setBackbuttonIfNeededInController:self];
    
    arr_CellTitle = [@[@"Add from Address Book", @"Add by Username", @"Facebook Invite"] mutableCopy];
    arr_CellImages = [@[@"iAddressbook", @"iSearch", @"iFb"] mutableCopy];
    
    tblView.tableFooterView = [UIView new];
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
    
//    if([segue.identifier isEqualToString:@"SearchAddressbook"])
//    {
//        ListFriendsViewController *con = segue.destinationViewController;
//        con.nFromIndex = 1;
//    }
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arr_CellTitle.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddFriendsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.lblName.text = arr_CellTitle[indexPath.row];
    cell.img.image = [UIImage imageNamed:arr_CellImages[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0://Add from Addressbook
            [self performSegueWithIdentifier:@"AddFromContact" sender:self];
            break;
            
        case 1://Add by Username
            [self performSegueWithIdentifier:@"AddByUserName" sender:self];
            break;
            
        case 2://Facebook Invite
            [self performSegueWithIdentifier:@"AddByFacebookInvite" sender:self];
            break;
            
        default:
            break;
    }
}

@end
