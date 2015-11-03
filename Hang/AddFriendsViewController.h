//
//  AddFriendsViewController.h
//  Calender
//
//  Created by iCoderz_Binal on 26/09/15.
//  Copyright © 2015 iCoderz_Binal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddFriendsViewController : UIViewController
{
    IBOutlet UITableView *tblView;
    
    NSMutableArray *arr_CellTitle;
    NSMutableArray *arr_CellImages;
}
@end
