//
//  XMRGBControlView.m
//  XMCircleControl
//
//  Created by Michael Teeuw on 01-03-14.
//  Copyright (c) 2014 Michael Teeuw. All rights reserved.
//

#import "XMRGBControlView.h"

@interface XMRGBControlView()

@property (nonatomic,strong) XMCircleSection *redSection;
@property (nonatomic,strong) XMCircleSection *greenSection;
@property (nonatomic,strong) XMCircleSection *blueSection;

@end

@implementation XMRGBControlView

- (id)init
{
    self = [super init];
    if (self) {
        
        XMCircleTrack *track = [XMCircleTrack new];
        track.trackSections = @[self.redSection, self.greenSection, self.blueSection];
        track.startAngle = DEG2RAD(90);
        track.availableAngle = DEG2RAD(360);

        self.circleTracks = @[track];
        
        [self updateColors];
        
    }
    return self;
}

- (void) updateColors
{

    float red = 0.1 + self.redSection.value * 0.9;
    float green = 0.1 + self.greenSection.value * 0.9;
    float blue = 0.1 + self.blueSection.value * 0.9;
    
    self.redSection.color = [UIColor colorWithRed:red green:0 blue:0 alpha:1];
    self.greenSection.color = [UIColor colorWithRed:0 green:green blue:0 alpha:1];
    self.blueSection.color = [UIColor colorWithRed:0 green:0 blue:blue alpha:1];

    [self setNeedsDisplay];
}

- (void)sectionChanged:(XMCircleSection *)section
{
    [self updateColors];
}

- (void)drawRect:(CGRect)rect
{
    
    float red = 0.1 + self.redSection.value * 0.9;
    float green = 0.1 + self.greenSection.value * 0.9;
    float blue = 0.1 + self.blueSection.value * 0.9;
    
    [[UIColor colorWithRed:red green:green blue:blue alpha:1] setFill];
    
    UIBezierPath *circle = [UIBezierPath bezierPathWithArcCenter:[self boundsCenter] radius:self.innerRadius - 1 startAngle:0 endAngle:M_PI*2 clockwise:YES];
    [circle appendPath:[UIBezierPath bezierPathWithArcCenter:[self boundsCenter] radius:self.innerRadius - 20 startAngle:0 endAngle:M_PI*2 clockwise:YES]];
    
    circle.usesEvenOddFillRule = YES;
    [circle fill];
     
}


- (XMCircleSection *)redSection
{
    if (!_redSection) {
        _redSection = [XMCircleSection new];
        _redSection.name = @"Red";
        _redSection.value = 1;
    }
    return _redSection;
}

- (XMCircleSection *)greenSection
{
    if (!_greenSection) {
        _greenSection = [XMCircleSection new];
        _greenSection.name = @"Green";
        _greenSection.value = 1;
    }
    return _greenSection;
}


- (XMCircleSection *)blueSection
{
    if (!_blueSection) {
        _blueSection = [XMCircleSection new];
        _blueSection.name = @"Blue";
        _blueSection.value = 1;
    }
    return _blueSection;
}

@end
