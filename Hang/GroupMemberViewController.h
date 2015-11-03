//
//  GroupMemberViewController.h
//  Calender
//
//  Created by iCoderz_Binal on 25/09/15.
//  Copyright © 2015 iCoderz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupMemberViewController : UIViewController
{
    IBOutlet UITableView *tblView;
    NSMutableArray *array;
    IBOutlet UIButton *btnDelete;
}

@property (nonatomic,strong) NSString *strGroupID;
@property BOOL isOwner;

@end
