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
    _data = [[NSMutableArray alloc] init];
    
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
    
    NSInteger daysCount = [result[@"cnt"] integerValue];
    _pageControl.numberOfPages = daysCount;
    
    [self parseDataFromDictionary:result];
    [self initTodayViewWithDictionary:result];
}

//--------------------------------------------------------------------------
- (void) parseDataFromDictionary:(NSDictionary*) data
{
    for(int i = 0; i < _pageControl.numberOfPages; i++)
    {
        NSDictionary* list  = data[@"list"][i];
        [_data addObject:[DataModel initDataModelWithDictionary:list]];
    }
}

//--------------------------------------------------------------------------
- (void) initTodayViewWithDictionary:(NSDictionary*) result
{
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
        DataModel* currentDay = [_data objectAtIndex:_pageControl.currentPage];
        cell = [WeatherCell initWithDataModel:currentDay];
    }
    return cell;
}



#pragma mark - Gesture

//--------------------------------------------------------------------------
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

//--------------------------------------------------------------------------
- (void) actionSwipeLeft:(UISwipeGestureRecognizer*) swipe
{
    if([_tableView isEditing])
        return;
    
    [self animation:UIViewAnimationOptionTransitionCurlUp playForDirection:1];
    _pageControl.currentPage += 1;
    if(_pageControl.currentPage > _pageControl.numberOfPages-1)
        _pageControl.currentPage = _pageControl.numberOfPages-1;
}


//--------------------------------------------------------------------------
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
