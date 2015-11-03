//
//  TblViewController.h
//  actionSheet
//
//  Created by icoderz_hardik on 11/09/15.
//  Copyright (c) 2015 icoderz_raj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationSearchViewController : UIViewController
{
    
    IBOutlet UIView *headerVw,*searchView;
    IBOutlet UISearchBar *searchBar1;
    IBOutlet UITableView *tblVw;
    NSMutableArray *arr;
    
}

@end
