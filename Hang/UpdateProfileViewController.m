//
//  UpdateProfileViewController.m
//  Hang
//
//  Created by iCoderz_Ankit on 9/17/15.
//  Copyright (c) 2015 iCoderz. All rights reserved.
//

#import "UpdateProfileViewController.h"

#import "UpdateProfileTableViewCell.h"
#import "MyProfileViewController.h"

@interface UpdateProfileViewController ()<UITextFieldDelegate,WebNetworkingDelegate,SDWebImageManagerDelegate>

@end

@implementation UpdateProfileViewController

@synthesize strValue,strKey;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = strKey;
    
//    [tblView setContentInset:UIEdgeInsetsMake(64, 0, 0, 0)];
    tblView.tableFooterView = [UIView new];
    
    toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    toolbar.items = @[
                      [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(doneClicked:)],
                      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:@selector(doneClicked:)],
                      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneClicked:)],
                      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:@selector(doneClicked:)],
                      [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(doneClicked:)]];
    
    [toolbar setBackgroundImage:[appDelegate imageWithColor:[UIColor colorWithRed:209.0/255.0 green:213.0/255.0 blue:219.0/255.0 alpha:1.0]] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    toolbar.tintColor = [UIColor blackColor];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    array = [NSMutableArray array];
    
    if ([strKey isEqualToString:@"Name"]) {
        [array addObject:@"Name"];
    }
    else if ([strKey isEqualToString:@"Mobile Number"]) {
        [array addObject:@"Mobile Number"];
    }
    else{
        [array addObject:@"Old Password ( ≥6 )"];
        [array addObject:@"New Password ( ≥6 )"];
        [array addObject:@"Confirm New Password ( ≥6 )"];
    }
    
}

-(void)viewDidLayoutSubviews{
    
    UpdateProfileTableViewCell *cell = (UpdateProfileTableViewCell*)[tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell.textField becomeFirstResponder];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)doneClicked:(id)sender{
    
    UITextField *tf = ((UpdateProfileTableViewCell*)[tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]).textField;
    if(tf.text.length > 0)[self textFieldShouldReturn:tf];
    
}

- (IBAction)textChange:(UITextField*)sender{
    
    if ([strKey isEqualToString:@"Password"])//Change Password
    {
        [sender setTextColor:(sender.text.isValidPassword)?[UIColor blackColor]:[UIColor redColor]];
    }
    else if ([strKey isEqualToString:@"Mobile Number"]){
        [sender setTextColor:(sender.text.length >= 10)?[UIColor blackColor]:[UIColor redColor]];
    }
    
}

#pragma mark - UItableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UpdateProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellBasic" forIndexPath:indexPath];
    
    cell.textField.delegate = self;
    cell.textField.tag = indexPath.row;
    cell.textField.placeholder = array[indexPath.row];
    [cell.textField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    
    if ([strKey isEqualToString:@"Name"]) {
        cell.textField.returnKeyType = UIReturnKeyDone;
        cell.textField.placeholder = array[indexPath.row];
        cell.textField.text = strValue;
    }
    else if ([strKey isEqualToString:@"Mobile Number"]) {
        cell.textField.returnKeyType = UIReturnKeyDone;
        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
        cell.textField.inputAccessoryView = toolbar;
        cell.textField.placeholder = array[indexPath.row];
        cell.textField.text = strValue;
    }
    else{
        
        cell.textField.secureTextEntry = YES;
        
        if (cell.textField.tag == 0)
        {
            cell.textField.returnKeyType = UIReturnKeyNext;
        }
        else if(cell.textField.tag == 1)
        {
            cell.textField.returnKeyType = UIReturnKeyNext;
        }
        else
        {
            cell.textField.returnKeyType = UIReturnKeyDone;
        }
    }
    
    if ([cell respondsToSelector:@selector(preservesSuperviewLayoutMargins)]){
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.preservesSuperviewLayoutMargins = false;
    }
    
    return cell;
}

#pragma mark - UITextField

