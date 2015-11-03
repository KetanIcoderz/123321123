//
//  ProfilePictureViewController.m
//  Hang
//
//  Created by iCoderz_Ankit on 9/25/15.
//  Copyright © 2015 iCoderz. All rights reserved.
//

#import "ProfilePictureViewController.h"

@interface ProfilePictureViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,WebNetworkingDelegate>

@end

@implementation ProfilePictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [appDelegate setBackbuttonIfNeededInController:self];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"save"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(updateProfilePicture)];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    NSString *strURL = appDelegate.getUserObject.user_profilePictureURL;
    [imgView setImageWithURL:[NSURL URLWithString:strURL]];
}

-(void)viewDidLayoutSubviews{
    imgView.layer.cornerRadius = imgView.frame.size.height/2;
    imgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    imgView.layer.borderWidth = 1.0;
    imgView.layer.masksToBounds = YES;
    
    imgBg.layer.cornerRadius = imgBg.frame.size.height/2;
    imgBg.layer.borderColor = [UIColor lightGrayColor].CGColor;
    imgBg.layer.borderWidth = 1.0;
    imgBg.layer.masksToBounds = YES;

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(IBAction)Facebook:(id)sender
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
                     NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:str]];
                     imgView.image = [UIImage imageWithData:data];
                     [self updateProfilePicture];
                     
                 }
                 else {
                     NSLog(@"result: %@",[error description]);
                 }
             }];
             
         }
     }];
}

-(IBAction)Gallary:(id)sender
{
    UIImagePickerController *picker1 = [[UIImagePickerController alloc] init];
    picker1.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker1.allowsEditing = YES;
    picker1.delegate = self;
    
    [self presentViewController:picker1 animated:YES completion:nil];
}

-(IBAction)Camera:(id)sender{
    
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

-(void)updateProfilePicture{
    
    if (imgView.image) {
        
        [[WebNetworking new] uploadImageWithUrl:makeUserURL(UploadProfileImage)
                                     parameater:@{@"UserID":appDelegate.getUserObject.user_id}
                                      imageData:UIImageJPEGRepresentation(imgView.image, 0.5)
                                      imageName:appDelegate.getUserObject.user_id
                                       delegate:self
                                withRequestName:@"UploadProfileImage"];
        [appDelegate showActivityWithStatus:@"Uploading Image.."];
    }

}

#pragma mark - UIImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        imgView.image = info[UIImagePickerControllerEditedImage];
        [self updateProfilePicture];
    }];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - WebNetworking

-(void)webNetworkingSessionDidCompleteWithResult:(NSDictionary *)result forRequest:(NSString *)requesrName{
    
    if([requesrName isEqualToString:@"UploadProfileImage"]){
        
        if ([result[@"Status"] isEqualToString:@"TRUE"]) {
            
            UserObject *obj = appDelegate.getUserObject;
            obj.user_profilePictureURL = result[@"UserImage"];
            [appDelegate saveUserObject:obj];
            
            [appDelegate hideActivityWithSuccess:@"Profile picture uploaded successfully."];
        }
        else{
            
            [appDelegate hideActivityWithError:@"Image not uploded."];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)webNetworkingSessionDidFailWithError:(NSError *)error forRequest:(NSString *)requesrName{
    
    [appDelegate hideActivityWithError:error.localizedDescription];
    
}



@end
