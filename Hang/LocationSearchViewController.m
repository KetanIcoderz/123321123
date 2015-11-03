
//
//  TblViewController.m
//  actionSheet
//
//  Created by icoderz_hardik on 11/09/15.
//  Copyright (c) 2015 icoderz_raj. All rights reserved.
//

#import "LocationSearchViewController.h"

#import "CreateEventViewController.h"


#define Google_API_KEY @"AIzaSyDLRz9TsF_ID0juxN1JvO01sugxD4Eg51E"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface LocationSearchViewController ()

@end

@implementation LocationSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationItem.rightBarButtonItem setTarget:self];
    [self.navigationItem.rightBarButtonItem setAction:@selector(close)];
    
//    tblVw.tableFooterView = [UIView new];
    [searchBar1 setBackgroundImage:[UIImage new] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    
    searchView.frame = CGRectMake(0, 0, searchView.frame.size.width, 44);
    [self.navigationItem setTitleView:searchView];
    
    if (appDelegate.currentLocation.coordinate.latitude == 37.7577 &&
        appDelegate.currentLocation.coordinate.longitude == -122.4376) {
        
        [[[UIAlertView alloc]initWithTitle:@"Allow Hang to access you location while you use the app?" message:@"If you want to allow location access then tap allow and select location value to 'While Using the App'." delegate:self cancelButtonTitle:@"Don't Allow" otherButtonTitles:@"Allow", nil] show];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    
}

#pragma mark - UIAlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex != alertView.cancelButtonIndex) {
        
        if (UIApplicationOpenSettingsURLString != nil) {
            NSURL *appSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication] openURL:appSettings];
        }
        
    }
}

#pragma mark - 

-(void)close{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(NSString*)getLocation:(CLLocationCoordinate2D)corinates{
    
    NSString *strURL = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&sensor=false",corinates.latitude,corinates.longitude ];
    NSData *data1 = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    if([data1 length]<=0)
    {
        return @"";
    }
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingAllowFragments error:nil];
    
    NSDictionary *mostSpecificDictionary = [[dict objectForKey:@"results"] firstObject];
    
    return mostSpecificDictionary[@"formatted_address"];
}

-(void) setLocation :(NSString*)location WithCordindates:(CLLocationCoordinate2D)cordinates{
    
    CreateEventViewController *obj = (CreateEventViewController*)[((UINavigationController*)((SWRevealViewController*)[((UINavigationController*)self.presentingViewController).viewControllers lastObject]).frontViewController).viewControllers lastObject];
    obj.strLocation = location;
    obj.cord = cordinates;
    
    [self close];
}

