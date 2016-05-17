//
//  DatabaseInformation.h
//  GeoScan-iOS
//
//  Created by Martin Kuvandzhiev on 5/17/16.
//  Copyright © 2016 Rapid Development Crew. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface DatabaseInformation : NSObject

@property (nonatomic, strong) NSMutableDictionary * userdata;
@property (nonatomic, strong) NSMutableArray * items;
@property (nonatomic, strong) NSMutableArray * geocaches;
@property (nonatomic, strong) NSMutableArray * locations;


+(instancetype)sharedInstance;

- (BOOL) loginWithName: (NSString *) name andPassword: (NSString *) password;

- (void) updateUserData;
- (void) updateItemsData;
- (void) updateGeocachesData;
- (void) updateLocationsData;



@end