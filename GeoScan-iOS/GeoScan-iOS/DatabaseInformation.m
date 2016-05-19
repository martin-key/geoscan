//
//  DatabaseInformation.m
//  GeoScan-iOS
//
//  Created by Martin Kuvandzhiev on 5/17/16.
//  Copyright © 2016 Rapid Development Crew. All rights reserved.
//

#import "DatabaseInformation.h"


@implementation DatabaseInformation

+ (instancetype)sharedInstance
{
    static DatabaseInformation *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DatabaseInformation alloc] init];
    });
    return sharedInstance;
}

- (instancetype) init
{
    self = [super init];
    if(self)
    {
        self.userdata = [[NSMutableDictionary alloc] init];
    }
    return self;
}






- (void) loginWithName: (NSString *) name andPassword: (NSString *) password
{
    NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession* session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
    
    /* Create the Request:
     Login (GET http://rapiddevcrew.com/geoscan/)
     */
    
    NSURL* URL = [NSURL URLWithString:@"http://rapiddevcrew.com/geoscan/"];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"GET";
    
    // Headers

    [request addValue:[NSString stringWithFormat: @"{\"username\":\"%@\", \"password\":\"%@\"}", name, password] forHTTPHeaderField:@"Credentials"];
    
    /* Start a new Task */
    __block NSString * usernameString = [NSString stringWithString:name];
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            // Success
            NSLog(@"URL Session Task Succeeded: HTTP %ld", ((NSHTTPURLResponse*)response).statusCode);
            if(((NSHTTPURLResponse*)response).statusCode == 200)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_SUCCESSFUL object:self];
                [self.userdata setObject:usernameString forKey:@"username"];
            }
            else
                
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_NOT_SUCCESSFUL object:self];
            }
        }
        else {
            // Failure
            NSLog(@"URL Session Task Failed: %@", [error localizedDescription]);
            [[NSNotificationCenter defaultCenter] postNotificationName:CONNECTION_PROBLEMS object:self];
        }
    }];
    [task resume];

}






- (void) registerUserWithUsername: (NSString *) username password: (NSString *) password email: (NSString *) email firstname: (NSString *) firstname lastname: (NSString *) lastname
{
    NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    /* Create session, and optionally set a NSURLSessionDelegate. */
    NSURLSession* session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
    
    /* Create the Request:
     Register (POST http://rapiddevcrew.com/geoscan/register/)
     */
    
    NSURL* URL = [NSURL URLWithString:@"http://rapiddevcrew.com/geoscan/register/"];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"POST";
    
    // JSON Body
    
    NSDictionary* bodyObject = @{
                                 @"email": email,
                                 @"password": password,
                                 @"username": username,
                                 @"name": firstname,
                                 @"familyName": lastname
                                 };
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:bodyObject options:kNilOptions error:NULL];
    
    /* Start a new Task */
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            // Success
            NSLog(@"URL Session Task Succeeded: HTTP %ld", ((NSHTTPURLResponse*)response).statusCode);
            if(((NSHTTPURLResponse*)response).statusCode == 200)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:REGISTRATION_SUCCESSFUL object:self];
            }
            else
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:REGISTRATION_NOT_SUCCESSFUL object:self];
            }
        }
        else {
            // Failure
            NSLog(@"URL Session Task Failed: %@", [error localizedDescription]);
            [[NSNotificationCenter defaultCenter] postNotificationName:CONNECTION_PROBLEMS object:self];
        }
    }];
    [task resume];
}






- (void) updateUserData
{
    NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    /* Create session, and optionally set a NSURLSessionDelegate. */
    NSURLSession* session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
    
    /* Create the Request:
     getUserInfo (GET http://rapiddevcrew.com/geoscan/userinfo/)
     */
    
    NSURL* URL = [NSURL URLWithString:@"http://rapiddevcrew.com/geoscan/userinfo/"];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"GET";
    
    // Headers
    
    [request addValue:[NSString stringWithFormat:@"{\"username\":\"%@\"}", [self.userdata objectForKey:@"username"]] forHTTPHeaderField:@"Credentials"];
    
    
    __block NSMutableArray * responseArray = [[NSMutableArray alloc] init];
    /* Start a new Task */
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            // Success
            responseArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error: &error];
            NSDictionary * responseDictionary = [NSDictionary dictionaryWithDictionary:[responseArray objectAtIndex:0]];
            [self.userdata setValuesForKeysWithDictionary:responseDictionary];
            [[NSNotificationCenter defaultCenter] postNotificationName:USERDATA_UPDATED object:self];
        }
        else {
            // Failure
            [[NSNotificationCenter defaultCenter] postNotificationName:CONNECTION_PROBLEMS object:self];
        }
    }];
    [task resume];

}





- (void) updateItemsData
{
    NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    /* Create session, and optionally set a NSURLSessionDelegate. */
    NSURLSession* session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
    
    /* Create the Request:
     getItems (GET http://rapiddevcrew.com/geoscan/getItems/)
     */
    
    NSURL* URL = [NSURL URLWithString:@"http://rapiddevcrew.com/geoscan/getItems/"];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"GET";
    
    __block NSMutableArray * responseArray = [[NSMutableArray alloc] init];
    /* Start a new Task */
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            // Success
            responseArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error: &error];
            self.items = [NSMutableArray arrayWithArray:responseArray];
            [[NSNotificationCenter defaultCenter] postNotificationName:ITEMDATA_UPDATED object:self];
        }
        else {
            // Failure
            [[NSNotificationCenter defaultCenter] postNotificationName:CONNECTION_PROBLEMS object:self];
        }
    }];
    [task resume];

}





- (void) updateLocationsData
{
    NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
    
    /* Create the Request:
     getLocations (GET http://rapiddevcrew.com/geoscan/getLocations/)
     */
    
    NSURL* URL = [NSURL URLWithString:@"http://rapiddevcrew.com/geoscan/getLocations/"];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"GET";
    
     __block NSMutableArray * responseArray = [[NSMutableArray alloc] init];
    /* Start a new Task */
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            // Success
            responseArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error: &error];
            self.locations = [NSMutableArray arrayWithArray:responseArray];
            [[NSNotificationCenter defaultCenter] postNotificationName:LOCATIONDATA_UPDATE object:self];
        }
        else {
            // Failure
           [[NSNotificationCenter defaultCenter] postNotificationName:CONNECTION_PROBLEMS object:self];
        }
    }];
    [task resume];
}



- (void) updateLogsData
{
    NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    /* Create session, and optionally set a NSURLSessionDelegate. */
    NSURLSession* session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
    
    /* Create the Request:
     getLogsForUser (GET http://rapiddevcrew.com/geoscan/getLogs/)
     */
    
    NSURL* URL = [NSURL URLWithString:@"http://rapiddevcrew.com/geoscan/getLogs/"];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"GET";
    
    // Headers
    
    [request addValue:[NSString stringWithFormat:@"{\"user_id\":\"%@\"}", [self.userdata valueForKey:@"id"]] forHTTPHeaderField:@"data"];
    
     __block NSMutableArray * responseArray = [[NSMutableArray alloc] init];
    
    /* Start a new Task */
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            // Success
            responseArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error: &error];
            self.logs = [NSMutableArray arrayWithArray:responseArray];
            [[NSNotificationCenter defaultCenter] postNotificationName:LOGS_UPDATED object:self];
        }
        else {
            [[NSNotificationCenter defaultCenter] postNotificationName:CONNECTION_PROBLEMS object:self];
        }
    }];
    [task resume];

}



@end