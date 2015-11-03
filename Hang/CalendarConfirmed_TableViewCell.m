//
//  CalendarConfirmed_TableViewCell.m
//  Calender
//
//  Created by iCoderz_Binal on 18/09/15.
//  Copyright (c) 2015 iCoderz_Binal. All rights reserved.
//

#import "CalendarConfirmed_TableViewCell.h"

@implementation CalendarConfirmed_TableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.btn_YES.layer.borderColor = [kBlueColor CGColor];
    self.btn_YES.layer.borderWidth = 1.0;
    self.btn_YES.layer.cornerRadius = 4.0;
    
    self.btn_MAYBE.layer.borderColor = [kBlueColor CGColor];
    self.btn_MAYBE.layer.borderWidth = 1.0;
    self.btn_MAYBE.layer.cornerRadius = 4.0;
    
    self.btn_NO.layer.borderColor = [kBlueColor CGColor];
    self.btn_NO.layer.borderWidth = 1.0;
    self.btn_NO.layer.cornerRadius = 4.0;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
