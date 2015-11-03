
//
//  AddFacebookInvitesController.m
//  Hang
//
//  Created by iCoderz_Hiren on 09/10/15.
//  Copyright © 2015 iCoderz. All rights reserved.
//

#import "AddFacebookInvitesController.h"
#import "WebNetworking.h"
#import "FacebookFriendInviteCell.h"
#import "UIImageView+WebCache.h"

@interface AddFacebookInvitesController ()

@end

@implementation AddFacebookInvitesController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [appDelegate setBackbuttonIfNeededInController:self];
    
    arrAllFriends = [[NSMutableArray alloc] init];
    arrSearchedFriends = [[NSMutableArray alloc] init];
    
    tblView.hidden = TRUE;
    btnInviteAll.layer.borderWidth = 1.0;
    btnInviteAll.layer.cornerRadius = 4.0;
    btnInviteAll.layer.borderColor = btnInviteAll.titleLabel.textColor.CGColor;
    
    [self funGetFriends];
    
    tblView.tableFooterView = [UIView new];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"save"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(funPost)];

    self.title = @"Facebook Invites";
    
    //viewHeader.backgroundColor = [UIColor redColor];
    
    tblView.tableHeaderView = viewHeader;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)funInviteAll:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    if(sender.selected)
    {
        for (UserObject *objFriend in arrSearchedFriends)
        {
            objFriend.isFriend = YES;
            [tblView reloadData];
        }
    }
    else
    {
        for (UserObject *objFriend in arrSearchedFriends)
        {
            objFriend.isFriend = NO;
            [tblView reloadData];
        }
    }
    
    btnInviteAll.layer.borderColor = btnInviteAll.titleLabel.textColor.CGColor;

}

-(void)funPost
{
    
    NSMutableArray *arrFB = [NSMutableArray new];
    
    for (UserObject *objFriend in arrSearchedFriends)
    {
        if(objFriend.isFriend)
        {
            [arrFB addObject:objFriend.user_id];
        }
    }
    
    
    if([arrFB count] == 0)
    {
        return;
    }
    
    
    if([[[FBSDKAccessToken currentAccessToken] permissions] containsObject:@"publish_actions"])
    {
        
        [self funPostOnWall:arrFB];
        
        return;
    }
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    login.loginBehavior = FBSDKLoginBehaviorSystemAccount;
    [login logInWithPublishPermissions: @[@"publish_actions"]
                 fromViewController:self
                            handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                
                                if (error) {
                                    
                                    NSLog(@"Process error");
                                    [[[UIAlertView alloc]initWithTitle:appName message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                                    
                                } else if (result.isCancelled) {
                                    
                                    NSLog(@"Cancelled");
                                    
                                } else {
                                    
                                    NSLog(@"Logged in");
                                    
                                    
                                    [self funPostOnWall:arrFB];
                                    
                                }
                            }];
}

-(void)funPostOnWall:(NSMutableArray *)arrFB
{
    [appDelegate showActivity];
    
    
    if([arrFB count]>0)
    {
        
        NSString *strTagFrinds = [arrFB componentsJoinedByString:@","];
        NSString *strMessage = @"Hey! Join me on Hang Event application.";
        
        NSMutableDictionary *dict;
        
        dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:strMessage
                ,@"message",strTagFrinds,@"tags", nil];
        
        
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                      initWithGraphPath:[NSString stringWithFormat:@"me/feed"]
                                      parameters:dict
                                      HTTPMethod:@"POST"];
        
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                              id result,
                                              NSError *error) {
            
            if (!error)
            {
                NSLog(@"result: %@",result);
                
                [appDelegate hideActivityWithSuccess:@"Friends invited  successfully."];
                
                for (UserObject *objFriend in arrSearchedFriends)
                {
                    objFriend.isFriend = NO;
                }
                
                [tblView reloadData];
            }
            else
            {
                NSLog(@"Error: %@",error.description);
                
                [appDelegate hideActivity];
            }
            
        }];
        
    }
}

#pragma mark -

