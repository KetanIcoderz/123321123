//
//  OrganizationTableViewCell.m
//  Calender
//
//  Created by iCoderz_Binal on 28/09/15.
//  Copyright © 2015 iCoderz_Binal. All rights reserved.
//

#import "OrganizationTableViewCell.h"

@implementation OrganizationTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.btn.layer.borderWidth = 1.0;
    self.btn.layer.cornerRadius = 4.0;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
