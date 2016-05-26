//
//  StatisticsTableViewController.m
//  GeoScan-iOS
//
//  Created by Martin Kuvandzhiev on 5/17/16.
//  Copyright © 2016 Rapid Development Crew. All rights reserved.
//

#import "StatisticsTableViewController.h"
#import "DatabaseInformation.h"

@interface StatisticsTableViewController ()
{
    DatabaseInformation * database;
}
@end

@implementation StatisticsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    database = [DatabaseInformation sharedInstance];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [database.logs count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"statisticsCellIdentifier" forIndexPath:indexPath];
    
    cell.textLabel.text = [[[database logs] objectAtIndex:indexPath.row] objectForKey:@"location_name"];
    NSString * dateAndTime = [[[database logs] objectAtIndex:indexPath.row] objectForKey:@"date"];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * dateToShow = [dateFormatter dateFromString:dateAndTime];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    dateFormatter.doesRelativeDateFormatting = YES;
    
    cell.detailTextLabel.text = [dateFormatter stringFromDate:dateToShow]
    ;
    return cell;
}

@end
