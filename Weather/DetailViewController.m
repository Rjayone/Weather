//
//  DetailViewController.m
//  Weather
//
//  Created by Admin on 09.04.15.
//  Copyright (c) 2015 Andrew Medvedev. All rights reserved.
//

#import "DetailViewController.h"

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void) reciveData:(NSDictionary *)result
{
    NSLog(@"Recive Data");
    _segueResult = result;
    NSString* status = result[@"list"][0][@"weather"][0][@"main"];
    _weatherStatus.text = status;
    _city.text = _segueResult[@"city"][@"name"];
}
@end
