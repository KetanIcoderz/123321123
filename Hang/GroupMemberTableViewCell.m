//
//  GroupMemberTableViewCell.m
//  Hang
//
//  Created by iCoderz_Ankit on 10/1/15.
//  Copyright © 2015 iCoderz. All rights reserved.
//

#import "GroupMemberTableViewCell.h"

@implementation GroupMemberTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.btn.layer.borderWidth = 1.0;
    self.btn.layer.cornerRadius = 4.0;
    self.btn.layer.borderColor = [UIColor redColor].CGColor;
    self.btn.layer.masksToBounds = YES;
    
    self.img.layer.cornerRadius = 15.5;
    self.img.layer.borderWidth = 0.5;
    self.img.layer.borderColor = [UIColor colorWithRed:151.0/255.0 green:151.0/255.0 blue:151.0/255.0 alpha:1.0].CGColor;
    self.img.layer.masksToBounds = YES;


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end