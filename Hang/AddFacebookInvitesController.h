//
//  AddFacebookInvitesController.h
//  Hang
//
//  Created by iCoderz_Hiren on 09/10/15.
//  Copyright © 2015 iCoderz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebNetworking.h"

@interface AddFacebookInvitesController : UIViewController<WebNetworkingDelegate>
{
    NSMutableArray *arrAllFriends;

    NSMutableArray *arrSearchedFriends;
    
    IBOutlet UITableView *tblView;
    IBOutlet UISearchBar *searchbar;
    IBOutlet UIButton *btnInviteAll;
    IBOutlet UIView *viewHeader;
}

@property(nonatomic,assign) BOOL isFromFriendSection;

@end
