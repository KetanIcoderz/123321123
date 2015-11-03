//
//  EventSearchViewController.h
//  EventDemo
//
//  Created by ketan_icoderz on 08/10/15.
//  Copyright © 2015 icoderz. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "WebServiceHelper.h"
#import "SVProgressHUD.h"
#import "NSObject+SBJSON.h"
#import "EventSearchTableViewCell.h"
#import <MapKit/MapKit.h>



@interface EventSearchViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    IBOutlet UITableView *tblMain;
 
    NSMutableArray *dict;
    int IncreseValue;
    int indexSelect;
    
    NSArray *arryColor;
    BOOL load;
    NSMutableDictionary *dictData;
    NSMutableDictionary *dictData1;

    BOOL Paging;
    
    IBOutlet UISearchBar *search;
    NSMutableArray *aryKeys;
    IBOutlet UISegmentedControl *segMain;
    

    
}

-(IBAction)segMain:(id)sender;

@end
