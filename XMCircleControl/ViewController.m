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
@property (strong, nonatomic) UIButton *toggleColormodeButton;

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
    self.toggleColormodeButton.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addSubview:self.rgbColorControlView];
    [self.view addSubview:self.hsbColorControlView];
    [self.view addSubview:self.toggleColormodeButton];
    
    NSDictionary *views = @{@"rgb":self.rgbColorControlView,@"hsb":self.hsbColorControlView,@"toggleColormodeButton":self.toggleColormodeButton};
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[rgb]-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[hsb]-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[toggleColormodeButton]-|" options:0 metrics:nil views:views]];

    //[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[hsb]-[rgb(==hsb)]-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[hsb]-[toggleColormodeButton]-|" options:0 metrics:nil views:views]];
    
    [self.toggleColormodeButton addTarget:self action:@selector(toggleColormode:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)toggleColormode:(UIButton *)sender
{
    self.hsbColorControlView.colorModeIsHue = !self.hsbColorControlView.colorModeIsHue;
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
        
        _hsbColorControlView.touchDownSpeed = 0.15;
        _hsbColorControlView.touchUpSpeed = 0.35;
        
    }
    return _hsbColorControlView;
}

- (UIButton *)toggleColormodeButton
{
    if (!_toggleColormodeButton) {
        _toggleColormodeButton = [UIButton new];
        [_toggleColormodeButton setTitle:@"Toggle Colormode" forState:UIControlStateNormal];
        return _toggleColormodeButton;
    }
    
    return _toggleColormodeButton;
}

@end
