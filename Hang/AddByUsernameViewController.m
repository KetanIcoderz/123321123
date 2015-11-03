//
//  AddByUsernameViewController.m
//  Hang
//
//  Created by iCoderz_Ankit on 10/1/15.
//  Copyright © 2015 iCoderz. All rights reserved.
//

#import "AddByUsernameViewController.h"

@interface AddByUsernameViewController () <WebNetworkingDelegate>

@end

@implementation AddByUsernameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [appDelegate setBackbuttonIfNeededInController:self];
    
    tfUsername.layer.borderColor = [UIColor colorWithRed:151.0/255.0 green:151.0/255.0 blue:151.0/255.0 alpha:1.0].CGColor;
    tfUsername.layer.borderWidth = 1.0;
    
    viewAdd = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 78, 30)];
    viewAdd.backgroundColor = [UIColor clearColor];
    
    UIButton *btnAdd = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70, 30)];
    [btnAdd setTitle:@"Add" forState:UIControlStateNormal];
    [btnAdd.titleLabel setFont:[UIFont fontWithName:kFontOpenSans size:14.0]];
    [btnAdd setTitleColor:kBlueColor forState:UIControlStateNormal];
    btnAdd.layer.borderWidth = 1.0;
    btnAdd.layer.cornerRadius = 4.0;
    btnAdd.layer.borderColor = kBlueColor.CGColor;

    [btnAdd addTarget:self action:@selector(addUser) forControlEvents:UIControlEventTouchUpInside];
    [viewAdd addSubview:btnAdd];
    
    tfUsername.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, tfUsername.frame.size.height)];
    tfUsername.leftViewMode = UITextFieldViewModeAlways;
    
    tfUsername.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, tfUsername.frame.size.height)];
    tfUsername.rightViewMode = UITextFieldViewModeAlways;
    
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

- (void)addUser{
    
    [tfUsername resignFirstResponder];
    
    [[WebNetworking new] sendRequestWithUrl:makeHangURL(AddFriendByUsername)
                                 parameater:@{@"UserID":appDelegate.getUserObject.user_id,
                                              @"SearchUserName":tfUsername.text.emojiEncode}
                                   delegate:self
                            withRequestName:@"AddFriendByUsername"];
    [appDelegate showActivityWithStatus:@"Checking for username.."];
}

#pragma mark - UITextField Delegate

- (IBAction)textChanged:(UITextField*)textField{
    
    if (textField.text.length > 0) {
        tfUsername.rightView = viewAdd;
    }
    else{
        tfUsername.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, tfUsername.frame.size.height)];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField{
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - WebNetworking Delegate

- (void)webNetworkingSessionDidCompleteWithResult:(NSDictionary*)result forRequest:(NSString*)requesrName{
    
    
    if ([requesrName isEqualToString:@"AddFriendByUsername"]) {
        
        if ([result[@"Status"] isEqualToString:@"TRUE"]) {
            
            [appDelegate hideActivityWithSuccess:@"Friend request sent successfully."];
            if([tfUsername isFirstResponder])[tfUsername resignFirstResponder];
            tfUsername.text = @"";
        }
        else{
            [appDelegate hideActivityWithError:result[@"Message"]];
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


@end
