//
//  XMOneFingerRotationGestureRecognizer.m
//  XMCircleControl
//
//  Created by Michael Teeuw on 27-02-14.
//  Copyright (c) 2014 Michael Teeuw. All rights reserved.
//

#import "XMOneFingerRotationGestureRecognizer.h"

@interface XMOneFingerRotationGestureRecognizer ()



@end

@implementation XMOneFingerRotationGestureRecognizer


- (id) initWithMidPoint:(CGPoint)midPoint innerRadius:(float)innerRadius outerRadius:(float)outerRadius target:(id)target action:(SEL)action
{
    self = [self initWithTarget:target action:action];
    if (self)
    {
        self.midPoint = midPoint;
        self.innerRadius = innerRadius;
        self.outerRadius = outerRadius;
    }
    return self;
}

- (CGFloat) distanceBetween:(CGPoint) pointA and:(CGPoint)pointB
{
    CGFloat dx = pointA.x - pointB.x;
    CGFloat dy = pointA.y - pointB.y;
    return sqrt(dx*dx + dy*dy);
}

- (CGFloat) angleForPoint:(CGPoint) point
{
    CGFloat angle = atan2(point.x - self.midPoint.x, point.y - self.midPoint.y) * -1 + M_PI/2;
    if (angle < 0) angle += M_PI * 2;
    return angle;
}

- (CGFloat) angleBetween:(CGPoint) pointA and:(CGPoint)pointB
{
    return [self angleForPoint:pointA] - [self angleForPoint:pointB];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    CGPoint nowPoint  = [[touches anyObject] locationInView: self.view];
    CGFloat distance = [self distanceBetween:self.midPoint and:nowPoint];
    if (self.innerRadius <= distance && distance <= self.outerRadius) {
        self.state = UIGestureRecognizerStateBegan;
    } else {
        self.state = UIGestureRecognizerStateFailed;
    }
    
    self.rotation = 0;
    self.angle = [self angleForPoint:nowPoint];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{

    [super touchesMoved: touches withEvent:event];
    self.state = UIGestureRecognizerStateChanged;
  
    if (self.state == UIGestureRecognizerStateFailed) return;
    
    CGPoint nowPoint  = [[touches anyObject] locationInView: self.view];
    CGPoint prevPoint = [[touches anyObject] previousLocationInView: self.view];
    
    // calculate rotation angle between two points
    CGFloat rotation = [self angleBetween:nowPoint and:prevPoint];
    
    // fix value, if the 12 o'clock position is between prevPoint and nowPoint
    if (rotation > M_PI) {
        rotation -= M_PI*2;
    } else if (rotation < - M_PI) {
        rotation += M_PI * 2;
    }
    
    self.rotation = rotation;
    self.angle = [self angleForPoint:nowPoint];

    self.state = UIGestureRecognizerStateChanged;

}



- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    self.state = UIGestureRecognizerStateEnded;
}


@end
