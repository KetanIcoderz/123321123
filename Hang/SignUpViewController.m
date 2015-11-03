//
//  SignUpViewController.m
//  Hang
//
//  Created by iCoderz_Ankit on 9/9/15.
//  Copyright (c) 2015 iCoderz. All rights reserved.
//

#import "SignUpViewController.h"

#import "PostSignUpViewController.h"
#import <sys/utsname.h>

@interface SignUpViewController () <UITextViewDelegate,WebNetworkingDelegate>

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"Bello Pro" size:24.0]}];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

//    By creating an account, you agree to the Terms of Use
//    and you acknowledge that you have read the Privacy Policy.
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineSpacing = 2;
//    paragraph.minimumLineHeight = 30.0f;
//    paragraph.maximumLineHeight = 30.0f;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"By creating an account, you agree to the Terms of Use and you acknowledge that you have read the Privacy Policy."];
    [attributedString setAttributes:@{NSParagraphStyleAttributeName: paragraph} range:NSMakeRange(0, attributedString.length)];
    
    [attributedString addAttribute:NSLinkAttributeName
                             value:@"tag1://"
                             range:[[attributedString string] rangeOfString:@"Terms of Use"]];
    
    [attributedString addAttribute:NSLinkAttributeName
                             value:@"tag2://"
                             range:[[attributedString string] rangeOfString:@"Privacy Policy"]];
    
    
    NSDictionary *linkAttributes = @{NSForegroundColorAttributeName: [UIColor colorWithRed:252.0/255.0 green:102./255.0 blue:33.0/255.0 alpha:1.0]};
    
    tvTerm.linkTextAttributes = linkAttributes; // customizes the appearance of links
    tvTerm.attributedText = attributedString;
    tvTerm.delegate = self;
    tvTerm.font = [UIFont systemFontOfSize:12.0];
    
    [appDelegate setBackbuttonIfNeededInController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"registrationSuccess"]) {
        
        PostSignUpViewController *obj = [segue destinationViewController];
        obj.strUserID = (NSString*)sender;
    }
}


#pragma mark - UItextView Delegate

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    
    if ([[URL scheme] isEqualToString:@"tag1"]) {
        [self performSegueWithIdentifier:@"termOfUser" sender:nil];
    }
    else if ([[URL scheme] isEqualToString:@"tag2"]){
        [self performSegueWithIdentifier:@"privacyPolicy" sender:nil];
    }
    return NO;
}

-(IBAction)SignUp:(id)sender{
    
    if (!tfEmail.text.isValidEmail) {
        
        [UIView animateWithDuration:0.2 animations:^{
            tfEmail.transform = CGAffineTransformMakeScale(1.05, 1.05);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                tfEmail.transform = CGAffineTransformMakeScale(1.0, 1.0);
            }completion:^(BOOL finished) {
                [tfEmail becomeFirstResponder];
            }];
        }];
    }
//    if (tfMobileNo.text.length < 10) {
//        
//        [UIView animateWithDuration:0.2 animations:^{
//            tfEmail.transform = CGAffineTransformMakeScale(1.05, 1.05);
//        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:0.2 animations:^{
//                tfEmail.transform = CGAffineTransformMakeScale(1.0, 1.0);
//            }completion:^(BOOL finished) {
//                [tfEmail becomeFirstResponder];
//            }];
//        }];
//    }

    else if (tfUsername.text.length < 4) {
        
        [UIView animateWithDuration:0.2 animations:^{
            tfUsername.transform = CGAffineTransformMakeScale(1.05, 1.05);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                tfUsername.transform = CGAffineTransformMakeScale(1.0, 1.0);
            }completion:^(BOOL finished) {
                [tfUsername becomeFirstResponder];
            }];
        }];
    }

    else if (!tfPassword.text.isValidPassword) {
        
        [UIView animateWithDuration:0.2 animations:^{
            tfPassword.transform = CGAffineTransformMakeScale(1.05, 1.05);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                tfPassword.transform = CGAffineTransformMakeScale(1.0, 1.0);
            }completion:^(BOOL finished) {
                [tfPassword becomeFirstResponder];
            }];
        }];
    }
