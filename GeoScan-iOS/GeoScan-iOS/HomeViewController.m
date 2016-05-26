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
    __weak IBOutlet UILabel *usernameLabel;
    NSTimer * timer;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    database = [DatabaseInformation sharedInstance];
    [database updateUserData];
    [database updateItemsData];
    [database updateLocationsData];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userdataUpdatedNotificationHandler:) name:USERDATA_UPDATED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemdataUpdateNotificationHandler:) name:ITEMDATA_UPDATED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationsUpdatedNotificationHandler:) name:LOCATIONDATA_UPDATE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logsUpdatedNotificationHandler:) name:LOGS_UPDATED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(useritemsUpdateNotificationHandler:) name:USERITEMS_UPDATED object:nil];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(updateTimeSinceLastCache) userInfo:nil repeats:YES];
    // Do any additional setup after loading the view.
}

- (void) dealloc
{
    [timer invalidate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"homeScreenCellIdentifier"];
    switch(indexPath.row)
    {
        case 0:
            cell.textLabel.text = @"Last cache";
            cell.detailTextLabel.text = [[database.logs objectAtIndex:0] objectForKey:@"location_name"];
            break;
        case 1:
        {
            cell.textLabel.text = @"Last cache time";
            NSString * dateAndTime = [[[database logs] objectAtIndex:0] objectForKey:@"date"];
            NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate * dateToShow = [dateFormatter dateFromString:dateAndTime];
            [dateFormatter setDateStyle:NSDateFormatterShortStyle];
            [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
            dateFormatter.doesRelativeDateFormatting = YES;
            cell.detailTextLabel.text = [dateFormatter stringFromDate:dateToShow];
        }
            break;
        case 2:
        {
            cell.textLabel.text = @"Time since last cache";
            NSString * dateAndTime = [[[database logs] objectAtIndex:0] objectForKey:@"date"];
            if(dateAndTime == nil) break;
            NSTimeZone *tz = [NSTimeZone systemTimeZone];
            NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            [dateFormatter setTimeZone:tz];
            
            NSDate * dateOfLastCache = [dateFormatter dateFromString:dateAndTime];
            NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970] - [dateOfLastCache timeIntervalSince1970];
            
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%zd:%02d:%02d", (int)timeInterval/3600, ((int) timeInterval % 3600)/60, (int)timeInterval % 60];
        }
            break;
        case 3:
        {
            cell.textLabel.text = @"Caches";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%zd", [[database logs] count]];
        }
            break;
            
        case 4:
        {
            cell.textLabel.text = @"Points";
            cell.detailTextLabel.text = [database.userdata valueForKey:@"points"];
        }
        default:
            break;
    }
    
    return cell;
}

- (void) updateTimeSinceLastCache
{
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}

- (void) userdataUpdatedNotificationHandler: (NSNotification *) notification
{
    [database updateLogsData];
    [database updateUserItems];
    dispatch_async(dispatch_get_main_queue(), ^{
        usernameLabel.text = [database.userdata objectForKey:@"username"];
    });
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
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
    NSLog(@"%@", database.logs);
}

- (void) useritemsUpdateNotificationHandler: (NSNotification *) notification
{
    NSLog(@"%@", database.userItems);
}
@end
