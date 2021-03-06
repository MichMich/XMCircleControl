//
//  XMCircleControlView.h
//  XMCircleControl
//
//  Created by Michael Teeuw on 27-02-14.
//  Copyright (c) 2014 Michael Teeuw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMCircleSectionLayer.h"
#import "XMOneFingerRotationGestureRecognizer.h"

#define RAD2DEG(radians) ((radians) * (180.0 / M_PI))
#define DEG2RAD(angle) ((angle) / 180.0 * M_PI)

@interface XMCircleTrack : NSObject

@property (nonatomic) CGFloat startAngle;
@property (nonatomic) CGFloat availableAngle;

@property (nonatomic, strong) NSArray *trackSections;
@property (nonatomic) BOOL hidden;

- (int) numberOfVisibleSections;
- (CGFloat) anglePerSection;
- (int) indexForSection:(XMCircleSectionLayer *)sectionToFind;
- (XMCircleSectionLayer *) sectionForIndex:(int)index;

@end


@interface XMCircleControlView : UIControl

@property (nonatomic, strong) NSArray *circleTracks;

@property (nonatomic) CGFloat innerRadius;
@property (nonatomic) CGFloat outerRadius;

@property (nonatomic) CGFloat trackSpace;

@property (nonatomic) float animationSpeed;

@property (nonatomic) NSTimeInterval touchDownSpeed;
@property (nonatomic) NSTimeInterval touchUpSpeed;

@property (strong, nonatomic) XMCircleTrack *activeTrack;
@property (strong, nonatomic) XMCircleSectionLayer *activeSection;

- (void) rotationGesture:(XMOneFingerRotationGestureRecognizer *)gesture;

- (void)sectionChanged:(XMCircleSectionLayer *)section;
- (void)sectionActivated:(XMCircleSectionLayer *)section;
- (void)sectionDeactivated:(XMCircleSectionLayer *)section;

- (CGPoint)boundsCenter;
- (CGFloat)maximumRadius;
- (void) updateSectionLayers;

@end