//    else if (!tfConfirm.text.isValidPassword) {
//        
//        [UIView animateWithDuration:0.2 animations:^{
//            tfConfirm.transform = CGAffineTransformMakeScale(1.05, 1.05);
//        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:0.2 animations:^{
//                tfConfirm.transform = CGAffineTransformMakeScale(1.0, 1.0);
//            }completion:^(BOOL finished) {
//                [tfConfirm becomeFirstResponder];
//            }];
//        }];
//    }
//    else if (![tfPassword.text isEqualToString:tfConfirm.text]) {
//        
//        [UIView animateWithDuration:0.2 animations:^{
//            tfConfirm.transform = CGAffineTransformMakeScale(1.05, 1.05);
//        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:0.2 animations:^{
//                tfConfirm.transform = CGAffineTransformMakeScale(1.0, 1.0);
//            }completion:^(BOOL finished) {
//                tfConfirm.text = @"";
//                [tfConfirm becomeFirstResponder];
//            }];
//        }];
//    }
    else{
        
        [tfUsername resignFirstResponder];
        [tfPassword resignFirstResponder];
        [tfEmail resignFirstResponder];
//        [tfName resignFirstResponder];
//        [tfMobileNo resignFirstResponder];
        
        NSString *deviceType;
        struct utsname systemInfo;
        uname(&systemInfo);
        deviceType = [NSString stringWithCString:systemInfo.machine
                                        encoding:NSUTF8StringEncoding];
        
        NSMutableDictionary *dictData = [NSMutableDictionary dictionaryWithDictionary:@{@"user_firstName":@"".emojiEncode,
                                                                       @"user_Name":tfUsername.text.emojiEncode,
                                                                       @"user_email":tfEmail.text.emojiEncode,
                                                                       @"user_Password":tfPassword.text.emojiEncode,
                                                                       @"user_type":@"0",
                                                                       @"user_facebookSync":@"1",
                                                                       @"user_mobileNo":@"".emojiEncode,
                                                                       @"user_osVersion":[[UIDevice currentDevice] systemVersion],
                                                                       @"user_deviceInfo":deviceType}];

        
        [[WebNetworking new] sendRequestWithUrl:makeUserURL(Registration)
                                     parameater:dictData
                                       delegate:self
                                withRequestName:@"Registration"];
        [appDelegate showActivityWithStatus:@"Signing Up.."];

    }
    
    
}

#pragma mark - UItextField Delgate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    return YES;
}

- (IBAction)textChange:(id)sender{
    
    if (tfUsername.text.length == 0 || tfPassword.text.length == 0 || tfEmail.text.length == 0) {
        btnSignUp.hidden = YES;
    }
    else{
        btnSignUp.hidden = NO;
    }
    
    [tfEmail setTextColor:(tfEmail.text.isValidEmail)?[UIColor blackColor]:[UIColor redColor]];
    [tfPassword setTextColor:(tfPassword.text.isValidPassword)?[UIColor blackColor]:[UIColor redColor]];
//    [tfConfirm setTextColor:(tfConfirm.text.isValidPassword && [tfConfirm.text isEqualToString:tfPassword.text])?[UIColor blackColor]:[UIColor redColor]];
    [tfUsername setTextColor:(tfUsername.text.length >= 4)?[UIColor blackColor]:[UIColor redColor]];
//    [tfMobileNo setTextColor:(tfMobileNo.text.length >= 10)?[UIColor blackColor]:[UIColor redColor]];
    
}

- (BOOL)textFieldShouldReturn:(UITextField*)textfield{
    
    [textfield resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    CGFloat height = keyboardHeight;
    height += btnSignUp.frame.size.height;
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
                         [btnSignUp layoutIfNeeded];
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
                         [btnSignUp layoutIfNeeded];
                     }completion:nil];
    
}


#pragma mark - WebNetworking

-(void)webNetworkingSessionDidCompleteWithResult:(NSDictionary *)result forRequest:(NSString *)requesrName{
    
    [appDelegate hideActivity];
    
    if ([requesrName isEqualToString:@"Registration"])
    {
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
            
            [self performSegueWithIdentifier:@"registrationSuccess" sender:obj.user_id];
        }
        else{
            
            [appDelegate hideActivityWithError:result[@"Message"]];
        }
    }
    else
    {
        [appDelegate hideActivity];
        
        if ([result[@"Status"] isEqualToString:@"TRUE"]) {
            
        }
        else{
            
        }
        
    }
}

-(void)webNetworkingSessionDidFailWithError:(NSError *)error forRequest:(NSString *)requesrName{
    
    [appDelegate hideActivityWithError:error.localizedDescription];
    
}


@end
