//
//  OrganizationDetailViewController.h
//  Calender
//
//  Created by iCoderz_Binal on 29/09/15.
//  Copyright © 2015 iCoderz_Binal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrganizationObject.h"

@interface OrganizationDetailViewController : UIViewController
{
    IBOutlet UILabel *lbl_OrganizationName;
    IBOutlet UILabel *lbl_OrganizationFollow;
    IBOutlet UISwitch *swt_Organization;
    
    IBOutlet UITextView *txtVw_Description;
    IBOutlet UIButton *btn_GotoCalendar;
    
    IBOutlet NSLayoutConstraint *conHeight;
    
    NSMutableArray *arr_Options;
    NSMutableArray *arr_OptionImages;
}

@property (nonatomic, strong) OrganizationObject *objOrganization;


@end