-(void)funGetFriends
{
    //    [appDelegate showActivityWithStatus:@"Checking for facebook profile photo.."];
    
    
    if([[[FBSDKAccessToken currentAccessToken] permissions] containsObject:@"user_friends"])
    {
        [self funLoadFriends];
        
        return;
    }
    
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    login.loginBehavior = FBSDKLoginBehaviorSystemAccount;
    [login logInWithReadPermissions: @[@"public_profile",@"email",@"user_friends"]
                 fromViewController:self
                            handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                
                                if (error) {
                                    
                                    NSLog(@"Process error");
                                    [[[UIAlertView alloc]initWithTitle:appName message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                                    
                                } else if (result.isCancelled) {
                                    
                                    NSLog(@"Cancelled");
                                    //             [[[UIAlertView alloc]initWithTitle:@"Facebook" message:@"The user hasn't authorized the application to perform this action." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                                    
                                } else {
                                    
                                    NSLog(@"Logged in");
                                    
                                    [self funLoadFriends];
                                }
                            }];
}

-(void)funLoadFriends
{
    [appDelegate showActivity];
    
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:[NSString stringWithFormat:@"me/taggable_friends"]
                                  parameters:nil
                                  HTTPMethod:@"GET"];
    
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        
        
        if (!error)
        {
            NSMutableArray *arrFb = [NSMutableArray new];
            
            NSDictionary *userFriendList = (NSDictionary*)result;
            
            NSMutableArray *arr = userFriendList[@"data"];
            
            
            if(arr.count==0)
            {
                return;
            }
            
            
            for (int i=0; i < arr.count; i++)
            {
                NSDictionary *dictFriend = [arr objectAtIndex:i];
                UserObject *objFriend = [[UserObject alloc] init];
                objFriend.user_id = [dictFriend objectForKey:@"id"];
                
                
                NSString *strFirstName;
                if([[dictFriend valueForKey:@"name"] isEqualToString:@""] || [[dictFriend valueForKey:@"name"] isEqual:[NSNull null]])
                {
                    strFirstName = @"";
                }
                else
                {
                    
                    strFirstName = [dictFriend objectForKey:@"name"];
                }
                
                objFriend.user_name = strFirstName;
                
                if([dictFriend valueForKey:@"picture"]!=nil && ![[dictFriend valueForKey:@"picture"] isEqual:[NSNull null]]){
                    objFriend.user_profilePictureURL = [[[dictFriend objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"];
                }else{
                    objFriend.user_profilePictureURL = @"";
                }
                [arrFb addObject:objFriend];
            }
            
            NSLog(@"arrFb : %@", arrFb);
            NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"user_name" ascending:YES];
            appDelegate.arrFacebookFrds=(NSMutableArray *)[arrFb sortedArrayUsingDescriptors:@[sort]];
            NSLog(@"Friends %@",appDelegate.arrFacebookFrds);
            arrAllFriends = [[NSMutableArray alloc] initWithArray:appDelegate.arrFacebookFrds];
            arrSearchedFriends = [[NSMutableArray alloc] initWithArray:appDelegate.arrFacebookFrds];
            
            
            tblView.hidden = FALSE;
            
            [UIView transitionWithView:self.view duration:0.3 options:
             UIViewAnimationOptionCurveEaseIn| UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                [tblView reloadData];
                            } completion:NULL
             ];
            
            
            [appDelegate hideActivity];
            
            NSDictionary *dictPaging = [userFriendList objectForKey:@"paging"];
            NSString *strNextURL = [dictPaging valueForKey:@"next"];
            
            if(strNextURL)
            {
                [self funLoadMoreFriednds:strNextURL];
            }
            
        }
        else
        {
            //                 [[CommonMethods sharedManager] errorButtonPressed:error.description];
            NSLog(@"Error %@",error.description);
            [appDelegate hideActivity];
        }
    }];
}

#pragma mark - UITableView DataSource

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 88;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    return viewHeader;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrSearchedFriends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FacebookFriendInviteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    UserObject *objUser = arrSearchedFriends[indexPath.row];
    
    
    cell.lbl.text = objUser.user_name;
    [cell.imgViewPic setImageWithURL:[NSURL URLWithString:objUser.user_profilePictureURL] placeholderImage:[UIImage imageNamed:@"profile"]];
    
    cell.imgViewPic.layer.cornerRadius = cell.imgViewPic.frame.size.width/2;
    cell.imgViewPic.layer.masksToBounds = YES;

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
    

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UserObject *objUser = arrSearchedFriends[indexPath.row];
    objUser.isFriend = !objUser.isFriend;
    [tblView reloadData];
}


-(void)funLoadMoreFriednds:(NSString *)strNextURL
{
    [[WebNetworking new] sendRequestWithUrl:strNextURL
                                 parameater:nil
                                   delegate:self
                            withRequestName:@"FacebookFriends"
                                      extra:nil];
}


#pragma mark - WebNetworking Delegate

