//
//  DetailViewController.m
//  Weather
//
//  Created by Admin on 09.04.15.
//  Copyright (c) 2015 Andrew Medvedev. All rights reserved.
//

#import "DetailViewController.h"
#import "WeatherCell.h"

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void) reciveData:(NSDictionary *)result
{
    NSLog(@"Recive Data");
    _segueResult = result;
    _weatherStatus.text = _segueResult[@"list"][0][@"weather"][0][@"main"];
    _city.text = _segueResult[@"city"][@"name"];
    NSNumber* temp = _segueResult[@"list"][0][@"temp"][@"day"];
    _temperature.text = [[[NSNumber numberWithInt:[temp doubleValue] - 273]stringValue] stringByAppendingString:@"˚"];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellName = @"WeatherCell";
    WeatherCell* cell = (WeatherCell*)[tableView dequeueReusableCellWithIdentifier:cellName];
    if(!cell)
    {
        cell = [WeatherCell new];
    }
    return cell;
}

@end
