//
//  ForgotPasswordViewController.h
//  Hang
//
//  Created by iCoderz_Ankit on 10/5/15.
//  Copyright © 2015 iCoderz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotPasswordViewController : UIViewController
{
    IBOutlet UITextField *tfUsername;
    IBOutlet UIButton *btnLogin;
    IBOutlet NSLayoutConstraint *bottomMargin,*topSpace;
}
@end
