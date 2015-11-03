//
//  MenuViewController.h
//  Hang
//
//  Created by iCoderz_Ankit on 9/10/15.
//  Copyright (c) 2015 iCoderz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController{
    
    NSMutableArray *arrayNames;
    
}

@property (nonatomic,strong) IBOutlet UITableView *tblView;

-(void)openSearch;

@end
