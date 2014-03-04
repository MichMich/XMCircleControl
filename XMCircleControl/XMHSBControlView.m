//
//  XMHSBControlView.m
//  XMCircleControl
//
//  Created by Michael Teeuw on 03-03-14.
//  Copyright (c) 2014 Michael Teeuw. All rights reserved.
//

#import "XMHSBControlView.h"
#import "UIColor+ColorTemperature.h"

@interface XMHSBControlView ()

@property (nonatomic,strong) XMCircleTrack *hueTrack;
@property (nonatomic,strong) XMCircleTrack *ctTrack;
@property (nonatomic,strong) XMCircleTrack *saturationTrack;
@property (nonatomic,strong) XMCircleTrack *brightnessTrack;

@property (nonatomic,strong) XMCircleSectionLayer *hueSection;
@property (nonatomic,strong) XMCircleSectionLayer *ctSection;
@property (nonatomic,strong) XMCircleSectionLayer *saturationSection;
@property (nonatomic,strong) XMCircleSectionLayer *brightnessSection;

@property (nonatomic, strong) UIButton *powerButton;



@end

@implementation XMHSBControlView

#pragma mark - Subclassing

- (id)init
{
    self = [super init];
    if (self) {
        

        self.colorModeIsHue = YES;
        self.circleTracks = @[self.hueTrack,self.saturationTrack,self.ctTrack,self.brightnessTrack];
        self.trackSpace = 1;
        
        [self updateColors];
        [self updateTracks];
        
    }
    return self;
}

#pragma mark - Private Methods

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat powerButtonSize = [self boundsCenter].x / 1.5;
    CGRect powerButtonFrame = CGRectMake([self boundsCenter].x - powerButtonSize/2, [self boundsCenter].y- powerButtonSize/2, powerButtonSize, powerButtonSize);
    self.powerButton.frame = powerButtonFrame;
    self.powerButton.layer.cornerRadius = powerButtonSize / 2;
}

- (void) updateColors
{
    
    float saturation = self.saturationSection.value * 0.8;
    float brightness = 0.2+self.brightnessSection.value * 0.6;
    
    self.hueSection.color = [UIColor colorWithHue:self.hueSection.value saturation:1 brightness:1 alpha:1];
    self.ctSection.color = [UIColor colorWithColorTemperature:self.ctSection.value andBrightness:1];
    self.saturationSection.color = [UIColor colorWithHue:self.hueSection.value saturation:saturation brightness:1 alpha:1];
    if (self.colorModeIsHue) {
        self.brightnessSection.color = [UIColor colorWithHue:self.hueSection.value saturation:saturation brightness:brightness alpha:1];
    } else {
        self.brightnessSection.color = [UIColor colorWithColorTemperature:self.ctSection.value andBrightness:brightness];
    }
    
    [self updatePowerButtonColor];
}

- (void) updatePowerButtonColor
{
    if (self.colorModeIsHue) {
        self.powerButton.backgroundColor = (self.power) ? [UIColor colorWithHue:self.hueSection.value saturation:self.saturationSection.value brightness:self.brightnessSection.value alpha:1] : [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1];
    } else {
        self.powerButton.backgroundColor = (self.power) ? [UIColor colorWithColorTemperature:self.ctSection.value andBrightness:self.brightnessSection.value]: [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1];
    }
}

- (void) updateTracks
{
    self.hueTrack.availableAngle = (!self.power) ? 0 : M_PI * 2;
    self.ctTrack.availableAngle = (!self.power) ? 0 : M_PI * 2;
    self.saturationTrack.availableAngle = (!self.power) ? 0 : M_PI * 2 * self.saturationSection.value;
    self.brightnessTrack.availableAngle = (!self.power) ? 0 : M_PI * 2 * self.brightnessSection.value;
    
    if (self.power) {
        self.hueTrack.hidden = (!self.colorModeIsHue);
        self.ctTrack.hidden = (self.colorModeIsHue);
        self.saturationTrack.hidden = (!self.colorModeIsHue);
        self.brightnessTrack.hidden = NO;
    } else {
        self.hueTrack.hidden = YES;
        self.ctTrack.hidden = YES;
        self.saturationTrack.hidden = YES;
        self.brightnessTrack.hidden = YES;
    }
}


