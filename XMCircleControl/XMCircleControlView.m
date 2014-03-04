//
//  XMCircleControlView.m
//  XMCircleControl
//
//  Created by Michael Teeuw on 27-02-14.
//  Copyright (c) 2014 Michael Teeuw. All rights reserved.
//

#import "XMCircleControlView.h"
#import "XMOneFingerRotationGestureRecognizer.h"






@implementation XMCircleTrack

- (int) numberOfVisibleSections
{
    
    int numberOfVisibleSections = 0;
    
    for (XMCircleSectionLayer *section in self.trackSections) {
        if (!section.hidden) numberOfVisibleSections++;
    }
    
    return numberOfVisibleSections;
    
}

- (CGFloat) anglePerSection
{
    return self.availableAngle / [self numberOfVisibleSections];
}

- (XMCircleSectionLayer *) sectionForAngle:(float)angle
{
    
    int sectionIndex = angle / [self anglePerSection];
    
    if (sectionIndex < [self numberOfVisibleSections]) return [self sectionForIndex:sectionIndex];
    
    return nil;
    
}

- (int) indexForSection:(XMCircleSectionLayer *)sectionToFind
{
    
    int index = 0;
    
    for (XMCircleSectionLayer *section in self.trackSections) {
        if (section == sectionToFind) return index;
        if (!section.hidden) index++;
    }
    
    return -1;
}

- (XMCircleSectionLayer *) sectionForIndex:(int)index
{
    
    int sectionIndex = 0;
    for (XMCircleSectionLayer *section in self.trackSections) {
        if (sectionIndex == index && !section.hidden) {
            return section;
        }
        if (!section.hidden) {
            sectionIndex++;
        }
    }
    
    return nil;
}

@end


@interface XMCircleControlView ()

@property (nonatomic) CGFloat rotation;
@property (nonatomic) CGFloat angle;
@property (nonatomic) CGFloat distance;

@property (nonatomic) float activeSectionStartValue;

@property (strong, nonatomic) XMOneFingerRotationGestureRecognizer *rotationGestureRecognizer;

@property (nonatomic) float animationSpeed;

@end

@implementation XMCircleControlView


#pragma mark - Subclassed Functions

- (id)init
{
    self = [super init];
    if (self) {
    
        self.rotationGestureRecognizer = [[XMOneFingerRotationGestureRecognizer alloc] initWithMidPoint:[self boundsCenter] innerRadius:self.innerRadius outerRadius:self.outerRadius target:self action:@selector(rotationGesture:)];
        [self addGestureRecognizer:self.rotationGestureRecognizer];

    }
    return self;
}

- (void) drawRect:(CGRect)rect
{
    [[UIColor colorWithWhite:1 alpha:0.1] setFill];
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:[self boundsCenter] radius:self.outerRadius startAngle:0 endAngle:2*M_PI clockwise:YES];
    [path appendPath:[UIBezierPath bezierPathWithArcCenter:[self boundsCenter] radius:self.innerRadius startAngle:0 endAngle:2*M_PI clockwise:YES]];
    path.usesEvenOddFillRule = YES;
    [path fill];
}

- (void)layoutSubviews
{
    
    [super layoutSubviews];
    self.rotationGestureRecognizer.midPoint = [self boundsCenter];
    self.outerRadius = [self maximumRadius];
    
    for (XMCircleTrack *track in self.circleTracks) {
        for (XMCircleSectionLayer *section in track.trackSections) {
            section.frame = self.bounds;
        }
    }
    
    [self updateSectionLayers];
}


#pragma mark - Public Methods

- (void)sectionChanged:(XMCircleSectionLayer *)section
{
    //ABSTRACT FUNCTION
    NSLog(@"%@ changed: %f", section.name, section.value);
}

- (CGPoint)boundsCenter
{
    return CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
}

- (CGFloat)maximumRadius;
{
    return ((self.bounds.size.width < self.bounds.size.height) ? self.bounds.size.width : self.bounds.size.height) /2;
}


