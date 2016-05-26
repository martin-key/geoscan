//
//  ProfileViewController.m
//  GeoScan-iOS
//
//  Created by Martin Kuvandzhiev on 5/17/16.
//  Copyright © 2016 Rapid Development Crew. All rights reserved.
//

#import "ProfileViewController.h"
#import "ItemsCollectionViewCell.h"
#import "DatabaseInformation.h"


@interface ProfileViewController ()
{
    DatabaseInformation * database;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView registerNib:[UINib nibWithNibName:@"itemCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"profileItemViewIdentifier"];

    database = [DatabaseInformation sharedInstance];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.collectionView reloadData];
    [self.tableView reloadData];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"profileTableCellIdentifier" forIndexPath:indexPath];
    
    switch(indexPath.row)
    {
        case 0:
            cell.textLabel.text = @"Name";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", [database.userdata objectForKey:@"name"], [database.userdata objectForKey:@"familyName"]];
            break;
            
        case 1:
            cell.textLabel.text = @"Email";
            cell.detailTextLabel.text = [database.userdata objectForKey:@"email"];
            break;
            
        case 2:
            cell.textLabel.text = @"Rank";
            cell.detailTextLabel.text = @"Junior";
            break;
            
        case 3:
            cell.textLabel.text = @"Number of items";
            cell.detailTextLabel.text = [NSString stringWithFormat: @"%ld", [database.userItems count]];
            break;
            
        default:
            break;
    }
    return cell;
}


- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [database.userItems count];
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ItemsCollectionViewCell * cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"profileItemViewIdentifier" forIndexPath:indexPath];
    cell.itemImage.image = [UIImage imageNamed:[[database.userItems objectAtIndex:indexPath.row] valueForKey:@"name"]];
    cell.itemName.text = [[database.userItems objectAtIndex:indexPath.row] objectForKey:@"name"];
    
    return cell;
}
@end
