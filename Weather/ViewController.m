//
//  ViewController.m
//  Weather
//
//  Created by Admin on 06.04.15.
//  Copyright (c) 2015 Andrew Medvedev. All rights reserved.
//

#import "ViewController.h"
#import "OWMWeatherAPI.h"
#import "DetailViewController.h"

//OpenWeatherMap API Key
static NSString* kAPIKey = @"47e5228bf1f19cca540208c888986822";

@implementation ViewController

//-----------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _information.alpha = 0;
    _longitude.alpha   = 0;
    _latitude.alpha    = 0;
    _search.alpha      = 0;
    
    [self moveView:_information toPoint:(CGPoint){_information.center.x, _information.center.y - 15} withDuration:1 andDelay:0.8];
    [self fadeView:_information toValue:1 withDuration:0.9 andDelay:0.8];
    [self fadeView:_latitude toValue:1 withDuration:0.5 andDelay:1.3];
    [self fadeView:_longitude toValue:1 withDuration:0.5 andDelay:1.4];
    [self fadeView:_search toValue:1 withDuration:0.5 andDelay:1.5];
    
    _weatherAPI = [[OWMWeatherAPI alloc] initWithAPIKey:kAPIKey];
    [_weatherAPI setTemperatureFormat:kOWMTempKelvin];
}

//-----------------------------------------------------------------------------

#pragma mark Animations

- (void) moveView:(UIView*) view toPoint:(CGPoint) to withDuration:(CGFloat) duration andDelay:(CGFloat) delay
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationDelay:delay];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    view.center = to;
    [UIView commitAnimations];
}


- (void) fadeView:(UIView*) view toValue:(CGFloat) value withDuration:(CGFloat) duration andDelay:(CGFloat) delay
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationDelay:delay];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    view.alpha = value;
    [UIView commitAnimations];
}

- (IBAction)actionSeatch:(UIButton *)sender
{
    NSLog(@"Begin download");
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(_latitude.text.floatValue, _longitude.text.floatValue);
    [_weatherAPI dailyForecastWeatherByCoordinate:coord withCount:1 andCallback:^(NSError *error, NSDictionary *result) {
        if(error)
        {
            NSLog(@"Something wrong!");
            return;
        }
        NSLog(@"Donwloading done");
        [_vc reciveData:result];
    }];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"GoDetail"])
        _vc = [segue destinationViewController];
}

@end