#pragma mark - Private Methods

- (void) removeSectionLayers
{
    //remove old layers
    for (XMCircleTrack *track in self.circleTracks) {
        for (XMCircleSectionLayer *section in track.trackSections) {
            [section removeFromSuperlayer];
        }
    }
}

- (void) createSectionLayers
{
    //add new layers
    for (XMCircleTrack *track in self.circleTracks) {
        for (XMCircleSectionLayer *section in track.trackSections) {
            section.outerRadius = self.outerRadius;
            section.innerRadius = self.innerRadius;

            section.color =  section.color;

            [self.layer addSublayer:section];
        }
    }
    [self updateSectionLayers];
}



- (void) updateSectionLayers
{

    int trackCount = 0;
    for (XMCircleTrack *track in self.circleTracks) {
        
        int sectionCount = 0;
        CGFloat currentAngle = track.startAngle;
        
        for (XMCircleSectionLayer *section in track.trackSections) {
           
        
            CGFloat activeSectionAngle;
            CGFloat activeSectionStartAngle;
            
            if (self.activeSection) {
                activeSectionAngle = (self.activeSection.value * M_PI * 2);
                activeSectionStartAngle = (self.angle + track.startAngle) - activeSectionAngle;
            }
            
            
            if (section == self.activeSection) {
                //Active Track, Active Section
                
                [section animateProperties:@{@"startAngle":@(activeSectionStartAngle),
                                                  @"angle":@(activeSectionAngle),
                                                  @"innerRadius":@(self.innerRadius),
                                                  @"outerRadius":@(self.outerRadius)}
                                         inTime:self.animationSpeed];
                
            } else {
                
                
                
                
                if (track == self.activeTrack) {
                    //Active Track, Other section.
                    
                    
                    int indexOfActiveSection = (int) [track indexForSection:self.activeSection] ;
                    int indexOfCurrentSection = (int) [track indexForSection:section];
                    
                
                    CGFloat startAngle = activeSectionStartAngle;
                    if (indexOfCurrentSection > indexOfActiveSection) {
                        startAngle += activeSectionAngle;
                    }
                    
                    CGFloat innerRadius;
                    CGFloat outerRadius;
                    if ([self trackForSection:section] == track) {
                        innerRadius = self.innerRadius;
                        outerRadius = self.outerRadius;
                    } else {
                        innerRadius = self.innerRadius;
                        outerRadius = self.innerRadius;
                    }
                    
                    
                    [section animateProperties:@{@"startAngle":@(startAngle),
                                                      @"angle":@(0),
                                                      @"innerRadius":@(innerRadius),
                                                      @"outerRadius":@(outerRadius)}
                                             inTime:self.animationSpeed];
            
                } else {
                    //Other Track, Other Section
                    
                    CGFloat sectionAngle = (section.hidden) ? 0 : [track anglePerSection];
                    
                    CGFloat innerRadius = trackCount * [self trackWidth] + self.innerRadius;
                    CGFloat outerRadius = innerRadius + [self trackWidth];
                    
                    if (self.activeTrack){
                        //There is currently an other active section. So we need to shrink this track;
                        
                        if (trackCount < [self indexForTrack:self.activeTrack]) {
                            innerRadius = self.innerRadius;
                            outerRadius = self.innerRadius;
                        } else {
                            innerRadius = self.outerRadius;
                            outerRadius = self.outerRadius;
                        }
                    }
                    
                    
                    
                    [section animateProperties:@{@"startAngle":@(currentAngle),
                                                      @"angle":@(sectionAngle),
                                                      @"innerRadius":@(innerRadius),
                                                      @"outerRadius":@(outerRadius)}
                                             inTime:self.animationSpeed];
                    
                    currentAngle += sectionAngle;
                }
            }
            
   
            
            sectionCount++;
        }
        
        trackCount++;
    }
 }




