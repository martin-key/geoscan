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

@property (nonatomic, strong) __block NSMutableDictionary * userdata;
@property (nonatomic, copy) __block NSMutableArray * items;
@property (nonatomic, copy) __block NSMutableArray * userItems;
@property (nonatomic, copy) __block NSMutableArray * logs;
@property (nonatomic, copy) __block NSMutableArray * locations;


+(instancetype)sharedInstance;

- (void) loginWithName: (NSString *) name andPassword: (NSString *) password;
- (void) registerUserWithUsername: (NSString *) username password: (NSString *) password email: (NSString *) email firstname: (NSString *) firstname lastname: (NSString *) lastname;

- (void) updateUserData;
- (void) updateItemsData;
- (void) updateLogsData;
- (void) updateLocationsData;



@end