- (BOOL)textFieldShouldReturn :(UITextField*)textFiled{
    
    if ([strKey isEqualToString:@"Name"]) {
//        obj.strName = textFiled.text;
//        [self.navigationController popViewControllerAnimated:YES];
        
        [textFiled resignFirstResponder];
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            [[WebNetworking new] sendRequestWithUrl:makeUserURL(UpdateProfile)
                                         parameater:@{@"FirstName":textFiled.text.emojiEncode,
                                                      @"MobileNo":appDelegate.getUserObject.user_mobileNo.emojiEncode,
                                                      @"UserID":appDelegate.getUserObject.user_id}
                                           delegate:self
                                    withRequestName:@"UpdateProfile-FirstName"];
            [appDelegate showActivity];
        });
        
        return YES;

        
    }
    else if ([strKey isEqualToString:@"Mobile Number"]) {
//        obj.strMobileNumber = textFiled.text;
//        [self.navigationController popViewControllerAnimated:YES];
        
        UITextField *tfOld = ((UpdateProfileTableViewCell*)[tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]).textField;
        if (tfOld.text.length < 10) {
            
            [UIView animateWithDuration:0.2 animations:^{
                tfOld.transform = CGAffineTransformMakeScale(1.05, 1.05);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.2 animations:^{
                    tfOld.transform = CGAffineTransformMakeScale(1.0, 1.0);
                }completion:^(BOOL finished) {
                    [tfOld becomeFirstResponder];
                }];
            }];
        }
        else{
            
            [textFiled resignFirstResponder];
            
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                
                [[WebNetworking new] sendRequestWithUrl:makeUserURL(UpdateProfile)
                                             parameater:@{@"FirstName":appDelegate.getUserObject.user_firstName.emojiEncode,
                                                          @"MobileNo":textFiled.text.emojiEncode,
                                                          @"UserID":appDelegate.getUserObject.user_id}
                                               delegate:self
                                        withRequestName:@"UpdateProfile-MobileNo"];
                [appDelegate showActivity];
            });

        }
        
        return YES;

    }
    else{
        
        if (textFiled.tag == 0) {
            
            UpdateProfileTableViewCell *cell = (UpdateProfileTableViewCell*)[tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            [cell.textField becomeFirstResponder];
        }
        else if (textFiled.tag == 1){
            
            UpdateProfileTableViewCell *cell = (UpdateProfileTableViewCell*)[tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
            [cell.textField becomeFirstResponder];
        }
        else{
            //Call web service
            
            UITextField *tfOld = ((UpdateProfileTableViewCell*)[tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]).textField;
            UITextField *tfNew = ((UpdateProfileTableViewCell*)[tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]]).textField;
            UITextField *tfConfirm = ((UpdateProfileTableViewCell*)[tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]]).textField;
            
            NSString *strOld = tfOld.text;
            NSString *strNew = tfNew.text;
            NSString *strConfirm = tfConfirm.text;
            
            if (!strOld.isValidPassword) {
                
                [UIView animateWithDuration:0.2 animations:^{
                    tfOld.transform = CGAffineTransformMakeScale(1.05, 1.05);
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.2 animations:^{
                        tfOld.transform = CGAffineTransformMakeScale(1.0, 1.0);
                    }completion:^(BOOL finished) {
                        [tfOld becomeFirstResponder];
                    }];
                }];

                [((UpdateProfileTableViewCell*)[tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]).textField becomeFirstResponder];
            }
            else if (!strNew.isValidPassword) {

                [UIView animateWithDuration:0.2 animations:^{
                    tfNew.transform = CGAffineTransformMakeScale(1.05, 1.05);
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.2 animations:^{
                        tfNew.transform = CGAffineTransformMakeScale(1.0, 1.0);
                    }completion:^(BOOL finished) {
                        [tfNew becomeFirstResponder];
                    }];
                }];
                
                [((UpdateProfileTableViewCell*)[tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]]).textField becomeFirstResponder];
            }
            else if(![strNew isEqualToString:strConfirm]){

                [UIView animateWithDuration:0.2 animations:^{
                    tfConfirm.transform = CGAffineTransformMakeScale(1.05, 1.05);
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.2 animations:^{
                        tfConfirm.transform = CGAffineTransformMakeScale(1.0, 1.0);
                    }completion:^(BOOL finished) {
                        [tfConfirm becomeFirstResponder];
                    }];
                }];

                [((UpdateProfileTableViewCell*)[tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]]).textField becomeFirstResponder];
            }
            else{
                
                [((UpdateProfileTableViewCell*)[tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]]).textField resignFirstResponder];
                
                [textFiled resignFirstResponder];
                [[WebNetworking new] sendRequestWithUrl:makeUserURL(ChangePassword)
                                             parameater:@{@"UserID":appDelegate.getUserObject.user_id,
                                                          @"OldPassword":strOld,
                                                          @"NewPassword":strNew}
                                               delegate:self
                                        withRequestName:@"ChangePassword"];
                [appDelegate showActivityWithStatus:@"Updating password.."];
                return YES;
            }
        }
        return YES;
    }
    
    return NO;
}

#pragma mark - WebNetworking Delegate

- (void)webNetworkingSessionDidCompleteWithResult:(NSDictionary*)result forRequest:(NSString*)requesrName{
    
    [appDelegate hideActivity];
    
    if ([requesrName isEqualToString:@"ChangePassword"]) {
        
        if ([result[@"Status"] isEqualToString:@"TRUE"]) {
            
            [appDelegate hideActivityWithSuccess:@"Password is changed successfully."];
            [self.navigationController popViewControllerAnimated:NO];
        }
        else{
            [appDelegate hideActivityWithInfo:result[@"Message"]];
            
            ((UpdateProfileTableViewCell*)[tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]).textField.text = @"";
            ((UpdateProfileTableViewCell*)[tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]]).textField.text = @"";
            ((UpdateProfileTableViewCell*)[tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]]).textField.text = @"";
            
            [((UpdateProfileTableViewCell*)[tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]).textField becomeFirstResponder];
        }
        
    }
    else if ([requesrName isEqualToString:@"UpdateProfile-MobileNo"] || [requesrName isEqualToString:@"UpdateProfile-FirstName"]) {
        
        if ([result[@"Status"] isEqualToString:@"TRUE"]) {
            
            UserObject *obj = appDelegate.getUserObject;
            obj.user_firstName = result[@"UserDetails"][@"user_firstName"];
            obj.user_mobileNo = result[@"UserDetails"][@"user_mobileNo"];
            [appDelegate saveUserObject:obj];
            
            MyProfileViewController *objProf = previousViewController;
            objProf.strMobileNumber = obj.user_mobileNo;
            objProf.strName = obj.user_firstName;
            
            [appDelegate hideActivityWithSuccess:@"Updated successfully."];
            [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:nil afterDelay:0.5];
        }
        else{
            
            [appDelegate hideActivityWithError:@"Somthing went wrong!\nPlease try again."];
        }
        
    }

}

- (void)webNetworkingSessionDidFailWithError:(NSError*)error forRequest:(NSString*)requesrName{
    
    [((UpdateProfileTableViewCell*)[tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]).textField becomeFirstResponder];
    [appDelegate hideActivityWithError:error.localizedDescription];
}


@end
