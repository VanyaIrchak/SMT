//
//  LocationsListViewController.m
//  SMT
//
//  Created by Alexander on 06.05.14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import "SelectLocationViewController.h"
#import "SettingsViewController.h"
#import "DataLoader.h"
#import "Location.h"
#import "AppDelegate.h"

@interface SelectLocationViewController ()
{
    AppDelegate *appDelegate;
}
@end

@implementation SelectLocationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    DataLoader *loader = [[DataLoader alloc]init];
    appDelegate = [UIApplication sharedApplication].delegate;
    if (appDelegate.listLocations==nil) {
        [loader getLocationsAssociatedWithUser];
    }
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return appDelegate.listLocations.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    Location *location = (Location*)[appDelegate.listLocations objectAtIndex:indexPath.row];
    cell.textLabel.text = location.locName;
    cell.imageView.image = [UIImage imageNamed:@"compass.png"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<LocationListViewControllerDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(selectLocation:)]) {
        [delegate selectLocation:[appDelegate.listLocations objectAtIndex:indexPath.row]];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelButtonTap:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
