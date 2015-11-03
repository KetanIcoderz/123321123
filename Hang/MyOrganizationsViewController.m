//
//  MyOrganizationsViewController.m
//  Calender
//
//  Created by iCoderz_Binal on 28/09/15.
//  Copyright © 2015 iCoderz_Binal. All rights reserved.
//

#import "MyOrganizationsViewController.h"

#import "MyOrganizationTableViewCell.h"
#import "OrganizationObject.h"
#import "OrganizationDetailViewController.h"
#import "CreateOrganizationViewController.h"

@interface MyOrganizationsViewController ()<WebNetworkingDelegate>

@end

@implementation MyOrganizationsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [appDelegate setMenuBarButtonInController:self];
    
    tblView.tableFooterView = [UIView new];
    arr_Organization = [NSMutableArray new];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    
    [arr_Organization removeAllObjects];
    
    [self getData];
}

-(void)getData{
    
    [[WebNetworking new] sendRequestWithUrl:makeHangURL(GetMyOrganization)
                                 parameater:@{@"org_creatorID":appDelegate.getUserObject.user_id}
                                   delegate:self
                            withRequestName:@"GetMyOrganization"];
    [appDelegate showActivityWithStatus:@"Getting organization.."];
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"ShowOrganizationDetail"])
    {
        NSIndexPath *indexPath = [tblView indexPathForSelectedRow];
        OrganizationObject *objOrganization = arr_Organization[indexPath.row];
        
        OrganizationDetailViewController *con = [segue destinationViewController];
        con.objOrganization = objOrganization;
    }
    else if ([segue.identifier isEqualToString:@"orgEdit"]){
        
        UINavigationController *nav = (UINavigationController*)[segue destinationViewController];
        CreateOrganizationViewController *obj = (CreateOrganizationViewController*)[nav.viewControllers firstObject];
        obj.objOrganization = arr_Organization[((NSIndexPath*)sender).row];
        
    }

}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arr_Organization.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyOrganizationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL_MyOrganization" forIndexPath:indexPath];
    
    OrganizationObject *objOrganization = arr_Organization[indexPath.row];
    
    cell.lbl_OrganizationName.text = objOrganization.org_name;
    cell.lbl_OrganizationFollowers.text = [NSString stringWithFormat:@"Following: %@", objOrganization.FollowersCount];
    [cell.btnEdit addTarget:self action:@selector(EditOrganization:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - Event Message
- (void)EditOrganization:(UIButton *)sender
{
    CGPoint touchPoint = [sender convertPoint:CGPointZero toView:tblView];
    NSIndexPath *indexPath = [tblView indexPathForRowAtPoint:touchPoint];
    
    [self performSegueWithIdentifier:@"orgEdit" sender:indexPath];
    
}

#pragma mark - WebNetworking Delegate

- (void)webNetworkingSessionDidCompleteWithResult:(NSDictionary*)result forRequest:(NSString*)requesrName{
    
    [appDelegate hideActivity];
    
    if ([requesrName isEqualToString:@"GetMyOrganization"]) {
        
        if ([result[@"Status"] isEqualToString:@"TRUE"]) {
            
            NSArray *arrTemp = result[@"OrganizationDetail"];
            
            for (NSDictionary *dict in arrTemp) {
                
                OrganizationObject *objOrganization = [OrganizationObject new];
                objOrganization.org_id = dict[@"org_id"];
                objOrganization.org_creatorID = dict[@"org_creatorID"];
                objOrganization.org_name = dict[@"org_name"];
                objOrganization.org_detail = dict[@"org_detail"];
                objOrganization.org_dateCreated = dict[@"org_dateCreated"];
                objOrganization.FollowersCount = dict[@"FollowersCount"];
                objOrganization.org_isPrivate = [dict[@"org_isPrivate"] boolValue];
                objOrganization.org_allowToShare = [dict[@"org_allowToShare"] boolValue];
                objOrganization.org_isActive = [dict[@"org_isActive"] boolValue];
                [arr_Organization addObject:objOrganization];
            }
            
            NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"org_name" ascending:YES selector:@selector(caseInsensitiveCompare:)];
            [arr_Organization sortUsingDescriptors:@[sd]];
            
            [tblView reloadData];
            
        }
        else{

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




@end
