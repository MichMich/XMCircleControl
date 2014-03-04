//
//  XMHSBControlView.m
//  XMCircleControl
//
//  Created by Michael Teeuw on 03-03-14.
//  Copyright (c) 2014 Michael Teeuw. All rights reserved.
//

#import "XMHSBControlView.h"

@interface XMHSBControlView ()

@property (nonatomic,strong) XMCircleTrack *hueTrack;
@property (nonatomic,strong) XMCircleTrack *saturationTrack;
@property (nonatomic,strong) XMCircleTrack *brightnessTrack;

@property (nonatomic,strong) XMCircleSectionLayer *hueSection;
@property (nonatomic,strong) XMCircleSectionLayer *saturationSection;
@property (nonatomic,strong) XMCircleSectionLayer *brightnessSection;

@end

@implementation XMHSBControlView

- (id)init
{
    self = [super init];
    if (self) {
        
        self.hueTrack = [XMCircleTrack new];
        self.hueTrack.trackSections = @[self.hueSection];
        self.hueTrack.startAngle = DEG2RAD(-90);
        
        self.saturationTrack = [XMCircleTrack new];
        self.saturationTrack.trackSections = @[self.saturationSection];
        self.saturationTrack.startAngle = DEG2RAD(-90);

        self.brightnessTrack = [XMCircleTrack new];
        self.brightnessTrack.trackSections = @[self.brightnessSection];
        self.brightnessTrack.startAngle = DEG2RAD(-90);
        
        self.circleTracks = @[self.hueTrack,self.saturationTrack,self.brightnessTrack];
        self.trackSpace = 1;
        
        [self updateColors];
        [self updateTracks];
    }
    return self;
}

- (void) updateColors
{
    
    float saturation = 0.1 + self.saturationSection.value * 0.7;
    float brightness = 0.1 + self.brightnessSection.value * 0.7;
    
    self.hueSection.color = [UIColor colorWithHue:self.hueSection.value saturation:1 brightness:1 alpha:1];
    self.saturationSection.color = [UIColor colorWithHue:self.hueSection.value saturation:saturation brightness:1 alpha:1];
    self.brightnessSection.color = [UIColor colorWithHue:self.hueSection.value saturation:saturation brightness:brightness alpha:1];

}

- (void) updateTracks
{
    self.hueTrack.availableAngle = M_PI * 2;
    self.saturationTrack.availableAngle = M_PI * 2 * self.saturationSection.value;
    self.brightnessTrack.availableAngle = M_PI * 2 * self.brightnessSection.value;
}

- (void)sectionChanged:(XMCircleSectionLayer *)section
{
    [self updateColors];
    [self updateTracks];
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
