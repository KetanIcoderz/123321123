//
//  EventDetailViewController.h
//  Hang
//
//  Created by iCoderz_Ankit on 10/12/15.
//  Copyright © 2015 iCoderz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventDetails.h"

@interface EventDetailViewController : UIViewController{
    
    CGFloat cellDimention;
    IBOutlet UICollectionView *cv;
    IBOutlet UIScrollView *sv;
    IBOutlet NSLayoutConstraint *cvHeight;
    
    IBOutlet UITextField *tfName,*tfOrganizer,*tfInvitedBy;
    IBOutlet UITextView *tfDetail;
    
    IBOutlet UIButton *btnStartDate,*btnEndDate,*btnLocation,*btnShareFriend,*btnShareGroup,*btnGoing,*btnMaybe,*btnNotGoing;
    NSMutableArray *arrYes,*arrMaybe,*arrNo;
    
}

@property (nonatomic,strong) EventDetails *objEvent;
@property (nonatomic,strong) NSString *strDate;

@end
