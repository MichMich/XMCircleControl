//
//  ViewController.m
//  XMCircleControl
//
//  Created by Michael Teeuw on 27-02-14.
//  Copyright (c) 2014 Michael Teeuw. All rights reserved.
//

#import "ViewController.h"
#import "XMRGBControlView.h"

@interface ViewController ()

@property (strong, nonatomic) XMRGBControlView *colorControlView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.colorControlView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.colorControlView];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[ccv]-|" options:0 metrics:nil views:@{@"ccv":self.colorControlView}]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.colorControlView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.colorControlView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.colorControlView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (XMRGBControlView *)colorControlView
{
    if (!_colorControlView) {
        
        _colorControlView = [XMRGBControlView new];
        _colorControlView.backgroundColor = [UIColor blackColor];
        _colorControlView.startAngle = DEG2RAD(90);
        _colorControlView.availableAngle = DEG2RAD(360);
        _colorControlView.innerRadius = 70;
        
        _colorControlView.touchDownSpeed = 0.25;
        _colorControlView.touchUpSpeed = 0.5;
        
    }
    return _colorControlView;
}

@end
