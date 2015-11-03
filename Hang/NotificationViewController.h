//
//  NotificationViewController.h
//  Hang
//
//  Created by iCoderz_Ankit on 9/11/15.
//  Copyright (c) 2015 iCoderz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationViewController : UIViewController{
    IBOutlet UITableView *tblView;
    UISwitch *swAllFriends,*swAllGroup,*swMessage,*swChat;
    NSMutableArray *arrayNames0,*arrayNames1;
}

@end
