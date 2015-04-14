//
//  WeatherCell.h
//  Weather
//
//  Created by Admin on 09.04.15.
//  Copyright (c) 2015 Andrew Medvedev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataModel;

static NSString* kWeatherIconSunny  = @"https://ssl.gstatic.com/onebox/weather/256/sunny.png";
static NSString* kWeatherIconCloudy =  @"https://ssl.gstatic.com/onebox/weather/256/cloudy.png";
static NSString* kWeatherIconRain   = @"https://ssl.gstatic.com/onebox/weather/256/rain.png";

@interface WeatherCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *pressure;
@property (weak, nonatomic) IBOutlet UILabel *wind;
@property (weak, nonatomic) IBOutlet UILabel *humidity;
@property (weak, nonatomic) IBOutlet UILabel *cloud;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *temperature;

+ (instancetype) initWithDataModel:(DataModel*) data;

@end
