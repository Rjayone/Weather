//
//  DataModel.m
//  Weather
//
//  Created by Admin on 10.04.15.
//  Copyright (c) 2015 Andrew Medvedev. All rights reserved.
//

#import "DataModel.h"


@implementation DataModel

@synthesize status;

- (instancetype)init
{
    self = [super init];
    return self;
}

+ (instancetype) initDataModelWithDictionary:(NSDictionary*) dict
{
    DataModel* data = [[DataModel alloc] init];
    data.clouds = [[dict[@"clouds"] stringValue] stringByAppendingString:@" %"];
    data.temperature = [[[NSNumber numberWithInteger:[dict[@"temp"][@"day"] integerValue] - 273]stringValue] stringByAppendingString:@"˚"];
    data.date = [NSDate dateWithTimeIntervalSince1970:[dict[@"dt"] integerValue]];
    data.humidity = [[dict[@"humidity"] stringValue] stringByAppendingString:@" %"];
    data.pressure = [dict[@"pressure"] stringValue];
    data.wind     = [[dict[@"speed"] stringValue] stringByAppendingString:@" km/h"];
    data.status   = dict[@"weather"][0][@"main"];
    
    return data;
}

@end
