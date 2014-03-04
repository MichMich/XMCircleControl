//
//  XMHSBControlView.m
//  XMCircleControl
//
//  Created by Michael Teeuw on 03-03-14.
//  Copyright (c) 2014 Michael Teeuw. All rights reserved.
//

#import "XMHSBControlView.h"

@interface XMHSBControlView ()

@property (nonatomic,strong) XMCircleSectionLayer *hueSection;
@property (nonatomic,strong) XMCircleSectionLayer *saturationSection;
@property (nonatomic,strong) XMCircleSectionLayer *brightnessSection;

@end

@implementation XMHSBControlView

- (id)init
{
    self = [super init];
    if (self) {
        
        XMCircleTrack *hueTrack = [XMCircleTrack new];
        hueTrack.trackSections = @[self.hueSection];
        hueTrack.startAngle = DEG2RAD(90);
        hueTrack.availableAngle = DEG2RAD(360);
        
        XMCircleTrack *saturationTrack = [XMCircleTrack new];
        saturationTrack.trackSections = @[self.saturationSection];
        saturationTrack.startAngle = DEG2RAD(90);
        saturationTrack.availableAngle = DEG2RAD(360);
        
        XMCircleTrack *brightnessTrack = [XMCircleTrack new];
        brightnessTrack.trackSections = @[self.brightnessSection];
        brightnessTrack.startAngle = DEG2RAD(90);
        brightnessTrack.availableAngle = DEG2RAD(360);
        
        self.circleTracks = @[hueTrack,saturationTrack,brightnessTrack];
        
        [self updateColors];
        
    }
    return self;
}

- (void) updateColors
{
    
    float saturation = 0.1 + self.saturationSection.value * 0.9;
    float brightness = 0.1 + self.brightnessSection.value * 0.9;
    
    self.hueSection.color = [UIColor colorWithHue:self.hueSection.value saturation:1 brightness:1 alpha:1];
    self.saturationSection.color = [UIColor colorWithHue:self.hueSection.value saturation:saturation brightness:1 alpha:1];
    self.brightnessSection.color = [UIColor colorWithHue:self.hueSection.value saturation:saturation brightness:brightness alpha:1];
    
}

- (void)sectionChanged:(XMCircleSectionLayer *)section
{
    [self updateColors];
}




- (XMCircleSectionLayer *)hueSection
{
    if (!_hueSection) {
        _hueSection = [XMCircleSectionLayer new];
        _hueSection.name = @"Hue";
        _hueSection.value = 1;
    }
    return _hueSection;
}

- (XMCircleSectionLayer *)saturationSection
{
    if (!_saturationSection) {
        _saturationSection = [XMCircleSectionLayer new];
        _saturationSection.name = @"Saturation";
        _saturationSection.value = 1;
    }
    return _saturationSection;
}

- (XMCircleSectionLayer *)brightnessSection
{
    if (!_brightnessSection) {
        _brightnessSection = [XMCircleSectionLayer new];
        _brightnessSection.name = @"Brightness";
        _brightnessSection.value = 1;
    }
    return _brightnessSection;
}

@end