- (void) rotationGesture:(XMOneFingerRotationGestureRecognizer *)gesture
{


    self.distance = gesture.distance - self.innerRadius;

    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.activeTrack = [self trackForDistance:self.distance];
    }
    
    if (gesture.state == UIGestureRecognizerStateBegan || gesture.state == UIGestureRecognizerStateChanged) {

        if (self.activeTrack) {
        
            self.angle = gesture.angle - self.activeTrack.startAngle;
            if (self.angle < 0) self.angle += M_PI * 2;
            if (self.angle > M_PI*2) self.angle -= M_PI * 2;
            

            
            if (gesture.state == UIGestureRecognizerStateBegan) {
                
                self.activeSection = [self.activeTrack sectionForAngle:self.angle];
                if (self.activeSection) {
                    self.activeSectionStartValue = self.activeSection.value;
                    self.animationSpeed = self.touchDownSpeed;
                    [self updateSectionLayers];
                }

            } else
            
            if (gesture.state ==UIGestureRecognizerStateChanged) {
                if (self.activeSection) {
                    float sectionValue = self.activeSection.value;
                    
                    sectionValue += (gesture.rotation / (M_PI * 2));
                    
                    sectionValue = (sectionValue > 1) ? 1 : sectionValue;
                    sectionValue = (sectionValue < 0) ? 0 : sectionValue;
                  
                    self.activeSection.value = sectionValue;

                    [self sectionChanged:self.activeSection];
                    
                    self.animationSpeed = 0;
                    [self updateSectionLayers];
                }
                
            }
            
        }
        
    } else
        
    if (gesture.state == UIGestureRecognizerStateEnded) {
        self.animationSpeed = self.touchUpSpeed;
        self.activeTrack = nil;
        self.activeSection = nil;
        [self updateSectionLayers];
    }
    
}

- (int) numberOfVisibleTracks
{
    int numberOfVisibleTracks = 0;
    
    for (XMCircleTrack *track in self.circleTracks) {
        if (!track.hidden) numberOfVisibleTracks++;
    }
    
    return numberOfVisibleTracks;
}

- (CGFloat) trackWidth
{
    return (self.outerRadius - self.innerRadius) / [self numberOfVisibleTracks];
}

- (XMCircleTrack *)trackForDistance:(CGFloat)distance
{
    int trackIndex = distance / [self trackWidth];
    
    if (trackIndex < [self numberOfVisibleTracks]) return [self trackForIndex:trackIndex];
    
    return nil;
}

- (XMCircleTrack *)trackForIndex:(int)index
{
    int trackIndex = 0;
    for (XMCircleTrack *track in self.circleTracks) {
        if (trackIndex == index && !track.hidden) {
            return track;
        }
        if (!track.hidden) {
            trackIndex++;
        }
    }
    return nil;
}

- (int) indexForTrack:(XMCircleTrack *)trackToFind
{
    int index = 0;
    
    for (XMCircleTrack *track in self.circleTracks) {
        if (track == trackToFind) return index;
        if (!track.hidden) index++;
    }
    
    return -1;
}

- (XMCircleTrack *) trackForSection:(XMCircleSectionLayer *)section;
{
    for (XMCircleTrack *track in self.circleTracks) {
        if ([track.trackSections containsObject:section]) {
            return track;
        }
    }
    return nil;
}


#pragma mark - Getters & Setters


@synthesize circleTracks = _circleTracks;

- (NSArray *)circleTracks
{
    if (!_circleTracks) _circleTracks = [NSArray new];
    return _circleTracks;
}

- (void)setCircleTracks:(NSArray *)circleTracks
{
    [self removeSectionLayers];
    _circleTracks = circleTracks;
    [self createSectionLayers];
}

- (void)setOuterRadius:(CGFloat)outerRadius
{
    _outerRadius = outerRadius;
    
    self.rotationGestureRecognizer.outerRadius = outerRadius;
    [self updateSectionLayers];
}

- (void)setInnerRadius:(CGFloat)innerRadius
{
    _innerRadius = innerRadius;
    
    self.rotationGestureRecognizer.outerRadius = innerRadius;
    [self updateSectionLayers];
}

@end