#pragma mark - User Interaction

- (void)sectionChanged:(XMCircleSectionLayer *)section
{
    self.saturationSection.value = (self.saturationSection.value < 0.025) ? 0.025 : self.saturationSection.value;
    self.brightnessSection.value = (self.brightnessSection.value < 0.025) ? 0.025 : self.brightnessSection.value;

    [self updateColors];
    [self updateTracks];
    
    if (section == self.hueSection) [self.delegate hueChanged:self];
    if (section == self.ctSection) [self.delegate colorTemperatureChanged:self];
    if (section == self.saturationSection) [self.delegate saturationChanged:self];
    if (section == self.brightnessSection) [self.delegate brightnessChanged:self];
    
}

- (void)powerButtonPressed:(UIButton *)sender
{
    self.power = !self.power;
    self.animationSpeed = self.touchUpSpeed;
    [self updateTracks];
    [self updateSectionLayers];
    
    [_powerButton setTitle:(self.power) ? @"" : @"OFF" forState:UIControlStateNormal];
    
    [UIView animateWithDuration:self.animationSpeed animations:^{
        [self updatePowerButtonColor];
    }];
    
    [self.delegate powerChanged:self];
}

#pragma mark - Getters & Setters

- (XMCircleTrack *)hueTrack
{
    if (!_hueTrack) {
        _hueTrack = [XMCircleTrack new];
        _hueTrack.trackSections = @[self.hueSection];
        _hueTrack.startAngle = DEG2RAD(-90);
    }
    
    return _hueTrack;
}

- (XMCircleTrack *)ctTrack
{
    if (!_ctTrack) {
        _ctTrack = [XMCircleTrack new];
        _ctTrack.trackSections = @[self.ctSection];
        _ctTrack.startAngle = DEG2RAD(-90);
    }
    
    return _ctTrack;
}

- (XMCircleTrack *)saturationTrack
{
    if (!_saturationTrack) {
        _saturationTrack = [XMCircleTrack new];
        _saturationTrack.trackSections = @[self.saturationSection];
        _saturationTrack.startAngle = DEG2RAD(-90);
    }
    
    return _saturationTrack;
}

- (XMCircleTrack *)brightnessTrack
{
    if (!_brightnessTrack) {
        _brightnessTrack = [XMCircleTrack new];
        _brightnessTrack.trackSections = @[self.brightnessSection];
        _brightnessTrack.startAngle = DEG2RAD(-90);
    }
    
    return _brightnessTrack;
}

- (XMCircleSectionLayer *)hueSection
{
    if (!_hueSection) {
        _hueSection = [XMCircleSectionLayer new];
        _hueSection.name = @"Hue";
        _hueSection.value = 1;
        _hueSection.maximumAngleWhenActive = M_PI /4;
        _hueSection.minimumAngleWhenActive = M_PI /4;
        _hueSection.continuous = YES;
    }
    return _hueSection;
}

- (XMCircleSectionLayer *)ctSection
{
    if (!_ctSection) {
        _ctSection = [XMCircleSectionLayer new];
        _ctSection.name = @"CT";
        _ctSection.value = 1;
        _ctSection.fixToStartAngle = YES;
    }
    return _ctSection;
}

- (XMCircleSectionLayer *)saturationSection
{
    if (!_saturationSection) {
        _saturationSection = [XMCircleSectionLayer new];
        _saturationSection.name = @"Saturation";
        _saturationSection.value = 1;
        _saturationSection.fixToStartAngle = YES;
    }
    return _saturationSection;
}

- (XMCircleSectionLayer *)brightnessSection
{
    if (!_brightnessSection) {
        _brightnessSection = [XMCircleSectionLayer new];
        _brightnessSection.name = @"Brightness";
        _brightnessSection.value = 1;
        _brightnessSection.fixToStartAngle = YES;
    }
    return _brightnessSection;
}

- (UIButton *)powerButton
{
    if (!_powerButton) {
        _powerButton = [UIButton new];
        _powerButton.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1];
        [_powerButton setTitle:@"POWER" forState:UIControlStateNormal];
        [_powerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [self addSubview:_powerButton];
        [_powerButton addTarget:self action:@selector(powerButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _powerButton;
}

@end
