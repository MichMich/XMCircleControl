//
//  XMHSBControlView.m
//  XMCircleControl
//
//  Created by Michael Teeuw on 03-03-14.
//  Copyright (c) 2014 Michael Teeuw. All rights reserved.
//

#import "XMHSBControlView.h"
#import "UIColor+ColorTemperature.h"
#import <XMCircleTypeView.h>
#import "XMOneFingerRotationGestureRecognizer.h"
#import "XMCircleTypeView+Color.h"

@interface XMHSBControlView ()

@property (nonatomic,strong) XMCircleTrack *hueTrack;
@property (nonatomic,strong) XMCircleTrack *ctTrack;
@property (nonatomic,strong) XMCircleTrack *saturationTrack;
@property (nonatomic,strong) XMCircleTrack *brightnessTrack;

@property (nonatomic,strong) XMCircleSectionLayer *hueSection;
@property (nonatomic,strong) XMCircleSectionLayer *ctSection;
@property (nonatomic,strong) XMCircleSectionLayer *saturationSection;
@property (nonatomic,strong) XMCircleSectionLayer *brightnessSection;

@property (nonatomic, strong) XMCircleTypeView *hueLabel;
@property (nonatomic, strong) XMCircleTypeView *ctLabel;
@property (nonatomic, strong) XMCircleTypeView *saturationLabel;
@property (nonatomic, strong) XMCircleTypeView *brightnessLabel;

@property (nonatomic, strong) UIButton *powerButton;



@end

@implementation XMHSBControlView {
    CGFloat _innerRadiusFactor;
}

#pragma mark - Subclassing

- (id)init
{
    self = [super init];
    if (self) {
        
        _innerRadiusFactor = 0.35;
        _colorModeIsHue = YES;
        
        self.circleTracks = @[self.hueTrack,self.saturationTrack,self.ctTrack,self.brightnessTrack];
        self.trackSpace = 1;
        
        [self addLabels];
        
        [self updateColors];
        [self updateTracks];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.innerRadius = [self maxRadius] * _innerRadiusFactor;
    
    CGFloat powerButtonSize = self.innerRadius * 2 - 2;
    CGRect powerButtonFrame = CGRectMake([self boundsCenter].x - powerButtonSize/2, [self boundsCenter].y- powerButtonSize/2, powerButtonSize, powerButtonSize);
    self.powerButton.frame = powerButtonFrame;
    self.powerButton.layer.cornerRadius = powerButtonSize / 2;
    
    [self updateLabels];
}

#pragma mark - Private Methods

- (CGFloat)maxRadius
{
    return (self.bounds.size.width > self.bounds.size.height) ? self.bounds.size.height/2 : self.bounds.size.width/2;
}

- (XMCircleTypeView *)createNewLabel
{
    XMCircleTypeView *label = [XMCircleTypeView new];
    label.backgroundColor = [UIColor clearColor];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.baseAngle = DEG2RAD(-90);
    label.textAlignment = NSTextAlignmentCenter;
    label.textAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14], NSForegroundColorAttributeName: [UIColor whiteColor]};
    label.characterSpacing = 0.8;

    return label;
}

-(void)addLabels
{
    [self addSubview:self.hueLabel];
    [self addSubview:self.ctLabel];
    [self addSubview:self.saturationLabel];
    [self addSubview:self.brightnessLabel];
    
    NSDictionary *views = @{@"hueLabel":self.hueLabel, @"ctLabel":self.ctLabel,@"saturationLabel":self.saturationLabel,@"brightnessLabel":self.brightnessLabel};
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[hueLabel]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[hueLabel]|" options:0 metrics:nil views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[ctLabel]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[ctLabel]|" options:0 metrics:nil views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[saturationLabel]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[saturationLabel]|" options:0 metrics:nil views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[brightnessLabel]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[brightnessLabel]|" options:0 metrics:nil views:views]];
    
    [self updateLabels];
}

- (void)updateColors
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

- (void)updatePowerButtonColor
{
    float brightness = 0.2+self.brightnessSection.value * 0.8;
    float powerOffBrightness = 0.15;
    if (self.colorModeIsHue) {
        self.powerButton.backgroundColor = (self.power) ? [UIColor colorWithHue:self.hueSection.value saturation:self.saturationSection.value brightness:brightness alpha:1] : [UIColor colorWithRed:powerOffBrightness green:powerOffBrightness blue:powerOffBrightness alpha:1];
    } else {
        self.powerButton.backgroundColor = (self.power) ? [UIColor colorWithColorTemperature:self.ctSection.value andBrightness:brightness]: [UIColor colorWithRed:powerOffBrightness green:powerOffBrightness blue:powerOffBrightness alpha:1];
    }
}

