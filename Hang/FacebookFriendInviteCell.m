//
//  FacebookFriendInviteCell.m
//  Hang
//
//  Created by iCoderz_Hiren on 09/10/15.
//  Copyright © 2015 iCoderz. All rights reserved.
//

#import "FacebookFriendInviteCell.h"

@implementation FacebookFriendInviteCell


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
