//
//  RequestTableViewCell.h
//  Hang
//
//  Created by iCoderz_Ankit on 10/8/15.
//  Copyright © 2015 iCoderz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RequestTableViewCell : UITableViewCell

@property (nonatomic,strong) IBOutlet UILabel *lbl;
@property (nonatomic,strong) IBOutlet UIImageView *img;
@property (nonatomic,strong) IBOutlet UIButton *btnAccept,*btnReject;


@end