- (void)updateTracks
{
    self.hueTrack.availableAngle = (!self.power) ? 0 : M_PI * 2;
    
    self.ctTrack.availableAngle = (!self.power) ? 0 : M_PI * 2;
    
    self.saturationTrack.availableAngle = (!self.power) ? 0 : M_PI * 2 * self.saturationSection.value;
    //self.saturationTrack.availableAngle = (!self.power) ? 0 : M_PI * 2;
    
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

- (void)updateLabels
{
    [UIView animateWithDuration:self.animationSpeed/2 animations:^{
        self.hueLabel.alpha = 0;
        self.ctLabel.alpha = 0;
        self.saturationLabel.alpha = 0;
        self.brightnessLabel.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        

        if (self.colorModeIsHue) {
            float saturation = 0; //(self.saturationSection.value > 0.5) ? 0 : 1;

            [self.hueLabel setColor:[UIColor colorWithHue:self.hueSection.value saturation:0 brightness:1 alpha:1]];
            [self.saturationLabel setColor:[UIColor colorWithHue:self.hueSection.value saturation:saturation brightness:1 alpha:1]];
            [self.brightnessLabel setColor:[UIColor colorWithHue:self.hueSection.value saturation:0 brightness:1 alpha:1]];
        } else {
            [self.ctLabel setColor:[UIColor colorWithColorTemperature:self.ctSection.value andBrightness:0.5]];
            [self.brightnessLabel setColor:[UIColor colorWithHue:self.ctSection.value saturation:0 brightness:1 alpha:1]];
        }
        
        

        
        
        
       [UIView animateWithDuration:self.animationSpeed delay:self.animationSpeed options:UIViewAnimationOptionBeginFromCurrentState animations:^{
           if (!self.power || self.activeSection != nil) {
               self.hueLabel.alpha = 0;
               self.saturationLabel.alpha = 0;
               self.brightnessLabel.alpha = 0;
               self.ctLabel.alpha = 0;
               
           } else {
               if (self.colorModeIsHue) {
                   self.hueLabel.alpha = 1;
                   self.saturationLabel.alpha = 1;
                   self.brightnessLabel.alpha = 1;
                   self.ctLabel.alpha = 0;
                   
                   self.hueLabel.radius = [self maxRadius] * 0.4;
                   self.saturationLabel.radius = [self maxRadius] * 0.625;
                   self.brightnessLabel.radius = [self maxRadius] * 0.85;
               } else {
                   self.hueLabel.alpha = 0;
                   self.saturationLabel.alpha = 0;
                   self.brightnessLabel.alpha = 1;
                   self.ctLabel.alpha = 1;
                   
                   self.ctLabel.radius = [self maxRadius] * 0.46;
                   self.brightnessLabel.radius = [self maxRadius] * 0.78;
               }
           }
           
       } completion:^(BOOL finished) {
           //done
       }];
        
    }];
}

#pragma mark - User Interaction

- (void)sectionChanged:(XMCircleSectionLayer *)section
{
    self.saturationSection.value = (self.saturationSection.value < 0.0005) ? 0.0005 : self.saturationSection.value;
    self.brightnessSection.value = (self.brightnessSection.value < 0.0005) ? 0.0005 : self.brightnessSection.value;

    [self updateColors];
    [self updateTracks];
    
    if (section == self.hueSection) [self.delegate hueChanged:self];
    if (section == self.ctSection) [self.delegate colorTemperatureChanged:self];
    if (section == self.saturationSection) [self.delegate saturationChanged:self];
    if (section == self.brightnessSection) [self.delegate brightnessChanged:self];
    
}

- (void)sectionActivated:(XMCircleSectionLayer *)section
{
    [self updateLabels];
}

- (void)sectionDeactivated:(XMCircleSectionLayer *)section
{
    [self updateLabels];
}

- (void)powerButtonPressed:(UIButton *)sender
{
    self.power = !self.power;
    self.animationSpeed = self.touchUpSpeed;
    [self updateTracks];
    [self updateSectionLayers];
    [self updateLabels];
    
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
        _hueSection.controlType = XMCircleSectionControlTypeAbsolute;
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

- (XMCircleTypeView *)hueLabel
{
    if (!_hueLabel) {
        _hueLabel = [self createNewLabel];
        _hueLabel.text = @"Hue";
    }
    return _hueLabel;
}

- (XMCircleTypeView *)ctLabel
{
    if (!_ctLabel) {
        _ctLabel = [self createNewLabel];
        _ctLabel.text = @"Color Temperature";
    }
    return _ctLabel;
}

- (XMCircleTypeView *)saturationLabel
{
    if (!_saturationLabel) {
        _saturationLabel = [self createNewLabel];
        _saturationLabel.text = @"Saturation";
    }
    return _saturationLabel;
}

- (XMCircleTypeView *)brightnessLabel
{
    if (!_brightnessLabel) {
        _brightnessLabel = [self createNewLabel];
        _brightnessLabel.text = @"Brightness";
    }
    return _brightnessLabel;
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

- (void)setColorModeIsHue:(BOOL)colorModeIsHue
{
    _colorModeIsHue = colorModeIsHue;
    self.animationSpeed = self.touchDownSpeed;
    [self updateTracks];
    [self updateColors];
    [self updateLabels];
    [self updateSectionLayers];
}

@end
