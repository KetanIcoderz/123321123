//
//  OrganizationDetailViewController.m
//  Calender
//
//  Created by iCoderz_Binal on 29/09/15.
//  Copyright © 2015 iCoderz_Binal. All rights reserved.
//

#import "OrganizationDetailViewController.h"

#import "AddMemberToOrgViewController.h"
#import "AddFacebookInvitesController.h"

@interface OrganizationDetailViewController ()<WebNetworkingDelegate>

@end

@implementation OrganizationDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [appDelegate setBackbuttonIfNeededInController:self];
    
    arr_Options = [@[@"Invite My Friends", @"Invite Friends Using Facebook", @"Remove Organization"] mutableCopy];
    arr_OptionImages = [@[@"Invite.", @"iFb", @"Cancel"] mutableCopy];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = self.objOrganization.org_name;
    
    lbl_OrganizationName.text = self.objOrganization.org_name;
    lbl_OrganizationFollow.text = [NSString stringWithFormat:@"Following: %@", self.objOrganization.FollowersCount];

    txtVw_Description.text = self.objOrganization.org_detail;
    txtVw_Description.layer.borderColor = [UIColor lightGrayColor].CGColor;
    txtVw_Description.layer.borderWidth = 1.0;
    
    [swt_Organization setOn:self.objOrganization.org_isPrivate animated:NO];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews{
    
    CGFloat expectedHeight = [txtVw_Description sizeThatFits:CGSizeMake(txtVw_Description.frame.size.width, btn_GotoCalendar.frame.origin.y - txtVw_Description.frame.origin.x - 16)].height;

    CGFloat idelaHeight = btn_GotoCalendar.frame.origin.y - txtVw_Description.frame.origin.y - 16;
    CGFloat heightToSet = MIN(expectedHeight, idelaHeight);
    
    conHeight.constant = MAX(heightToSet, 130);
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"InviteMyFriends"]) {
        
        AddMemberToOrgViewController *obj = (AddMemberToOrgViewController*)[segue destinationViewController];
        
        obj.objOrganization = self.objOrganization;
        
    }
}

#pragma mark - Invite Friends
- (IBAction)inviteMyFriends
{
    
}

#pragma mark - Invite Friends Using Facebook
- (IBAction)inviteFacebookFriends
{
    AddFacebookInvitesController *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"AddFacebookInvitesController"];
    [self.navigationController pushViewController:obj animated:YES];
}

#pragma mark - Remove Organization
- (IBAction)removeOrganization
{
    [[WebNetworking new] sendRequestWithUrl:makeHangURL(RemoveOrganization)
                                 parameater:@{@"UserID":appDelegate.getUserObject.user_id,
                                              @"OrganizationID":self.objOrganization.org_id}
                                   delegate:self
                            withRequestName:@"RemoveOrganization"];
    [appDelegate showActivityWithStatus:@"Removing organization.."];

}

#pragma mark - Go To Calendar
- (IBAction)goToCalendar:(id)sender
{
    
}

#pragma mark - UISwitch
- (IBAction)switchValueChanged:(id)sender
{
    
}


#pragma mark - WebNetworking Delegate

- (void)webNetworkingSessionDidCompleteWithResult:(NSDictionary*)result forRequest:(NSString*)requesrName{
    
    [appDelegate hideActivity];
    
    if ([requesrName isEqualToString:@"RemoveOrganization"]) {
        
        if ([result[@"Status"] isEqualToString:@"TRUE"]) {
            
            [appDelegate hideActivityWithSuccess:@"Organization removed successfully."];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            [appDelegate hideActivityWithSuccess:result[@"Message"]];
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
