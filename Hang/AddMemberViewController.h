//
//  AddMemberViewController.h
//  Hang
//
//  Created by iCoderz_Ankit on 9/21/15.
//  Copyright (c) 2015 iCoderz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddMemberViewController : UIViewController
{
    IBOutlet UITableView *tblView;
    NSMutableArray *array,*arraySelected;
    UIBarButtonItem *btnCount;
}

@property (nonatomic,strong) NSString *strGroupID;
@property (nonatomic,strong) NSMutableArray *arrGroupMember;

@end
