//
//  HomeViewController.m
//  GeoScan-iOS
//
//  Created by Martin Kuvandzhiev on 5/17/16.
//  Copyright © 2016 Rapid Development Crew. All rights reserved.
//

#import "HomeViewController.h"
#import "DatabaseInformation.h"


@interface HomeViewController ()
{
    DatabaseInformation * database;
}
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    database = [DatabaseInformation sharedInstance];
    [database updateUserData];
    [database updateItemsData];
    [database updateLocationsData];
    [database updateLogsData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userdataUpdatedNotificationHandler:) name:USERDATA_UPDATED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemdataUpdateNotificationHandler:) name:ITEMDATA_UPDATED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationsUpdatedNotificationHandler:) name:LOCATIONDATA_UPDATE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logsUpdatedNotificationHandler:) name:LOGS_UPDATED object:nil];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) userdataUpdatedNotificationHandler: (NSNotification *) notification
{
    NSLog(@"%@", database.userdata);
}

- (void) itemdataUpdateNotificationHandler: (NSNotification *) notification
{
    NSLog(@"%@", database.items);
}

- (void) locationsUpdatedNotificationHandler: (NSNotification *) notification
{
    NSLog(@"%@", database.locations);
}

- (void) logsUpdatedNotificationHandler: (NSNotification *) notification
{
    NSLog(@"%@", database.logs);
}
@end
