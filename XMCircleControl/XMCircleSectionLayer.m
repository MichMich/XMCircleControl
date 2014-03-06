//
//  XMCircleSectionLayer.m
//  XMCircleControl
//
//  Created by Michael Teeuw on 27-02-14.
//  Copyright (c) 2014 Michael Teeuw. All rights reserved.
//

#import "XMCircleSectionLayer.h"

@implementation XMCircleSectionLayer


-(id)init
{
    self = [super init];
    if (self) {
        self.contentsScale = [UIScreen mainScreen].scale;
        self.needsDisplayOnBoundsChange = YES;
        self.delegate = self;
        self.controlType = XMCircleSectionControlTypeRelative;
    }
    return self;
}

- (id) initWithLayer:(id)layer
{
    self = [super initWithLayer:layer];
    if (self) {
        XMCircleSectionLayer *other = layer;
        self.controlType = other.controlType;
        self.angle = other.angle;
        self.startAngle = other.startAngle;
        self.innerRadius = other.innerRadius;
        self.outerRadius = other.outerRadius;
        self.color = other.color;
        self.value = other.value;
        self.active = other.active;
        self.continuous = other.continuous;
        self.fixToStartAngle = other.fixToStartAngle;
        self.minimumAngleWhenActive = other.minimumAngleWhenActive;
        self.maximumAngleWhenActive = other.maximumAngleWhenActive;
    }
    return self;
}

- (id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event
{
    return (id)[NSNull null]; // disable all implicit animations
}

- (CGPoint)boundsCenter
{
    return CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
}

-(void)animateProperty:(NSString *)property toValue:(float)value inTime:(NSTimeInterval)time
{
    float originalValue = [[self.presentationLayer valueForKey:property] floatValue];
    [self animateProperty:property fromValue:originalValue toValue:value inTime:time];
}


         
-(void)animateProperty:(NSString *)property fromValue:(float)fromValue toValue:(float)toValue inTime:(NSTimeInterval)time
{
    [self setValue:[NSNumber numberWithFloat:toValue] forKey:property];
    
    if (time > 0) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:property];
        animation.duration = time;
        animation.fromValue = [NSNumber numberWithFloat:fromValue];
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        [self addAnimation:animation forKey:[NSString stringWithFormat:@"%@Animation",property]];
    }
}

-(void)animateProperties:(NSDictionary *)properties  inTime:(NSTimeInterval)time
{
    NSMutableDictionary *fromValues = [NSMutableDictionary new];
    [properties enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        float originalValue = [[self.presentationLayer valueForKey:key] floatValue];
        [fromValues setValue:@(originalValue) forKey:key];
    }];
    
    //float originalValue = [[self.presentationLayer valueForKey:property] floatValue];
    [self animatePropertiesFromValues:fromValues toValues:properties inTime:time];
}

-(void)animatePropertiesFromValues:(NSDictionary *)fromValues toValues:(NSDictionary *)toValues inTime:(NSTimeInterval)time
{
    __block NSString *animationName = @"";
    
    [toValues enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [self setValue:obj forKey:key];
        animationName = [animationName stringByAppendingString:key];
    }];
    

    
    if (time > 0) {
        
        __block NSArray *caAnimations = @[];
        
        
        [fromValues enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:key];
            animation.fromValue = obj;
            
            caAnimations = [caAnimations arrayByAddingObject:animation];
        }];
        
        
        CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
        
        animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animationGroup.duration = time;
        animationGroup.animations = caAnimations;
        
        [self addAnimation:animationGroup forKey:[NSString stringWithFormat:@"%@Animation",animationName]];
    }
}


- (void)drawInContext:(CGContextRef)ctx
{
    //Draw Section
    
   
    //Draw by stroking.
    CGFloat pathWidth = self.outerRadius - self.innerRadius;
    CGFloat pathRadius = self.innerRadius + pathWidth / 2;
    
    if (pathWidth > 0) {
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:[self boundsCenter] radius:pathRadius startAngle:self.startAngle endAngle:self.startAngle+self.angle clockwise:YES];
        CGContextAddPath(ctx, path.CGPath);
        CGContextSetLineWidth(ctx, pathWidth);
        CGContextSetStrokeColorWithColor(ctx, self.color.CGColor);
        CGContextStrokePath(ctx);
    }
    
    
    /*
    //Draw by filling
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:[self boundsCenter] radius:self.innerRadius startAngle:self.startAngle endAngle:self.startAngle+self.angle clockwise:YES];
    [path addArcWithCenter:[self boundsCenter] radius:self.outerRadius startAngle:self.startAngle+self.angle endAngle:self.startAngle clockwise:NO];
    [path closePath];
    
    CGContextAddPath(ctx, path.CGPath);
    CGContextSetFillColorWithColor(ctx, self.color.CGColor);
    CGContextFillPath(ctx);
     */

}

- (void)setAngle:(CGFloat)angle
{
    _angle = angle;
    [self setNeedsDisplay];
}

- (void)setColor:(UIColor *)color
{
    _color = color;
    [self setNeedsDisplay];
}


+(BOOL)needsDisplayForKey:(NSString *)key {
    if ([key isEqualToString:@"innerRadius"]||
        [key isEqualToString:@"outerRadius"]||
        [key isEqualToString:@"startAngle"]||
        [key isEqualToString:@"angle"]) {
        return YES;
    }
    
    return [super needsDisplayForKey:key];
}

@end
