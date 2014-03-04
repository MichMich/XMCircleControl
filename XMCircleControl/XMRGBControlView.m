//
//  XMRGBControlView.m
//  XMCircleControl
//
//  Created by Michael Teeuw on 01-03-14.
//  Copyright (c) 2014 Michael Teeuw. All rights reserved.
//

#import "XMRGBControlView.h"

@interface XMRGBControlView()

@property (nonatomic,strong) XMCircleSectionLayer *redSection;
@property (nonatomic,strong) XMCircleSectionLayer *greenSection;
@property (nonatomic,strong) XMCircleSectionLayer *blueSection;

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

- (void)sectionChanged:(XMCircleSectionLayer *)section
{
    [self updateColors];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextClearRect(ctx, rect);
    
    [super drawRect:rect];
    
    float red = 0.1 + self.redSection.value * 0.9;
    float green = 0.1 + self.greenSection.value * 0.9;
    float blue = 0.1 + self.blueSection.value * 0.9;
    
    [[UIColor colorWithRed:red green:green blue:blue alpha:1] setFill];
    
    UIBezierPath *circle = [UIBezierPath bezierPathWithArcCenter:[self boundsCenter] radius:self.innerRadius - 1 startAngle:0 endAngle:M_PI*2 clockwise:YES];
    [circle appendPath:[UIBezierPath bezierPathWithArcCenter:[self boundsCenter] radius:self.innerRadius - 20 startAngle:0 endAngle:M_PI*2 clockwise:YES]];
    
    circle.usesEvenOddFillRule = YES;
    [circle fill];
     
}


- (XMCircleSectionLayer *)redSection
{
    if (!_redSection) {
        _redSection = [XMCircleSectionLayer new];
        _redSection.name = @"Red";
        _redSection.value = 1;
    }
    return _redSection;
}

- (XMCircleSectionLayer *)greenSection
{
    if (!_greenSection) {
        _greenSection = [XMCircleSectionLayer new];
        _greenSection.name = @"Green";
        _greenSection.value = 1;
    }
    return _greenSection;
}


- (XMCircleSectionLayer *)blueSection
{
    if (!_blueSection) {
        _blueSection = [XMCircleSectionLayer new];
        _blueSection.name = @"Blue";
        _blueSection.value = 1;
    }
    return _blueSection;
}

@end
