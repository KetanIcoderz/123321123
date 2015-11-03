//
//  CreateOrganizationViewController.h
//  Hang
//
//  Created by iCoderz_Ankit on 10/8/15.
//  Copyright © 2015 iCoderz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrganizationObject.h"

@interface CreateOrganizationViewController : UIViewController
{
    IBOutlet UITextField *txt_OrganizationName;
    IBOutlet UITextView *txtVw_OrganizationDesc;
    IBOutlet UILabel *lbl_Status;
    IBOutlet UISwitch *swt_PublicPrivate;
    UILabel*lbl;
    UIToolbar *toolbar;
    UIBarButtonItem *btnSave;
}

@property (nonatomic,strong) OrganizationObject *objOrganization;

@end
