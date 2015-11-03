//
//  PreLoginViewController.m
//  Hang
//
//  Created by iCoderz_Ankit on 9/9/15.
//  Copyright (c) 2015 iCoderz. All rights reserved.
//

#import "PreLoginViewController.h"

@interface PreLoginViewController ()

@end

@implementation PreLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    btnCreateAcc.layer.borderColor = [UIColor whiteColor].CGColor;
//    btnCreateAcc.layer.borderWidth = 2.0;
//    
//    btnLogin.layer.borderColor = [UIColor whiteColor].CGColor;
//    btnLogin.layer.borderWidth = 2.0;
    
    if (appDelegate.getUserObject) {
        [self success];
    }
    
    [appDelegate setBackbuttonIfNeededInController:self];
    
#if( IS_DEBUG )
#define MYLog(args...) NSLog(args)
#else
#define MYLog(args...)
#endif
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)viewDidLayoutSubviews{
    

}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
}

#pragma mark - 

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
    
}

@end
