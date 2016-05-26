//
//  itemsCollectionViewCell.h
//  GeoScan-iOS
//
//  Created by Martin Kuvandzhiev on 5/26/16.
//  Copyright © 2016 Rapid Development Crew. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemsCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *itemName;
@property (weak, nonatomic) IBOutlet UIImageView *itemImage;

@end
