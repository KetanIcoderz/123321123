//
//  PostSignUpViewController.m
//  Hang
//
//  Created by iCoderz_Ankit on 9/10/15.
//  Copyright (c) 2015 iCoderz. All rights reserved.
//

#import "PostSignUpViewController.h"

@interface PostSignUpViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,WebNetworkingDelegate>

@end

@implementation PostSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
//    btnDone.layer.borderColor = [UIColor whiteColor].CGColor;
//    btnDone.layer.borderWidth = 2.0;
//    
//    btnSkip.layer.borderColor = [UIColor whiteColor].CGColor;
//    btnSkip.layer.borderWidth = 2.0;
    
    [img addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectType)]];
    
//    [self facebookAuthForProfilePicture];
    
    [appDelegate setBackbuttonIfNeededInController:self];
    
    [self performSelector:@selector(selectType) withObject:nil afterDelay:1.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews{
    
    img.layer.cornerRadius = img.frame.size.height/2;
    img.layer.masksToBounds = YES;
    
    img.layer.borderWidth = 2.0;
    img.layer.borderColor = [UIColor whiteColor].CGColor;
    
    imgTemp.layer.cornerRadius = imgTemp.frame.size.height/2;
    imgTemp.layer.masksToBounds = YES;
    
    imgTemp.layer.borderWidth = 2.0;
    imgTemp.layer.borderColor = [UIColor whiteColor].CGColor;
    
}

-(void)viewDidAppear:(BOOL)animated{
    
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

-(void)facebookAuthForProfilePicture
{
//    [appDelegate showActivityWithStatus:@"Checking for facebook profile photo.."];
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    login.loginBehavior = FBSDKLoginBehaviorSystemAccount;
    [login logInWithReadPermissions: @[@"public_profile",@"email",@"user_friends"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         
         [appDelegate hideActivity];
         
         if (error) {
             
             NSLog(@"Process error");
             [[[UIAlertView alloc]initWithTitle:appName message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
             
         } else if (result.isCancelled) {
             
             NSLog(@"Cancelled");
//             [[[UIAlertView alloc]initWithTitle:@"Facebook" message:@"The user hasn't authorized the application to perform this action." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
             
         } else {
            
             NSLog(@"Logged in");
             FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                           initWithGraphPath:[NSString stringWithFormat:@"me/picture?type=large&redirect=false"]
                                           parameters:nil
                                           HTTPMethod:@"GET"];
             
             [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                                   id result,
                                                   NSError *error) {
                 if (!error){
                     
                     NSString *str = ((NSDictionary*)result)[@"data"][@"url"];
                     [img setImageWithURL:[NSURL URLWithString:str]];
                 }
                 else {
                     NSLog(@"result: %@",[error description]);
                 }  
             }];
         }
     }];
}

-(IBAction)selectType{
    
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil
                                                        delegate:self
                                               cancelButtonTitle:@"Cancel"
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:@"Camera",@"Gallery",@"Facebook", nil];
    [action showInView:self.view];
    
}

#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    
    if (buttonIndex == 0)
    {
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
        {
            UIImagePickerController *picker1 = [[UIImagePickerController alloc] init];
            picker1.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker1.allowsEditing = YES;
            picker1.delegate = self;
            
            [self presentViewController:picker1 animated:YES completion:nil];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appName message:@"Camera not available." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
    }
    else if (buttonIndex == 1)
    {
        UIImagePickerController *picker1 = [[UIImagePickerController alloc] init];
        picker1.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker1.allowsEditing = YES;
        picker1.delegate = self;
        
        [self presentViewController:picker1 animated:YES completion:nil];
    }
    else if (buttonIndex == 2)
    {
        [self facebookAuthForProfilePicture];
    }
}

#pragma mark - UIImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [picker dismissViewControllerAnimated:YES completion:^{
        img.image = info[UIImagePickerControllerEditedImage];
    }];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


-(IBAction)Done{
    
    [[WebNetworking new] uploadImageWithUrl:makeUserURL(UploadProfileImage)
                                 parameater:@{@"UserID":self.strUserID}
                                  imageData:UIImageJPEGRepresentation(img.image, 0.5)
                                  imageName:self.strUserID
                                   delegate:self
                            withRequestName:@"UploadProfileImage"];
    [appDelegate showActivityWithStatus:@"Uploading Image.."];

}

-(IBAction)skip{
    
    [self success];
    [appDelegate hideActivityWithSuccess:[NSString stringWithFormat:@"Welcome %@",[appDelegate setNameOfUserFromFirstName:appDelegate.getUserObject.user_firstName.emojiDecode andUserName:appDelegate.getUserObject.user_name.emojiDecode]]];
    
}

