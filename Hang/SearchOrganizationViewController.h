//
//  SearchOrganizationViewController.h
//  Hang
//
//  Created by iCoderz_Ankit on 10/9/15.
//  Copyright © 2015 iCoderz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchOrganizationViewController : UIViewController
{
    IBOutlet UITableView *tblView;
    IBOutlet UISearchBar *sBar;
    NSMutableArray *array;
    WebNetworking *wn;
}
@end
