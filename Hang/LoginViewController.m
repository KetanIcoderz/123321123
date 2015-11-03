//
//  LoginViewController.m
//  Hang
//
//  Created by iCoderz_Ankit on 9/9/15.
//  Copyright (c) 2015 iCoderz. All rights reserved.
//

#import "LoginViewController.h"

#import "MenuViewController.h"
#import "MyCalendarViewController.h"

#define errorWrongPassword @"Sorry! You have entered an invalid username/password."
#define errorUnknown @"Sorry! Something went wrong,Please try again."

@interface LoginViewController ()<SWRevealViewControllerDelegate,WebNetworkingDelegate>

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"Bello Pro" size:24.0]}];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [appDelegate setBackbuttonIfNeededInController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(IBAction)Login:(id)sender{
    
    [tfUsername resignFirstResponder];
    [tfPassword resignFirstResponder];
    
    [[WebNetworking new] sendRequestWithUrl:makeUserURL(Login)
                                 parameater:@{@"user_name":tfUsername.text.emojiEncode,
                                              @"user_Password":tfPassword.text.emojiEncode}
                                   delegate:self
                            withRequestName:@"Login"];
    [appDelegate showActivityWithStatus:@"Logging in ..."];
    
}

-(void)showErrorWithMessage:(NSString *)strMessage{
    
    lblError.text = strMessage;
    
    [UIView animateWithDuration:0.2 animations:^{
        lblError.transform = CGAffineTransformMakeScale(1.05, 1.05);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            lblError.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }completion:^(BOOL finished) {
            [lblError becomeFirstResponder];
        }];
    }];
}

-(void)success{
    
    UINavigationController *navMenu = [self.storyboard instantiateViewControllerWithIdentifier:@"navMenu"];
    UINavigationController *navFront = [self.storyboard instantiateViewControllerWithIdentifier:@"navCalendar"];
    
    appDelegate.revealController = [[SWRevealViewController alloc] initWithRearViewController:navMenu frontViewController:navFront];
    //    appDelegate.revealController.delegate = self;
    appDelegate.revealController.bounceBackOnOverdraw = NO;
    appDelegate.revealController.bounceBackOnLeftOverdraw = NO;
    appDelegate.revealController.frontViewShadowRadius = 0.2;
    appDelegate.revealController.rearViewRevealWidth = appDelegate.window.bounds.size.width*2/3;
    
    [self.navigationController pushViewController:appDelegate.revealController animated:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}


#pragma mark - UItextField Delgate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    lblError.text = @"";
    return YES;
}

- (IBAction)textChange:(id)sender{
    
    if (tfUsername.text.length == 0 || tfPassword.text.length == 0) {
        btnLogin.hidden = YES;
    }
    else{
        btnLogin.hidden = NO;
    }

}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    CGFloat height = keyboardHeight;
    height += btnLogin.frame.size.height;
    //    20 : By default Constraint value
    CGFloat top = self.view.frame.size.height - height + 20 - textField.frame.size.height*2 - 10;
    
    CGFloat moveSpace = top - textField.frame.origin.y ;
    
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:(7 << 16)
                     animations:^{
                         topSpace.constant = moveSpace;
                         [self.view layoutIfNeeded];
                     }completion:^(BOOL finished) {
                     }];
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:(7 << 16)
                     animations:^{
                         topSpace.constant = 20;
                         [self.view layoutIfNeeded];
                     }completion:^(BOOL finished) {
                     }];
    
}


- (BOOL)textFieldShouldReturn:(UITextField*)textfield{
    
    [textfield resignFirstResponder];
    return YES;
}

#pragma mark - UIkeyboard Notification

- (void)keyboardWillShow:(NSNotification*)notification

{
    NSDictionary *userInfo = notification.userInfo;
    
    NSNumber *durationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration = durationValue.doubleValue;
    
    NSNumber *curveValue = userInfo[UIKeyboardAnimationCurveUserInfoKey];
    UIViewAnimationCurve animationCurve = curveValue.intValue;
    
    NSValue* keyboardFrameEnd = [userInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect rect = [keyboardFrameEnd CGRectValue];
    
    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:(animationCurve << 16)
                     animations:^{
                         bottomMargin.constant = rect.size.height;
                         [btnLogin layoutIfNeeded];
                     }completion:^(BOOL finished) {
                     }];
}

- (void)keyboardWillHide:(NSNotification*)notification{
    
    NSDictionary *userInfo = notification.userInfo;
    
    NSNumber *durationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration = durationValue.doubleValue;
    
    NSNumber *curveValue = userInfo[UIKeyboardAnimationCurveUserInfoKey];
    UIViewAnimationCurve animationCurve = curveValue.intValue;
    
    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:(animationCurve << 16)
                     animations:^{
                         bottomMargin.constant = 0;
                         [btnLogin layoutIfNeeded];
                     }completion:nil];
    
}

#pragma mark - WebNetworkingDelegate

-(void)webNetworkingSessionDidCompleteWithResult:(NSDictionary *)result forRequest:(NSString *)requesrName{
    
    if ([result[@"Status"] isEqualToString:@"TRUE"]) {
        
        UserObject *obj = [UserObject new];
        obj.user_acccessToken = result[@"UserDetails"][@"user_acccessToken"];
        obj.user_deviceInfo = result[@"UserDetails"][@"user_deviceInfo"];
        obj.user_email = result[@"UserDetails"][@"user_email"];
        obj.user_facebookSync = result[@"UserDetails"][@"user_facebookSync"];
        obj.user_firstName = result[@"UserDetails"][@"user_firstName"];
        obj.user_id = result[@"UserDetails"][@"user_id"];
        obj.user_isBlocked = result[@"UserDetails"][@"user_isBlocked"];
        obj.user_isPrivate = result[@"UserDetails"][@"user_isPrivate"];
        obj.user_lastChange = result[@"UserDetails"][@"user_lastChange"];
        obj.user_lastLogin = result[@"UserDetails"][@"user_lastLogin"];
        obj.user_lastName = result[@"UserDetails"][@"user_lastName"];
        obj.user_mobileNo = result[@"UserDetails"][@"user_mobileNo"];
        obj.user_name = result[@"UserDetails"][@"user_name"];
        obj.user_osVersion = result[@"UserDetails"][@"user_osVersion"];
        obj.user_profilePictureURL = result[@"UserDetails"][@"user_profilePictureURL"];
        obj.user_RegDate = result[@"UserDetails"][@"user_RegDate"];
        obj.user_type = result[@"UserDetails"][@"user_type"];
        [appDelegate saveUserObject:obj];
        
        [self success];
        [appDelegate hideActivityWithSuccess:[NSString stringWithFormat:@"Welcome %@",[appDelegate setNameOfUserFromFirstName:obj.user_firstName andUserName:obj.user_name]]];
    }
    else{
    
        [self showErrorWithMessage:result[@"Message"]];
        [appDelegate hideActivityWithError:result[@"Message"]];
    }
}

-(void)webNetworkingSessionDidFailWithError:(NSError *)error forRequest:(NSString *)requesrName{
    
    [appDelegate hideActivityWithError:error.localizedDescription];
    [self showErrorWithMessage:errorUnknown];
    
}



@end
