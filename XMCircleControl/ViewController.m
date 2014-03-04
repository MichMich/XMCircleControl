//
//  ViewController.m
//  XMCircleControl
//
//  Created by Michael Teeuw on 27-02-14.
//  Copyright (c) 2014 Michael Teeuw. All rights reserved.
//

#import "ViewController.h"
#import "XMRGBControlView.h"
#import "XMHSBControlView.h"

@interface ViewController ()

@property (strong, nonatomic) XMRGBControlView *rgbColorControlView;
@property (strong, nonatomic) XMHSBControlView *hsbColorControlView;

@end

@implementation ViewController

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.rgbColorControlView.translatesAutoresizingMaskIntoConstraints = NO;
    self.hsbColorControlView.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addSubview:self.rgbColorControlView];
    [self.view addSubview:self.hsbColorControlView];
    
    NSDictionary *views = @{@"rgb":self.rgbColorControlView,@"hsb":self.hsbColorControlView};
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[rgb]-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[hsb]-|" options:0 metrics:nil views:views]];

    //[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[hsb]-[rgb(==hsb)]-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[hsb]-|" options:0 metrics:nil views:views]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (XMRGBControlView *)rgbColorControlView
{
    if (!_rgbColorControlView) {
        
        _rgbColorControlView = [XMRGBControlView new];
        _rgbColorControlView.innerRadius = 30;
        
        _rgbColorControlView.touchDownSpeed = 0.15;
        _rgbColorControlView.touchUpSpeed = 0.35;
        
    }
    return _rgbColorControlView;
}

- (XMHSBControlView *)hsbColorControlView
{
    if (!_hsbColorControlView) {
        
        _hsbColorControlView = [XMHSBControlView new];
        _hsbColorControlView.innerRadius = 50;
        
        _hsbColorControlView.touchDownSpeed = 0.15;
        _hsbColorControlView.touchUpSpeed = 0.35;
        
    }
    return _hsbColorControlView;
}

@end
