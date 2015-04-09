//
//  ViewController.h
//  Weather
//
//  Created by Admin on 06.04.15.
//  Copyright (c) 2015 Andrew Medvedev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OWMWeatherAPI;
@class DetailViewController;

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *information;
@property (weak, nonatomic) IBOutlet UITextField *latitude;
@property (weak, nonatomic) IBOutlet UITextField *longitude;
@property (weak, nonatomic) IBOutlet UIButton *search;

@property (strong, nonatomic) OWMWeatherAPI* weatherAPI;
@property (strong, nonatomic) DetailViewController* vc;
- (IBAction)actionSeatch:(UIButton *)sender;
@end

