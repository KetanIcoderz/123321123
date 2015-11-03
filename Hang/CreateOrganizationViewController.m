//
//  CreateOrganizationViewController.m
//  Hang
//
//  Created by iCoderz_Ankit on 10/8/15.
//  Copyright © 2015 iCoderz. All rights reserved.
//

#import "CreateOrganizationViewController.h"

@interface CreateOrganizationViewController () <WebNetworkingDelegate>

@end

@implementation CreateOrganizationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationItem.leftBarButtonItem setTarget:self];
    [self.navigationItem.leftBarButtonItem setAction:@selector(close)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"save"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    
    txt_OrganizationName.layer.borderColor = [[UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1.0] CGColor];
    txt_OrganizationName.layer.borderWidth = 1.0;
    
    txt_OrganizationName.leftViewMode = UITextFieldViewModeAlways;
    txt_OrganizationName.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    
    txt_OrganizationName.rightViewMode = UITextFieldViewModeAlways;
    txt_OrganizationName.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    
    txtVw_OrganizationDesc.layer.borderColor = [[UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1.0] CGColor];
    txtVw_OrganizationDesc.layer.borderWidth = 1.0;
    
    lbl_Status.text = @"Public";
    [swt_PublicPrivate setOn:YES];
    
    lbl = [[UILabel alloc]initWithFrame:CGRectMake(10 , -5.5, txtVw_OrganizationDesc.frame.size.width, 52)];
    lbl.text = @"Enter Organization Description";
    lbl.font = [UIFont fontWithName:kFontOpenSans size:16.0];
    lbl.textColor = [UIColor colorWithWhite:0.78 alpha:1.0];
    lbl.backgroundColor = [UIColor clearColor];
    
    txtVw_OrganizationDesc.textContainerInset = UIEdgeInsetsMake(10, 5, 0, 0);
    [txtVw_OrganizationDesc addSubview:lbl];
    
    [txt_OrganizationName setValue:[UIColor colorWithWhite:0.78 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];

    
    toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    toolbar.items = @[
                      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneClicked:)]];
    
    [toolbar setBackgroundImage:[appDelegate imageWithColor:[UIColor colorWithRed:252.0/255.0 green:102.0/255.0 blue:33.0/255.0 alpha:0.8]] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    toolbar.tintColor = [UIColor whiteColor];
    txtVw_OrganizationDesc.inputAccessoryView = toolbar;

    btnSave = self.navigationItem.rightBarButtonItem;
    
    if (self.objOrganization) {
        txt_OrganizationName.text = self.objOrganization.org_name;
        txtVw_OrganizationDesc.text = self.objOrganization.org_detail;
        [swt_PublicPrivate setOn:self.objOrganization.org_isPrivate animated:NO];

        [self switchValueChanged:swt_PublicPrivate];
        [self textViewDidChange:txtVw_OrganizationDesc];
        
        self.navigationItem.rightBarButtonItem = nil;
        
        self.title = @"Edit Organization";
        
    }
    
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

- (void)doneClicked:(UIBarButtonItem*)btn{
    
    [txtVw_OrganizationDesc resignFirstResponder];
    
}

- (IBAction)switchValueChanged:(UISwitch *)sender
{
    if (self.objOrganization) {
        self.navigationItem.rightBarButtonItem = btnSave;
    }
    
    if(sender.isOn)
    {
        lbl_Status.text = @"Public";
    }
    else
    {
        lbl_Status.text = @"Private";
    }
}

- (void)close{
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)save{
    
    if (txt_OrganizationName.text.length == 0)
    {
        [UIView animateWithDuration:0.2 animations:^{
            txt_OrganizationName.transform = CGAffineTransformMakeScale(1.05, 1.05);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                txt_OrganizationName.transform = CGAffineTransformMakeScale(1.0, 1.0);
            }completion:^(BOOL finished) {
                [txt_OrganizationName becomeFirstResponder];
            }];
        }];
    }
    else if (txtVw_OrganizationDesc.text.length == 0)
    {
        [UIView animateWithDuration:0.2 animations:^{
            txtVw_OrganizationDesc.transform = CGAffineTransformMakeScale(1.05, 1.05);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                txtVw_OrganizationDesc.transform = CGAffineTransformMakeScale(1.0, 1.0);
            }completion:^(BOOL finished) {
                [txtVw_OrganizationDesc becomeFirstResponder];
            }];
        }];
    }
    else{
        
        [txt_OrganizationName resignFirstResponder];
        [txtVw_OrganizationDesc resignFirstResponder];
        
        if (self.objOrganization)//Update
        {
            
            [[WebNetworking new] sendRequestWithUrl:makeHangURL(EditOrganization)
                                         parameater:@{@"org_id":self.objOrganization.org_id,
                                                      @"org_name":txt_OrganizationName.text.emojiEncode,
                                                      @"org_detail":txtVw_OrganizationDesc.text.emojiEncode,
                                                      @"org_creatorID":appDelegate.getUserObject.user_id,
                                                      @"org_isPrivate":swt_PublicPrivate.isOn?@"1":@"0"}
                                           delegate:self
                                    withRequestName:@"EditOrganization"];
            [appDelegate showActivityWithStatus:@"Updating Organization.."];

            
        }
        else//Create
        {
            
            [[WebNetworking new] sendRequestWithUrl:makeHangURL(CreateOrganization)
                                         parameater:@{@"org_name":txt_OrganizationName.text.emojiEncode,
                                                      @"org_detail":txtVw_OrganizationDesc.text.emojiEncode,
                                                      @"org_creatorID":appDelegate.getUserObject.user_id,
                                                      @"org_isPrivate":swt_PublicPrivate.isOn?@"0":@"1"}
                                           delegate:self
                                    withRequestName:@"CreateOrganization"];
            [appDelegate showActivityWithStatus:@"Creating Organization.."];

        }
    }
    
}

- (void)textViewDidChange:(UITextView *)textView{
    
    if (self.objOrganization) {
        self.navigationItem.rightBarButtonItem = btnSave;
    }
    
    lbl.hidden = (textView.text.length == 0)?NO:YES;
}

#pragma mark - UITextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (self.objOrganization) {
        self.navigationItem.rightBarButtonItem = btnSave;
    }

    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;

}

#pragma mark - WebNetworking Delegate

- (void)webNetworkingSessionDidCompleteWithResult:(NSDictionary*)result forRequest:(NSString*)requesrName{
    
    [appDelegate hideActivity];
    
    if ([requesrName isEqualToString:@"CreateOrganization"]) {
        
        if ([result[@"Status"] isEqualToString:@"TRUE"]) {
            
            [appDelegate hideActivityWithSuccess:@"Organization created successfully."];
            txt_OrganizationName.text = @"";
            txtVw_OrganizationDesc.text = @"";
            [swt_PublicPrivate setOn:YES animated:YES];
            [self close];
        }
        else{
            
            [appDelegate hideActivityWithError:result[@"Message"]];
        }
        
    }
    if ([requesrName isEqualToString:@"EditOrganization"]) {
        
        if ([result[@"Status"] isEqualToString:@"TRUE"]) {
            
            [appDelegate hideActivityWithSuccess:@"Organization updated successfully."];
            txt_OrganizationName.text = @"";
            txtVw_OrganizationDesc.text = @"";
            [swt_PublicPrivate setOn:YES animated:YES];
            [self close];
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