- (void)webNetworkingSessionDidCompleteWithResult:(NSDictionary*)result forRequest:(NSString*)requesrName{
    
    
    if ([requesrName isEqualToString:@"FacebookFriends"]) {
        
        
        
            NSMutableArray *arrFb = [NSMutableArray new];
        
            NSDictionary *userFriendList = (NSDictionary*)result;
        
            NSMutableArray *arr = userFriendList[@"data"];
        
        
            if(arr.count==0)
            {
                //[[CommonMethods sharedManager] errorButtonPressed:@"No friends found!"];
                return;
            }
        
        
            for (int i=0; i < arr.count; i++)
            {
                NSDictionary *dictFriend = [arr objectAtIndex:i];
                UserObject *objFriend = [[UserObject alloc] init];
                objFriend.user_id = [dictFriend objectForKey:@"id"];
                
                
                NSString *strFirstName;
                if([[dictFriend valueForKey:@"name"] isEqualToString:@""] || [[dictFriend valueForKey:@"name"] isEqual:[NSNull null]])
                {
                    strFirstName = @"";
                }
                else
                {
                    
                    strFirstName = [dictFriend objectForKey:@"name"];
                }
                
                objFriend.user_name = strFirstName;
                
                if([dictFriend valueForKey:@"picture"]!=nil && ![[dictFriend valueForKey:@"picture"] isEqual:[NSNull null]]){
                    objFriend.user_profilePictureURL = [[[dictFriend objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"];
                }else{
                    objFriend.user_profilePictureURL = @"";
                }
                [arrFb addObject:objFriend];
            }
            
                NSLog(@"arrFb : %@", arrFb);
            NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"user_name" ascending:YES];
            
            NSArray *arrNewFriends = [arrFb sortedArrayUsingDescriptors:@[sort]];
            
            NSMutableArray *arrTemp = [[NSMutableArray alloc] initWithArray:appDelegate.arrFacebookFrds];
            
            
            [arrTemp addObjectsFromArray:arrNewFriends];
            
            appDelegate.arrFacebookFrds = (NSMutableArray *)arrTemp;
            
            NSLog(@"Friends %@",appDelegate.arrFacebookFrds);
        
        
        
            [arrAllFriends addObjectsFromArray:arrNewFriends];
            [arrSearchedFriends addObjectsFromArray:arrNewFriends];
        
            tblView.hidden = FALSE;
            
            [UIView transitionWithView:self.view duration:0.3 options:
             UIViewAnimationOptionCurveEaseIn| UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                [tblView reloadData];
                            } completion:NULL
             ];
            
            
            [appDelegate hideActivity];
            
            NSDictionary *dictPaging = [userFriendList objectForKey:@"paging"];
            NSString *strNextURL = [dictPaging valueForKey:@"next"];
            
            if(strNextURL)
            {
                [self funLoadMoreFriednds:strNextURL];
            }
            
        
        
    }
    else{
        
        if ([result[@"Status"] isEqualToString:@"TRUE"]) {
            
        }
        else{
            
        }
    }
}

- (void)webNetworkingSessionDidFailWithError:(NSError*)error forRequest:(NSString*)requesrName{
    
    [appDelegate hideActivityWithError:error.localizedDescription];
}


#pragma mark -
#pragma mark - Search
#pragma mark -

- (void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar
{
    [self searchFriends:theSearchBar.text];
    [self.view endEditing:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    [arrSearchedFriends removeAllObjects];
    arrSearchedFriends = [[NSMutableArray alloc] initWithArray:arrAllFriends];
    
    [tblView reloadData];
}

- (void)searchFriends:(NSString *)name
{
    NSPredicate *searchpred = [NSPredicate predicateWithFormat:@"user_name CONTAINS[c] %@", name, name];
    [arrSearchedFriends removeAllObjects];
    [arrSearchedFriends addObjectsFromArray:[arrAllFriends filteredArrayUsingPredicate:searchpred]];
    
    
    
    [tblView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText length] == 0) {
        [self performSelector:@selector(hideKeyboardWithSearchBar:) withObject:searchBar afterDelay:0];
        return;
    }
    
    NSString *str = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if(str.length>0)
        [self searchFriends:str];
    else
    {
        arrSearchedFriends = [[NSMutableArray alloc] initWithArray:arrAllFriends];
        
       
        
        [tblView reloadData];
    }
}

- (void)hideKeyboardWithSearchBar:(UISearchBar *)searchBar
{
    [searchbar resignFirstResponder];
    [arrSearchedFriends removeAllObjects];
    arrSearchedFriends = [[NSMutableArray alloc] initWithArray:arrAllFriends];
    
    [tblView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
