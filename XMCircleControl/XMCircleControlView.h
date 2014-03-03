//
//  XMCircleControlView.h
//  XMCircleControl
//
//  Created by Michael Teeuw on 27-02-14.
//  Copyright (c) 2014 Michael Teeuw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMCircleSectionLayer.h"

#define RAD2DEG(radians) ((radians) * (180.0 / M_PI))
#define DEG2RAD(angle) ((angle) / 180.0 * M_PI)

@interface XMCircleSection : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) UIColor *color;
@property (nonatomic) float value;
@property (nonatomic) BOOL hidden;
@property (nonatomic) BOOL continuous;
@property (nonatomic) float continuousSize;

@property (strong, nonatomic) XMCircleSectionLayer *layer;

@end





@interface XMCircleControlView : UIView

@property (strong, nonatomic) NSArray *circleSections;


@property (nonatomic) CGFloat startAngle;
@property (nonatomic) CGFloat availableAngle;

@property (nonatomic) CGFloat innerRadius;
@property (nonatomic) CGFloat outerRadius;

@property (nonatomic) NSTimeInterval touchDownSpeed;
@property (nonatomic) NSTimeInterval touchUpSpeed;

@property (strong, nonatomic) XMCircleSection *activeSection;

- (void)sectionChanged:(XMCircleSection *)section;
- (CGPoint)boundsCenter;
- (CGFloat)maximumRadius;


@end
