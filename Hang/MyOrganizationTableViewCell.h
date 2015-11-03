//
//  AddOrganizationTableViewCell.h
//  Calender
//
//  Created by iCoderz_Binal on 28/09/15.
//  Copyright © 2015 iCoderz_Binal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrganizationTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *lbl_OrganizationName;
@property (nonatomic, weak) IBOutlet UILabel *lbl_OrganizationFollowers;
@property (nonatomic, weak) IBOutlet UIButton *btnEdit;

@end
