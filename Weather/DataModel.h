//
//  DataModel.h
//  Weather
//
//  Created by Admin on 10.04.15.
//  Copyright (c) 2015 Andrew Medvedev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataModel : NSObject

@property (strong, nonatomic) NSString* temperature;
@property (strong, nonatomic) NSString* pressure;
@property (strong, nonatomic) NSString* wind;
@property (strong, nonatomic) NSString* humidity;
@property (strong, nonatomic) NSString* clouds;
@property (strong, nonatomic) NSDate* date;
@property (strong, nonatomic) NSString* status;

@end
