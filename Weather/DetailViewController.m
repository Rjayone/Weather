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
    _city.text = result[@"city"][@"name"];
    NSNumber* temp = result[@"list"][0][@"temp"][@"day"];
    _temperature.text = [[[NSNumber numberWithInt:[temp doubleValue] - 273]stringValue] stringByAppendingString:@"˚"];
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
        day.temperature = [[[NSNumber numberWithInteger:[list[@"deg"] integerValue] - 273]stringValue] stringByAppendingString:@"˚"];
        day.date = [NSDate dateWithTimeIntervalSince1970:[list[@"dt"] integerValue]];
        day.humidity = [[list[@"humidity"] stringValue] stringByAppendingString:@" %"];
        day.pressure = [list[@"pressure"] stringValue];
        day.wind     = [[list[@"speed"] stringValue] stringByAppendingString:@" km/h"];
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
//            //cell.date.text     = [currentDay.date];
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
    if(_pageControl.currentPage > 5)
        _pageControl.currentPage = 5;
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
