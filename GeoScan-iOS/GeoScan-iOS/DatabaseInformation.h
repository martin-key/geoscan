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

@property (nonatomic, strong) NSMutableDictionary * userdata;
@property (nonatomic, strong) NSMutableArray * items;
@property (nonatomic, strong) NSMutableArray * geocaches;
@property (nonatomic, strong) NSMutableArray * locations;


+(instancetype)sharedInstance;

- (void) loginWithName: (NSString *) name andPassword: (NSString *) password;
- (void) registerUserWithUsername: (NSString *) username password: (NSString *) password email: (NSString *) email firstname: (NSString *) firstname lastname: (NSString *) lastname;

- (void) updateUserData;
- (void) updateItemsData;
- (void) updateGeocachesData;
- (void) updateLocationsData;



@end