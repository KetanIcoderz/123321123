//
//  PostSignUpViewController.h
//  Hang
//
//  Created by iCoderz_Ankit on 9/10/15.
//  Copyright (c) 2015 iCoderz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface PostSignUpViewController : UIViewController
{
    IBOutlet UIButton *btnDone,*btnSkip;
    IBOutlet UIImageView *img,*imgTemp;
}

@property (nonatomic,strong) NSString *strUserID;

@end
