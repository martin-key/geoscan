//
//  TransferItemsViewController.h
//  GeoScan-iOS
//
//  Created by Martin Kuvandzhiev on 5/26/16.
//  Copyright © 2016 Rapid Development Crew. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransferItemsViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSDictionary * location;

@end
