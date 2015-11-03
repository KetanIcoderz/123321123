//
//  UpdateProfileViewController.h
//  Hang
//
//  Created by iCoderz_Ankit on 9/17/15.
//  Copyright (c) 2015 iCoderz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdateProfileViewController : UIViewController
{
    IBOutlet UITableView *tblView;
    NSMutableArray *array;
    UIToolbar *toolbar;
}

@property (nonatomic,strong) NSString *strKey,*strValue;

@end
