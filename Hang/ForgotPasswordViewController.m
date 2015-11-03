//
//  ForgotPasswordViewController.m
//  Hang
//
//  Created by iCoderz_Ankit on 10/5/15.
//  Copyright © 2015 iCoderz. All rights reserved.
//

#import "ForgotPasswordViewController.h"

@interface ForgotPasswordViewController ()<WebNetworkingDelegate>

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"Bello Pro" size:24.0]}];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self.navigationItem.rightBarButtonItem setTarget:self];
    [self.navigationItem.rightBarButtonItem setAction:@selector(close)];

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

-(IBAction)Check:(id)sender{
    
    [tfUsername resignFirstResponder];
    
    [[WebNetworking new] sendRequestWithUrl:makeUserURL(ForgotPassword)
                                 parameater:@{@"Email":tfUsername.text.emojiEncode}
                                   delegate:self
                            withRequestName:@"ForgotPassword"];
    [appDelegate showActivityWithStatus:@"Checking for \nUsername/Email address.."];
    
}

-(void)close{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UItextField Delgate

- (IBAction)textChange:(id)sender{
    
    if (tfUsername.text.length == 0) {
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
        [appDelegate hideActivityWithSuccess:@"Please check email and follow instruction."];
        [self close];
    }
    else{
        [appDelegate hideActivityWithError:result[@"Message"]];
    }
}

-(void)webNetworkingSessionDidFailWithError:(NSError *)error forRequest:(NSString *)requesrName{
    
    [appDelegate hideActivityWithSuccess:error.localizedDescription];
    
}



@end
