//
//  ScanViewController.m
//  GeoScan-iOS
//
//  Created by Martin Kuvandzhiev on 5/17/16.
//  Copyright © 2016 Rapid Development Crew. All rights reserved.
//

#import "ScanViewController.h"
#import "DatabaseInformation.h"
#import "TransferItemsViewController.h"

@interface ScanViewController ()
{
    DatabaseInformation * database;
}

@property (weak, nonatomic) IBOutlet RDCodeScannerView *codeScannerView;
@property (weak, nonatomic) IBOutlet UILabel *cacheNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *cacheTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *addButtonProperty;
@property (nonatomic, strong) NSDictionary * scannedCache;

@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    database = [DatabaseInformation sharedInstance];
    self.codeScannerView.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logAddedSuccessfuly:) name:LOG_ADDED object:nil];
}

- (void) viewWillAppear:(BOOL)animated
{
    [self.codeScannerView startReading];
    self.cacheNameLabel.hidden = YES;
    self.cacheTitleLabel.hidden = YES;
    self.addButtonProperty.hidden = YES;
    self.cacheNameLabel.text = nil;
    self.scannedCache = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([[segue destinationViewController] isKindOfClass:[TransferItemsViewController class]])
    {
        [[segue destinationViewController] performSelector:@selector(setLocation:) withObject:self.scannedCache];
    }
}

- (void) codeScanned:(RDCodeScannerView *)object codeData:(NSString *)codeData
{
    [self cacheAvailabiltyForName:codeData];
}

- (void) cacheAvailabiltyForName: (NSString *) cacheName
{
    if([[self.scannedCache objectForKey:@"name" ] isEqualToString:cacheName]) return;
    
    for(NSDictionary * aDictionary in database.locations)
    {
        if([[aDictionary objectForKey:@"name"] isEqualToString:cacheName])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.scannedCache = aDictionary;
                self.cacheTitleLabel.text = cacheName;
                self.cacheTitleLabel.hidden = false;
                self.cacheNameLabel.hidden = false;
                self.addButtonProperty.hidden = false;
                [database updateLocationItemsForLocation:[aDictionary objectForKey:@"id"]];
                
            });
            return;
        }
    }
}

- (IBAction)addButtonPressHandler:(id)sender {
    [database addDataToLogsForUserId:[database.userdata objectForKey:@"id"] atLocationId:[self.scannedCache objectForKey:@"id"]];
}

- (void) logAddedSuccessfuly: (NSNotification *) notification
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Success" message:@"Location log added successfuly" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction * tradeAction = [UIAlertAction actionWithTitle:@"Transfer Items" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSegueWithIdentifier:@"tradeItemsSegue" sender:self];
        });
    }];
    [alertController addAction:okAction];
    [alertController addAction:tradeAction];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alertController animated:YES completion:^{
        }];

    });
    }

@end
