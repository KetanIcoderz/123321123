//
//  LoginViewController.h
//  Hang
//
//  Created by iCoderz_Ankit on 9/9/15.
//  Copyright (c) 2015 iCoderz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
{
    IBOutlet UITextField *tfUsername,*tfPassword;
    IBOutlet UILabel *lblError;
    IBOutlet UIButton *btnLogin;
    IBOutlet NSLayoutConstraint *bottomMargin,*topSpace;
}
@end
