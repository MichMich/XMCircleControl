//
//  XMOneFingerRotationGestureRecognizer.h
//  XMCircleControl
//
//  Created by Michael Teeuw on 27-02-14.
//  Copyright (c) 2014 Michael Teeuw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIGestureRecognizerSubclass.h>

@interface XMOneFingerRotationGestureRecognizer : UIGestureRecognizer

@property (nonatomic) CGPoint midPoint;
@property (nonatomic) CGFloat innerRadius;
@property (nonatomic) CGFloat outerRadius;

@property (nonatomic) CGFloat rotation; //realtive
@property (nonatomic) CGFloat angle; //absolute
@property (nonatomic) CGFloat distance;

- (id) initWithMidPoint:(CGPoint)midPoint innerRadius:(float)innerRadius outerRadius:(float)outerRadius target:(id)target action:(SEL)action;

@end
