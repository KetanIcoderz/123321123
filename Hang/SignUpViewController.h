//
//  SignUpViewController.h
//  Hang
//
//  Created by iCoderz_Ankit on 9/9/15.
//  Copyright (c) 2015 iCoderz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpViewController : UIViewController{
    IBOutlet UITextField *tfEmail,*tfUsername,*tfPassword;
//    IBOutlet UITextField *tfName,*tfMobileNo,*tfConfirm;
    IBOutlet UITextView *tvTerm;
    IBOutlet UIButton *btnSignUp;
    IBOutlet NSLayoutConstraint *bottomMargin,*topSpace;

}

@end
