//
//  EventSearchTableViewCell.h
//  EventDemo
//
//  Created by ketan_icoderz on 08/10/15.
//  Copyright © 2015 icoderz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventSearchTableViewCell : UITableViewCell

@property(retain,nonatomic)IBOutlet UILabel *lblDate;
@property(retain,nonatomic)IBOutlet UILabel *lblTime;
@property(retain,nonatomic)IBOutlet UILabel *lblMile;
@property(retain,nonatomic)IBOutlet UILabel *lblTitle;
@property(retain,nonatomic)IBOutlet UILabel *lblGroup;
@property(retain,nonatomic)IBOutlet UILabel *lblNumberOfFriend;
@end
