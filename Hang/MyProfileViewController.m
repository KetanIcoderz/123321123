//
//  MyProfileViewController.m
//  Hang
//
//  Created by iCoderz_Ankit on 9/10/15.
//  Copyright (c) 2015 iCoderz. All rights reserved.
//

#import "MyProfileViewController.h"

#import "UpdateProfileViewController.h"

@interface MyProfileViewController ()<WebNetworkingDelegate>

@end

@implementation MyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    arrayNames = [[NSMutableArray alloc]initWithObjects:@"Name",@"Username",@"Mobile Number",@"Email",@"Password", nil];
        
    tblView.tableFooterView = [UIView new];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"save"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(updateProfile:)];
    
    _strName = appDelegate.getUserObject.user_firstName;
    _strMobileNumber = appDelegate.getUserObject.user_mobileNo;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews{
    [tblView performSelector:@selector(reloadData) withObject:nil afterDelay:0.5];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    NSIndexPath *indexpath = (NSIndexPath*)sender;

    UpdateProfileViewController *obj = [segue destinationViewController];
    
    if (indexpath.row == 0) {
        obj.strKey = arrayNames[indexpath.row];
        obj.strValue = _strName;
    }
    else if (indexpath.row == 2) {
        obj.strKey = arrayNames[indexpath.row];
        obj.strValue = _strMobileNumber;
    }
    else
    {
        obj.strKey = arrayNames[indexpath.row];
    }
}


#pragma mark -

-(IBAction)updateProfile:(id)sender{
    
    [[WebNetworking new] sendRequestWithUrl:makeUserURL(UpdateProfile)
                                 parameater:@{@"FirstName":_strName.emojiEncode,
                                              @"MobileNo":_strMobileNumber.emojiEncode,
                                              @"UserID":appDelegate.getUserObject.user_id}
                                   delegate:self
                            withRequestName:@"UpdateProfile"];
    [appDelegate showActivity];
    
//    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITable view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrayNames.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell;
    
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cellBasic" forIndexPath:indexPath];
        cell.detailTextLabel.text = _strName;
    }
    else if (indexPath.row == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cellCustom" forIndexPath:indexPath];
        cell.detailTextLabel.text = appDelegate.getUserObject.user_name;
        cell.accessoryView = [UIView new];
    }
    else if (indexPath.row == 2) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cellBasic" forIndexPath:indexPath];
        cell.detailTextLabel.text = _strMobileNumber;;
    }
    else if (indexPath.row == 3) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cellBasic" forIndexPath:indexPath];
        cell.detailTextLabel.text = appDelegate.getUserObject.user_email;
        cell.accessoryView = [UIView new];
    }
    else if (indexPath.row == 4) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cellBasic" forIndexPath:indexPath];
        cell.detailTextLabel.text = @"●●●●●●●●";
    }
    
    cell.textLabel.text = arrayNames[indexPath.row];
    
    if ([cell respondsToSelector:@selector(preservesSuperviewLayoutMargins)]){
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.preservesSuperviewLayoutMargins = false;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 4) {
        [self performSegueWithIdentifier:@"update" sender:indexPath];
    }
    
}

#pragma mark - WebNetworking Delegate

- (void)webNetworkingSessionDidCompleteWithResult:(NSDictionary*)result forRequest:(NSString*)requesrName{
    
    if ([requesrName isEqualToString:@"UpdateProfile"]) {
     
        if ([result[@"Status"] isEqualToString:@"TRUE"]) {
            
            UserObject *obj = appDelegate.getUserObject;
            obj.user_firstName = result[@"UserDetails"][@"user_firstName"];
            obj.user_mobileNo = result[@"UserDetails"][@"user_mobileNo"];
            [appDelegate saveUserObject:obj];
            
            [appDelegate hideActivityWithSuccess:@"Updated successfully."];
        }
        else{
            
            [appDelegate hideActivityWithError:@"Somthing went wrong!\nPlease try again."];
        }
        
    }
}

- (void)webNetworkingSessionDidFailWithError:(NSError*)error forRequest:(NSString*)requesrName{
    
    [appDelegate hideActivityWithError:error.localizedDescription];
}

@end