#pragma mark - UITableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    if (section==0) {
        return (searchBar1.text.length == 0)?1:2;
    }
    else{
        return arr.count;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;{
    if (section==0) {
        return 0;
    }
    else{
        return 30;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 44;
    }
    else{
        return 48;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 22)];
    lbl.backgroundColor = [UIColor colorWithRed:65.0/255.0 green:125.0/255.0 blue:177.0/255.0 alpha:1.0];
    lbl.textColor = [UIColor whiteColor];
    lbl.text = @"\t\tLocations";
    
    return (section == 0)?nil:lbl;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.tintColor = [UIColor lightGrayColor];
    
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        if (searchBar1.text.length == 0) {
            cell.textLabel.text = @"Current Location";
            cell.textLabel.font = [UIFont systemFontOfSize:16.0];
            
            if (appDelegate.currentLocation) {
                cell.textLabel.textColor = [UIColor blackColor];
                cell.imageView.tintColor = kOrangeColor;
                cell.imageView.image = [[UIImage imageNamed:@"Navigate"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            }
            else{
                cell.textLabel.textColor = [UIColor lightGrayColor];
                cell.imageView.tintColor = [UIColor lightGrayColor];
                cell.imageView.image = [[UIImage imageNamed:@"Navigate"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            }
            
        }
        else{
            cell.textLabel.text = searchBar1.text;
            cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0];
            cell.textLabel.textColor = [UIColor blackColor];
            
            cell.imageView.tintColor = [UIColor lightGrayColor];
            cell.imageView.image = [[UIImage imageNamed:@"Location"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        }
        
    }
    else if (indexPath.section == 0 && indexPath.row == 1) {
        cell.textLabel.text = @"Current Location";
        cell.textLabel.font = [UIFont systemFontOfSize:16.0];
        
        if (appDelegate.currentLocation) {
            cell.textLabel.textColor = [UIColor blackColor];
            cell.imageView.tintColor = kOrangeColor;
            cell.imageView.image = [[UIImage imageNamed:@"Navigate"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        }
        else{
            cell.textLabel.textColor = [UIColor lightGrayColor];
            cell.imageView.tintColor = [UIColor lightGrayColor];
            cell.imageView.image = [[UIImage imageNamed:@"Navigate"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        }
        
    }
    else{
        cell.textLabel.font = [UIFont systemFontOfSize:14.0];
        cell.textLabel.text = arr[indexPath.row][@"description"];
        cell.imageView.tintColor = kOrangeColor;
        cell.imageView.image = [[UIImage imageNamed:@"Location"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    
    if ([cell respondsToSelector:@selector(preservesSuperviewLayoutMargins)]){
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.preservesSuperviewLayoutMargins = false;
    }
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        if (searchBar1.text.length == 0) {
            
            if (!appDelegate.currentLocation)
                return;
            
            searchBar1.text = [self getLocation:appDelegate.currentLocation.coordinate];
            [self setLocation:searchBar1.text WithCordindates:appDelegate.currentLocation.coordinate];
        }
        else{
            [self setLocation:searchBar1.text WithCordindates:CLLocationCoordinate2DMake(37.7577, -122.4376)];
        }
        
    }
    else if (indexPath.section == 0 && indexPath.row == 1) {
        
        if (!appDelegate.currentLocation)
            return;
        
        searchBar1.text = [self getLocation:appDelegate.currentLocation.coordinate];
        [self setLocation:searchBar1.text WithCordindates:appDelegate.currentLocation.coordinate];
    }
    else{
        searchBar1.text = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
        
        NSDictionary *dict = arr[indexPath.row];
        [self placIdDetail:dict[@"place_id"]];
    }
    
    
}

-(void)placIdDetail:(NSString *)str{
    
    NSString *urlfor=[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?placeid=%@&key=%@",str,Google_API_KEY];
    
    NSURL *googleRequestURL=[NSURL URLWithString:urlfor];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
        [self performSelectorOnMainThread:@selector(placeIdDetailResult:) withObject:data waitUntilDone:YES];
        
    });
}

- (void)placeIdDetailResult:(NSData *)responseData {
    
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          options:kNilOptions
                          error:&error];
    
    if ([json[@"status"] isEqualToString:@"OK"]) {
        
        float lat = [json[@"result"][@"geometry"][@"location"][@"lat"] floatValue];
        float lng = [json[@"result"][@"geometry"][@"location"][@"lng"] floatValue];
        
        NSString *location = searchBar1.text;
        CLLocationCoordinate2D cord = CLLocationCoordinate2DMake(lat,lng);
        
        [self setLocation:location WithCordindates:cord];
    }
}

#pragma mark- UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar;
{
    return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;
{
    NSString *googleSearch=[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&types=establishment&location=%f,%f&key=%@&radius=10000",[searchBar1.text urlencode],appDelegate.currentLocation.coordinate.latitude,appDelegate.currentLocation.coordinate.longitude,Google_API_KEY];
    
        NSURL *googleRequestURL=[NSURL URLWithString:googleSearch];
    dispatch_async(kBgQueue, ^{
        NSData* data      = [NSData dataWithContentsOfURL: googleRequestURL];
        [self performSelectorOnMainThread:@selector(searchResultFromGoogle:) withObject:data waitUntilDone:YES];
    });
}

- (void)searchResultFromGoogle:(NSData *)responseData {
    
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          options:kNilOptions
                          error:&error];
    arr=[NSMutableArray arrayWithArray:[json objectForKey:@"predictions"]];
    [tblVw reloadData];
}
@end
