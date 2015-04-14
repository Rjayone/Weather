//
//  WeatherCell.m
//  Weather
//
//  Created by Admin on 09.04.15.
//  Copyright (c) 2015 Andrew Medvedev. All rights reserved.
//

#import "WeatherCell.h"
#import "DataModel.h"

static NSString* kWeatherStatusClear  = @"Clear";
static NSString* kWeatherStatusRain   = @"Rain";
static NSString* kWeatherStatusClouds = @"Clouds";


@implementation WeatherCell

+ (instancetype) initWithDataModel:(DataModel*) data
{
    WeatherCell* cell = [[WeatherCell alloc] init];

    cell.pressure.text = data.pressure;
    cell.wind.text     = data.wind;
    cell.humidity.text = data.humidity;
    cell.cloud.text    = data.clouds;
    cell.temperature.text = data.temperature;
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    cell.date.text     = [dateFormatter stringFromDate:data.date];
    
    if([data.status isEqualToString:kWeatherStatusClear])
        cell.image.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:kWeatherIconSunny]]];
    if([data.status  isEqualToString:kWeatherStatusRain])
        cell.image.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:kWeatherIconRain]]];
    if([data.status  isEqualToString:kWeatherStatusClouds])
        cell.image.image= [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:kWeatherIconCloudy]]];
    
    return cell;
}

@end
