//
//  DetailViewController.m
//  Weather
//
//  Created by Admin on 09.04.15.
//  Copyright (c) 2015 Andrew Medvedev. All rights reserved.
//

#import "DetailViewController.h"
#import "WeatherCell.h"
#import "DataModel.h"

static NSString* kWeatherIconSunny  = @"https://ssl.gstatic.com/onebox/weather/256/sunny.png";
static NSString* kWeatherIconCloudy = @"https://ssl.gstatic.com/onebox/weather/256/cloudy.png";
static NSString* kWeatherIconRain   = @"https://ssl.gstatic.com/onebox/weather/256/rain.png";

@implementation DetailViewController

//--------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView.layer.borderWidth = 1.f;
    _tableView.layer.borderColor = [[UIColor colorWithWhite:0.8 alpha:1] CGColor];
    
    //swipe
    UISwipeGestureRecognizer* swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(actionSwipeRight:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    UISwipeGestureRecognizer* swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(actionSwipeLeft:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.tableView addGestureRecognizer:swipeRight];
    [self.tableView addGestureRecognizer:swipeLeft];
}

//--------------------------------------------------------------------------
- (void) reciveData:(NSDictionary *)result
{
    NSLog(@"Recive Data");
    [self parseDataFromDictionary:result];
    
    _weatherStatus.text = result[@"list"][0][@"weather"][0][@"main"];
    if([_weatherStatus.text isEqualToString:@"Clear"])
    {
        _backgroundImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:kWeatherIconSunny]]];
    }
    if([_weatherStatus.text isEqualToString:@"Rain"])
    {
       _backgroundImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:kWeatherIconRain]]];
    }
    if([_weatherStatus.text isEqualToString:@"Clouds"])
    {
        _backgroundImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:kWeatherIconCloudy]]];
    }
    _city.text = result[@"city"][@"name"];
    _temperature.text = [[[NSNumber numberWithInteger:[result[@"list"][0][@"temp"][@"day"] integerValue] - 273]stringValue] stringByAppendingString:@"˚"];
}

//--------------------------------------------------------------------------
- (void) parseDataFromDictionary:(NSDictionary*) data
{
    if(_data == NULL)
        _data = [[NSMutableArray alloc] init];
    
    NSInteger daysCount = [data[@"cnt"] integerValue];
    _pageControl.numberOfPages = daysCount;
    for(int i = 0; i < daysCount; i++)
    {
        DataModel* day = [[DataModel alloc] init];
        NSDictionary* list  = data[@"list"][i];
        day.clouds = [[list[@"clouds"] stringValue] stringByAppendingString:@" %"];
        day.temperature = [[[NSNumber numberWithInteger:[list[@"temp"][@"day"] integerValue] - 273]stringValue] stringByAppendingString:@"˚"];
        day.date = [NSDate dateWithTimeIntervalSince1970:[list[@"dt"] integerValue]];
        day.humidity = [[list[@"humidity"] stringValue] stringByAppendingString:@" %"];
        day.pressure = [list[@"pressure"] stringValue];
        day.wind     = [[list[@"speed"] stringValue] stringByAppendingString:@" km/h"];
        day.status = list[@"weather"][0][@"main"];
        
        [_data addObject:day];
    }
}

//--------------------------------------------------------------------------
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//--------------------------------------------------------------------------
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

//--------------------------------------------------------------------------
- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellName = @"WeatherCell";
    WeatherCell* cell = (WeatherCell*)[tableView dequeueReusableCellWithIdentifier:cellName];
    if(!cell)
    {
        cell = [WeatherCell new];
    }
    else
    {
        DataModel* currentDay = [_data objectAtIndex:_pageControl.currentPage];
        if(currentDay != NULL)
        {
            cell.pressure.text = currentDay.pressure;
            cell.wind.text     = currentDay.wind;
            cell.humidity.text = currentDay.humidity;
            cell.cloud.text    = currentDay.clouds;
            cell.temperature.text = currentDay.temperature;
            NSDateFormatter *dateFormatter = [NSDateFormatter new];
            [dateFormatter setDateStyle:NSDateFormatterShortStyle];
            cell.date.text     = [dateFormatter stringFromDate:currentDay.date];
            if([currentDay.status isEqualToString:@"Clear"])
            {
                cell.image.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:kWeatherIconSunny]]];
            }
            if([currentDay.status  isEqualToString:@"Rain"])
            {
                cell.image.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:kWeatherIconRain]]];
            }
            if([currentDay.status  isEqualToString:@"Clouds"])
            {
                cell.image.image= [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:kWeatherIconCloudy]]];
            }
        }
    }
    return cell;
}


#pragma mark - Gesture

- (void) actionSwipeRight:(UISwipeGestureRecognizer*) swipe
{
    if([_tableView isEditing])
        return;
    
    // 0 - назад, 1 - вперед
    [self animation:UIViewAnimationOptionTransitionCurlDown playForDirection:0];
    _pageControl.currentPage -= 1;
    if(_pageControl.currentPage < 0)
        _pageControl.currentPage = 0;
}

- (void) actionSwipeLeft:(UISwipeGestureRecognizer*) swipe
{
    if([_tableView isEditing])
        return;
    
    [self animation:UIViewAnimationOptionTransitionCurlUp playForDirection:1];
    _pageControl.currentPage += 1;
    if(_pageControl.currentPage > _pageControl.numberOfPages-1)
        _pageControl.currentPage = _pageControl.numberOfPages-1;
}


// 0 - назад, 1 - вперед
- (void) animation:(NSInteger) animationType playForDirection:(NSInteger) dir
{
    if(dir <= 0)
    {
        if(_pageControl.currentPage != 0)
        {
            [UIView transitionWithView: _tableView
                              duration: 0.7f
                               options: animationType
                            animations: ^(void)
             {
                 [self.tableView reloadData];
                 [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
             }
                            completion: ^(BOOL isFinished)
             {
                 [[UIApplication sharedApplication] endIgnoringInteractionEvents];
             }];
        }
    }
    else if( dir >= 1)
    {
        if(_pageControl.currentPage != _pageControl.numberOfPages-1)
        {
            [UIView transitionWithView: _tableView
                              duration: 0.7f
                               options: animationType
                            animations: ^(void)
             {
                 [self.tableView reloadData];
                 [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
             }
                            completion: ^(BOOL isFinished)
             {
                 [[UIApplication sharedApplication] endIgnoringInteractionEvents];
             }];
        }
    }
}

@end
