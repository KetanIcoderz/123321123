//
//  CreatGroupViewController.m
//  Hang
//
//  Created by iCoderz_Ankit on 10/6/15.
//  Copyright © 2015 iCoderz. All rights reserved.
//

#import "CreatGroupViewController.h"

#import "AddMemberViewController.h"

@interface CreatGroupViewController () <WebNetworkingDelegate>

@end

@implementation CreatGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [appDelegate setBackbuttonIfNeededInController:self];
    
    [self.navigationItem.rightBarButtonItem setTarget:self];
    [self.navigationItem.rightBarButtonItem setAction:@selector(close)];
    
    tfUsername.layer.borderColor = [UIColor colorWithRed:151.0/255.0 green:151.0/255.0 blue:151.0/255.0 alpha:1.0].CGColor;
    tfUsername.layer.borderWidth = 1.0;
    
    viewAdd = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 78, 30)];
    viewAdd.backgroundColor = [UIColor clearColor];
    
    UIButton *btnAdd = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70, 30)];
    [btnAdd setTitle:@"Create" forState:UIControlStateNormal];
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"addMember"]) {
        AddMemberViewController *obj = [segue destinationViewController];
        obj.title = tfUsername.text;
        obj.strGroupID = (NSString*)sender;
    }
    
}


- (void)addUser{
    
    if([tfUsername isFirstResponder])
        [tfUsername resignFirstResponder];
    
    [[WebNetworking new] sendRequestWithUrl:makeHangURL(CreateGroup)
                                 parameater:@{@"UserID":appDelegate.getUserObject.user_id,
                                              @"GroupName":tfUsername.text.emojiEncode}
                                   delegate:self
                            withRequestName:@"CreateGroup"];
    [appDelegate showActivityWithStatus:@"Creating group.."];
}

-(void)close{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
    
    
    if ([requesrName isEqualToString:@"CreateGroup"]) {
        
        if ([result[@"Status"] isEqualToString:@"TRUE"]) {
            
            [appDelegate hideActivityWithSuccess:@"Group created successfully.\n Please add member to this group."];
            [self performSegueWithIdentifier:@"addMember" sender:result[@"GroupID"]];
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
