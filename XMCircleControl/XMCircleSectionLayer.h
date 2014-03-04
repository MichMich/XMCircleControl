//
//  XMCircleSectionLayer.h
//  XMCircleControl
//
//  Created by Michael Teeuw on 27-02-14.
//  Copyright (c) 2014 Michael Teeuw. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface XMCircleSectionLayer : CALayer

@property (nonatomic) CGFloat innerRadius;
@property (nonatomic) CGFloat outerRadius;

@property (nonatomic) CGFloat startAngle;
@property (nonatomic) CGFloat angle;

@property (nonatomic, strong) UIColor *color;

@property (nonatomic) float value;

-(void)animateProperty:(NSString *)property toValue:(float)value inTime:(NSTimeInterval)time;
-(void)animateProperty:(NSString *)property fromValue:(float)fromValue toValue:(float)toValue inTime:(NSTimeInterval)time;

-(void)animateProperties:(NSDictionary *)properties inTime:(NSTimeInterval)time;
-(void)animatePropertiesFromValues:(NSDictionary *)fromValues toValues:(NSDictionary *)toValues inTime:(NSTimeInterval)time;

@end
