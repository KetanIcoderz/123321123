//
//  SettingsViewController.h
//  Hang
//
//  Created by iCoderz_Ankit on 9/10/15.
//  Copyright (c) 2015 iCoderz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController{
    IBOutlet UITableView *tblView;
    UISwitch *swFacebook;
    NSMutableArray *arrayNames,*arrayWeekDays,*arrayAlert,*arraySearchRadius;
    NSUInteger indexSearchRadius;
}

@end
