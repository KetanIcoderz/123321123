//
//  AddFromAddressbookViewController.m
//  Hang
//
//  Created by iCoderz_Ankit on 10/1/15.
//  Copyright © 2015 iCoderz. All rights reserved.
//

#import "AddFromAddressbookViewController.h"
#import "ContactTableViewCell.h"

@interface AddFromAddressbookViewController ()<WebNetworkingDelegate>

@end

@implementation AddFromAddressbookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [appDelegate setBackbuttonIfNeededInController:self];
    
    tblView.tableFooterView = [UIView new];
    array = [NSMutableArray new];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [self getContact];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
#pragma mark -

-(void)getContact{
    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    
    __block BOOL accessGranted = NO;
    
    if (&ABAddressBookRequestAccessWithCompletion != NULL) { // We are on iOS 6
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            dispatch_semaphore_signal(semaphore);
        });
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    }
    else { // We are on iOS 5 or Older
        accessGranted = YES;
        [self getContactsWithAddressBook:addressBook];
    }
    
    if (accessGranted) {
        [self getContactsWithAddressBook:addressBook];
    }
    
}

- (void)getContactsWithAddressBook:(ABAddressBookRef )addressBook {
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
    
    for (int i=0;i < nPeople;i++) {
        NSMutableDictionary *dOfPerson=[NSMutableDictionary dictionary];
        
        ABRecordRef ref = CFArrayGetValueAtIndex(allPeople,i);
        
        //For Email ids
        ABMutableMultiValueRef eMail  = ABRecordCopyValue(ref, kABPersonEmailProperty);
        if(ABMultiValueGetCount(eMail) > 0) {
            
            CFStringRef firstName, lastName;
            firstName = ABRecordCopyValue(ref, kABPersonFirstNameProperty);
            lastName  = ABRecordCopyValue(ref, kABPersonLastNameProperty);
            
            NSString *email = (__bridge NSString *)ABMultiValueCopyValueAtIndex(eMail, 0);
            
            NSString *strName = [NSString stringWithFormat:@"%@ %@", firstName,lastName];
            strName = [strName stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
            
            [dOfPerson setObject:strName forKey:@"Name"];
            [dOfPerson setObject:email forKey:@"Email"];
            
            if(![email isEqual:appDelegate.getUserObject.user_email])
                [arr addObject:dOfPerson];
        }
        
        NSSortDescriptor *sort = [[NSSortDescriptor alloc]initWithKey:@"Name" ascending:YES];
        arr = [NSMutableArray arrayWithArray:[arr sortedArrayUsingDescriptors:@[sort]]];
        
    }

    [self getData:arr];
}

-(void)getData:(NSMutableArray*)arr{
    
    [[WebNetworking new] sendRequestWithUrl:makeHangURL(GetAppUsersFromContacts)
                                 parameater:@{@"UserID":appDelegate.getUserObject.user_id,
                                              @"InviteEmail":arr}
                                   delegate:self
                            withRequestName:@"GetAppUsersFromContacts"
                                      extra:nil];
    [appDelegate showActivityWithStatus:@"Checking contacts.."];
    
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    UserObject *objUser = array[indexPath.row];
    
    if (objUser.user_id.length > 0 && objUser.isFriend == YES) {
        [cell.btn setTitle:@"Added" forState:UIControlStateNormal];
        cell.btn.layer.borderColor = kOrangeColor.CGColor;
        [cell.btn setTitleColor:kOrangeColor forState:UIControlStateNormal];
    }
    else if (objUser.user_id.length > 0 && objUser.isFriend == NO){
        [cell.btn setTitle:@"Add" forState:UIControlStateNormal];
        cell.btn.layer.borderColor = kBlueColor.CGColor;
        [cell.btn setTitleColor:kBlueColor forState:UIControlStateNormal];
    }
    else{
        [cell.btn setTitle:@"Invite" forState:UIControlStateNormal];
        cell.btn.layer.borderColor = [UIColor grayColor].CGColor;
        [cell.btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    
    cell.lbl.text = objUser.user_firstName;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UserObject *objUser = array[indexPath.row];
    
    if (objUser.user_id.length > 0 && objUser.isFriend == YES) {
        return;
    }
    else if (objUser.user_id.length > 0 && objUser.isFriend == NO){
        
        [[WebNetworking new] sendRequestWithUrl:makeHangURL(AddFriends)
                                     parameater:@{@"UserID":appDelegate.getUserObject.user_id,
                                                  @"ApplicationUser":@[objUser.user_id],
                                                  @"InviteEmail":@[]}
                                       delegate:self
                                withRequestName:@"AddFriends"
                                          extra:indexPath];
//        [appDelegate showActivityWithStatus:@"Adding.."];

    }
    else{
        return;
    }
}

#pragma mark - Event Message
- (void)selectMessage:(UIButton *)sender
{
    CGPoint touchPoint = [sender convertPoint:CGPointZero toView:tblView];
    NSIndexPath *indexPath = [tblView indexPathForRowAtPoint:touchPoint];
    NSLog(@"indexPath : %@", indexPath);
}

#pragma mark - WebNetworking Delegate

- (void)webNetworkingSessionDidCompleteWithResult:(NSDictionary*)result forRequest:(NSString*)requesrName extra:(id)extra{
    
    
    if ([requesrName isEqualToString:@"GetAppUsersFromContacts"]) {
        
        if ([result[@"Status"] isEqualToString:@"TRUE"]) {
            
            NSArray *arrTemp = result[@"UserArray"];
            
            for (NSDictionary *dict in arrTemp) {
                
                UserObject *objUser = [UserObject new];
                objUser.user_id = dict[@"UserID"];
                objUser.user_email = dict[@"Email"];
                objUser.user_firstName = dict[@"Name"];
                objUser.isFriend = [dict[@"UserIsFriend"] isEqualToString:@"Yes"];
                
                [array addObject:objUser];
            }
            
            [tblView reloadData];
            [appDelegate hideActivity];
            
        }
        else {
            [appDelegate hideActivityWithError:@""];
        }
        
    }
    else if ([requesrName isEqualToString:@"AddFriends"]) {
        
        if ([result[@"Status"] isEqualToString:@"TRUE"]) {
            
            NSIndexPath *indexPath = (NSIndexPath*)extra;
            ((UserObject*)array[indexPath.row]).isFriend = YES;
            [tblView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//            [appDelegate hideActivityWithSuccess:@"Added"];
            
        }
        else {
            [appDelegate hideActivityWithError:@""];
        }
        
    }
    else{
        [appDelegate hideActivity];
        if ([result[@"Status"] isEqualToString:@"TRUE"]) {
            
        }
        else{
            
        }
        
    }
}

- (void)webNetworkingSessionDidFailWithError:(NSError*)error forRequest:(NSString*)requesrName extra:(id)extra{
    
    [appDelegate hideActivityWithError:error.localizedDescription];
}




@end
