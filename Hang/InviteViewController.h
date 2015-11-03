//
//  InviteViewController.h
//  Hang
//
//  Created by iCoderz_Ankit on 10/2/15.
//  Copyright © 2015 iCoderz. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EventDetails.h"

@interface InviteViewController : UIViewController
{
    IBOutlet UISegmentedControl *sc;
    IBOutlet UITableView *tblView;
    NSMutableArray *arrFriend,*arrGroup,*arrSelectedFriend,*arrSelectedGroup;
}

@property (nonatomic,strong) EventDetails *objEvent;
@property BOOL isGroup;
@end
