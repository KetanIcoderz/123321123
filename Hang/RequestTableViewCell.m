//
//  RequestTableViewCell.m
//  Hang
//
//  Created by iCoderz_Ankit on 10/8/15.
//  Copyright © 2015 iCoderz. All rights reserved.
//

#import "RequestTableViewCell.h"

@implementation RequestTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.img.layer.cornerRadius = 12.0;
    self.img.layer.borderWidth = 0.5;
    self.img.layer.borderColor = [UIColor colorWithRed:151.0/255.0 green:151.0/255.0 blue:151.0/255.0 alpha:1.0].CGColor;
    self.img.layer.masksToBounds = YES;
    
    self.btnAccept.layer.cornerRadius = 3.0;
    self.btnAccept.layer.borderWidth = 1.0;
    self.btnAccept.layer.borderColor = [UIColor colorWithRed:36.0/255.0 green:184.0/255.0 blue:14.0/255.0 alpha:1.0].CGColor;

    self.btnReject.layer.cornerRadius = 3.0;
    self.btnReject.layer.borderWidth = 1.0;
    self.btnReject.layer.borderColor = [UIColor redColor].CGColor;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
