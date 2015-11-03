//
//  GroupMemberTableViewCell.h
//  Hang
//
//  Created by iCoderz_Ankit on 10/1/15.
//  Copyright © 2015 iCoderz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupMemberTableViewCell : UITableViewCell

@property (nonatomic,strong) IBOutlet UILabel *lbl;
@property (nonatomic,strong) IBOutlet UIButton *btn;
@property (nonatomic,strong) IBOutlet UIImageView *img;
@property (nonatomic,strong) IBOutlet NSLayoutConstraint *btnWidth;

@end
