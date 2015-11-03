//
//  AddFromAddressbookViewController.h
//  Hang
//
//  Created by iCoderz_Ankit on 10/1/15.
//  Copyright © 2015 iCoderz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/ABAddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface AddFromAddressbookViewController : UIViewController
{
    IBOutlet UITableView *tblView;
    NSMutableArray *array;
}
@end
