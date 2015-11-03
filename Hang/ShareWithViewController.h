//
//  ShareWithViewController.h
//  Hang
//
//  Created by iCoderz_Ankit on 9/21/15.
//  Copyright (c) 2015 iCoderz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareWithViewController : UIViewController
{
    IBOutlet UITableView *tblView;
    NSMutableArray *array;
}

@property (nonatomic,strong) NSMutableArray *arraySelected;
@property BOOL isFriend;

@end
