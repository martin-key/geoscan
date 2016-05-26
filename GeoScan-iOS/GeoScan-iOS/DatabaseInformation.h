//
//  DatabaseInformation.h
//  GeoScan-iOS
//
//  Created by Martin Kuvandzhiev on 5/17/16.
//  Copyright © 2016 Rapid Development Crew. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface DatabaseInformation : NSObject

#define CONNECTION_PROBLEMS @"ConnectionProblems"

#define LOGIN_SUCCESSFUL @"LoginSuccessful"
#define LOGIN_NOT_SUCCESSFUL @"LoginUnsuccessful"

#define REGISTRATION_SUCCESSFUL @"RegistrationSuccessful"
#define REGISTRATION_NOT_SUCCESSFUL @"RegisterNotSuccessful"

#define USERDATA_UPDATED @"UserdataUpdated"
#define ITEMDATA_UPDATED @"ItemdataUpdated"
#define LOCATIONDATA_UPDATE @"LocationDataUpdated"
#define LOGS_UPDATED @"LogsUpdated"

#define LOG_ADDED @"LogAdded"
#define USERITEMS_UPDATED @"UseritemsUpdated"
#define USERITEMS_ADDED @"UseritemsAdded"
#define LOCATION_ITEMS_UPDATED @"LocationItemsUpdated"


@property (nonatomic, strong) __block NSMutableDictionary * userdata;
@property (nonatomic, copy) __block NSMutableArray * items;
@property (nonatomic, copy) __block NSMutableArray * userItems;
@property (nonatomic, copy) __block NSMutableArray * logs;
@property (nonatomic, copy) __block NSMutableArray * locations;
@property (nonatomic, copy) __block NSMutableArray * locationItems;

+(instancetype)sharedInstance;

- (void) loginWithName: (NSString *) name andPassword: (NSString *) password;
- (void) registerUserWithUsername: (NSString *) username password: (NSString *) password email: (NSString *) email firstname: (NSString *) firstname lastname: (NSString *) lastname;

- (void) updateUserData;
- (void) updateItemsData;
- (void) updateLogsData;
- (void) updateLocationsData;
- (void) updateUserItems;
- (void) addDataToLogsForUserId: (NSNumber *) userid atLocationId: (NSNumber *) locationId;


- (void) updateLocationItemsForLocation: (NSString *) locationId;
- (void) setUserItemsNotAvailable: (NSString *) userItemId;
- (void) setLocationItemAsNotAvilable: (NSString *) locationItemId;
- (void) addItem:(NSString *) itemId toLocation: (NSString *) locationId;
- (void) addItem: (NSString *) itemId toUser: (NSString *) userId;
- (void) transferItem:(NSString *) userItemId ToLocation:(NSString *) locationId;
- (void) transferItem:(NSString *) locationItemId ToUser:(NSString *) userId;


@end