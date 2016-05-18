//
//  ScanViewController.m
//  GeoScan-iOS
//
//  Created by Martin Kuvandzhiev on 5/17/16.
//  Copyright © 2016 Rapid Development Crew. All rights reserved.
//

#import "ScanViewController.h"


@interface ScanViewController ()

@property (weak, nonatomic) IBOutlet RDCodeScannerView *codeScannerView;

@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.codeScannerView.delegate = self;
}

- (void) viewWillAppear:(BOOL)animated
{
    [self.codeScannerView startReading];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) codeScanned:(RDCodeScannerView *)object codeData:(NSString *)codeData
{
    NSLog(@"%@\n", codeData);
}


@end
