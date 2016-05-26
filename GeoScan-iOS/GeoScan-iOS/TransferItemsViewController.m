//
//  TransferItemsViewController.m
//  GeoScan-iOS
//
//  Created by Martin Kuvandzhiev on 5/26/16.
//  Copyright © 2016 Rapid Development Crew. All rights reserved.
//

#import "TransferItemsViewController.h"
#import "DatabaseInformation.h"
#import "ItemsCollectionViewCell.h"


@interface TransferItemsViewController ()
{
    DatabaseInformation * database;
}
@property (weak, nonatomic) IBOutlet UICollectionView *locationItemsView;
@property (weak, nonatomic) IBOutlet UICollectionView *myItemsCollectionView;
@property (strong, nonatomic) NSMutableArray * selectedLocationItems;
@property (strong, nonatomic) NSMutableArray * selectedMyItems;

@end

@implementation TransferItemsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.locationItemsView registerNib:[UINib nibWithNibName:@"itemCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"itemsCell"];
    [self.myItemsCollectionView registerNib:[UINib nibWithNibName:@"itemCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"itemsCell"];
    database = [DatabaseInformation sharedInstance];
    self.selectedLocationItems = [[NSMutableArray alloc] init];
    self.selectedMyItems = [[NSMutableArray alloc] init];
    self.locationItemsView.allowsMultipleSelection = YES;
    self.myItemsCollectionView.allowsMultipleSelection = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationDataUpdatedNotificationHandler:) name:LOCATION_ITEMS_UPDATED object:nil];
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == self.locationItemsView) {
       return [database.locationItems count];
    }
    else
    {
        return [database.userItems count];
    }
}

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ItemsCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"itemsCell" forIndexPath:indexPath];
    if(collectionView == self.locationItemsView)
    {
        cell.itemName.text = [[database.locationItems objectAtIndex:indexPath.row] valueForKey:@"name"];
        cell.itemImage.image = [UIImage imageNamed:[[database.locationItems objectAtIndex:indexPath.row] valueForKey:@"name"]];
    }
    else
    {
        cell.itemName.text = [[database.userItems objectAtIndex:indexPath.row] valueForKey:@"name"];
        cell.itemImage.image = [UIImage imageNamed:[[database.userItems objectAtIndex:indexPath.row] valueForKey:@"name"]];
    }
    
    UIView * backgroundView = [[UIView alloc] init ];
    [backgroundView setBackgroundColor:[UIColor lightGrayColor]];
    cell.selectedBackgroundView = backgroundView;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView == self.locationItemsView)
    {
        [self.selectedLocationItems addObject: [database.locationItems objectAtIndex: indexPath.row]];
    }
    else
    {
        [self.selectedMyItems addObject: [database.userItems objectAtIndex: indexPath.row]];
    }
}

- (void) collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView == self.locationItemsView)
    {
        [self.selectedLocationItems removeObject: [database.locationItems objectAtIndex: indexPath.row]];
    }
    else
    {
        [self.selectedMyItems removeObject: [database.userItems objectAtIndex: indexPath.row]];
    }
}

- (IBAction)doneButtonPressed:(UIBarButtonItem *)sender {
    for(NSDictionary * aDictionary in self.selectedLocationItems)
    {
        [database transferItem:[aDictionary objectForKey:@"id"] ToUser:[database.userdata objectForKey:@"id"]];
    }
    for(NSDictionary * aDictionary in self.selectedMyItems)
    {
        [database transferItem:[aDictionary objectForKey:@"id"] ToLocation:[self.location objectForKey:@"id"]];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) locationDataUpdatedNotificationHandler: (NSNotification *) notification
{
    
}
@end
