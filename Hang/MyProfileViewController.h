//
//  MyProfileViewController.h
//  Hang
//
//  Created by iCoderz_Ankit on 9/10/15.
//  Copyright (c) 2015 iCoderz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyProfileViewController : UIViewController
{
    IBOutlet UITableView *tblView;
    NSMutableArray *arrayNames;
    
}

@property (nonatomic,strong) NSString *strName,*strMobileNumber;

@end
