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



@end