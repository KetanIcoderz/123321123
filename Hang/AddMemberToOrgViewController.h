//
//  AddMemberToOrgViewController.h
//  Hang
//
//  Created by iCoderz_Ankit on 9/21/15.
//  Copyright (c) 2015 iCoderz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrganizationObject.h"

@interface AddMemberToOrgViewController : UIViewController
{
    IBOutlet UITableView *tblView;
    NSMutableArray *array;
    UIBarButtonItem *btnCount;
}

@property (nonatomic,strong) OrganizationObject *objOrganization;

@end
