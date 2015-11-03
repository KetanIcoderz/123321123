//
//  ContactTableViewCell.m
//  Hang
//
//  Created by iCoderz_Ankit on 9/21/15.
//  Copyright (c) 2015 iCoderz. All rights reserved.
//

#import "ContactTableViewCell.h"

@implementation ContactTableViewCell

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