-(void)success{
    
    UINavigationController *navMenu = [self.storyboard instantiateViewControllerWithIdentifier:@"navMenu"];
    UINavigationController *navFront = [self.storyboard instantiateViewControllerWithIdentifier:@"navCalendar"];
    
    appDelegate.revealController = [[SWRevealViewController alloc] initWithRearViewController:navMenu frontViewController:navFront];
    //    appDelegate.revealController.delegate = self;
    appDelegate.revealController.bounceBackOnOverdraw = NO;
    appDelegate.revealController.bounceBackOnLeftOverdraw = NO;
    appDelegate.revealController.frontViewShadowRadius = 0.2;
    appDelegate.revealController.rearViewRevealWidth = appDelegate.window.bounds.size.width*2/3;
    
    [self.navigationController pushViewController:appDelegate.revealController animated:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}

#pragma mark - WebNetworking

-(void)webNetworkingSessionDidCompleteWithResult:(NSDictionary *)result forRequest:(NSString *)requesrName{
    
    [appDelegate hideActivity];
    
    if([requesrName isEqualToString:@"UploadProfileImage"])
    {
        
        if ([result[@"Status"] isEqualToString:@"TRUE"]) {
            
            UserObject *obj = appDelegate.getUserObject;
            obj.user_profilePictureURL = result[@"UserImage"];
            [appDelegate saveUserObject:obj];
            
            [self success];
            [appDelegate hideActivityWithSuccess:[NSString stringWithFormat:@"Welcome %@",[appDelegate setNameOfUserFromFirstName:appDelegate.getUserObject.user_firstName.emojiDecode andUserName:appDelegate.getUserObject.user_name.emojiDecode]]];

        }
        else{
            
            [appDelegate hideActivityWithError:@"Image not uploded."];
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

-(void)webNetworkingSessionDidFailWithError:(NSError *)error forRequest:(NSString *)requesrName{
    
    [appDelegate hideActivityWithError:error.localizedDescription];
    
}

#pragma mark - 

- (void)syncFacebookEventFromController:(id)controller{
    
//    [appDelegate showActivityWithStatus:@"Getting Facebook events.."];
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    login.loginBehavior = FBSDKLoginBehaviorSystemAccount;
    [login logInWithReadPermissions: @[@"public_profile",@"email",@"user_friends"]
                 fromViewController:self
                            handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         
         if (error) {
             [appDelegate hideActivityWithError:error.localizedDescription];
             [self success];

             NSLog(@"Process error");
             //             [[[UIAlertView alloc]initWithTitle:appName message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
             
             
         } else if (result.isCancelled) {
             [appDelegate hideActivityWithError:@"User cancelled syncing."];
             [self success];

             NSLog(@"Cancelled");
             //             [[[UIAlertView alloc]initWithTitle:@"Facebook" message:@"The user hasn't authorized the application to perform this action." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
             
         } else {
             
             NSLog(@"Logged in");
             
             appDelegate.arrFBEvents = [[NSMutableArray alloc] init];
             
             FBSDKGraphRequest *request1 = [[FBSDKGraphRequest alloc]
                                            initWithGraphPath:@"/me/events"
                                            parameters:@{ @"fields": @"description,start_time,end_time,name,place,id,rsvp_status,attending_count,maybe_count,owner,declined_count,can_guests_invite,attending.limit(10){name,picture{url}}",}
                                            HTTPMethod:@"GET"];
             
             [request1 startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                                    id result,
                                                    NSError *error) {
                 
                 if (!error){
                     
                     NSArray *arrFBEvent = result[@"data"];
                     NSMutableArray *tempArray = [NSMutableArray new];
                     
                     for (NSDictionary *dict in arrFBEvent)
                     {
                         NSMutableDictionary *dictEvent = [NSMutableDictionary new];
                         dictEvent[@"UserID"] = appDelegate.getUserObject.user_id;
                         dictEvent[@"FbEventID"] = dict[@"id"]?dict[@"id"]:@"";
                         dictEvent[@"FBUserID"] = dict[@"owner"][@"id"]?dict[@"owner"][@"id"]:@"";
                         dictEvent[@"event_creatorName"] = dict[@"owner"][@"name"]?dict[@"owner"][@"name"]:@"";
                         dictEvent[@"event_name"] = dict[@"name"]?dict[@"name"]:@"";
                         dictEvent[@"event_detail"] = dict[@"description"]?dict[@"description"]:@"";
                         dictEvent[@"event_startTime"] = [self getFacebookTime:dict[@"start_time"]];
                         dictEvent[@"event_endTime"] = [self getFacebookTime:dict[@"end_time"]];
                         dictEvent[@"event_location"] = dict[@"place"][@"name"]?dict[@"place"][@"name"]:@"";
                         dictEvent[@"event_latitiude"] = dict[@"place"][@"location"][@"latitude"]?dict[@"place"][@"location"][@"latitude"]:@"";
                         dictEvent[@"event_longitude"] = dict[@"place"][@"location"][@"longitude"]?dict[@"place"][@"location"][@"longitude"]:@"";
                         
                         [tempArray addObject:dictEvent];
                     }
                     
                     
                     [appDelegate showActivityWithStatus:@"Syncing Facebook Events.."];
                     [[WebNetworking new] sendRequestWithUrl:makeHangURL(FBEventSync)
                                                  parameater:@{@"FacebookSync":tempArray}
                                                    delegate:controller
                                             withRequestName:@"FacebookSync"];
                     
                 }
                 else {
                     [appDelegate hideActivityWithError:error.localizedDescription];
                     [self success];

                     NSLog(@"result: %@",[error description]);
                 }
             }];
         }
     }];
    
}

-(NSString*)getFacebookTime:(NSString*)strDate{
    
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSDate *d = [df dateFromString:strDate];
    
    if (d) {
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        return [df stringFromDate:d];
    }
    else
    {
        [df setDateFormat:@"yyyy-MM-dd"];
        d = [df dateFromString:strDate];
        
        if (d)
        {
            [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            return [df stringFromDate:d];
        }
        else{
            return @"";
            
        }
    }
}

@end
