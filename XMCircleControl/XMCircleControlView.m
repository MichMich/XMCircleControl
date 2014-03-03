//
//  XMCircleControlView.m
//  XMCircleControl
//
//  Created by Michael Teeuw on 27-02-14.
//  Copyright (c) 2014 Michael Teeuw. All rights reserved.
//

#import "XMCircleControlView.h"
#import "XMOneFingerRotationGestureRecognizer.h"


@interface XMCircleSection ()

@end

@implementation XMCircleSection

- (void)setColor:(UIColor *)color
{
    _color = color;
    self.layer.color = color;
}

@end

@interface XMCircleControlView ()

@property (nonatomic) CGFloat rotation;
@property (nonatomic) CGFloat angle;

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
    
    for (XMCircleSection *section in self.circleSections) {
        XMCircleSectionLayer *csl = section.layer;
        csl.frame = self.bounds;
    }
    
    [self updateSectionLayers];
}


#pragma mark - Public Methods

- (void)sectionChanged:(XMCircleSection *)section
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

- (void) addSectionLayers
{

    for (XMCircleSection *section in self.circleSections) {
        XMCircleSectionLayer *circleSectionLayer = [XMCircleSectionLayer new];
        circleSectionLayer.outerRadius = self.outerRadius;
        circleSectionLayer.innerRadius = self.innerRadius;

        circleSectionLayer.color =  section.color;

        [self.layer addSublayer:circleSectionLayer];
        section.layer = circleSectionLayer;
    }

}

- (void) updateSectionLayers
{

    int sectionCount = 0;
    CGFloat currentAngle = self.startAngle;
    
    for (XMCircleSection *section in self.circleSections) {
        XMCircleSectionLayer *sectionLayer = section.layer;
       
        if (self.activeSection) {
            //The is an active section;
            
            int indexOfActiveSection = (int) [self indexForSection:self.activeSection] ;
            int indexOfCurrentSection = (int) [self indexForSection:section];
            
            
            
            CGFloat activeSectionAngle;
            CGFloat activeSectionStartAngle;

            

            activeSectionAngle = (self.activeSection.value * M_PI * 2);
            activeSectionStartAngle = (self.angle + self.startAngle) - activeSectionAngle;

            
            if (section == self.activeSection) {
                
                //Animate the active section
                [sectionLayer animateProperties:@{@"startAngle":@(activeSectionStartAngle), @"angle":@(activeSectionAngle)} inTime:self.animationSpeed];
                
            } else {
                
                //Animate all other sections (to hide them)
                float startAngle = activeSectionStartAngle;
                if (indexOfCurrentSection > indexOfActiveSection) {
                    startAngle += activeSectionAngle;
                }
                
                [sectionLayer animateProperties:@{@"startAngle":@(startAngle), @"angle":@(0)} inTime:self.animationSpeed];
            }
        } else {
            //Animate all sections to distribute the sections.
            
            CGFloat sectionAngle = (section.hidden) ? 0 : [self anglePerSection];

            [sectionLayer animateProperties:@{@"startAngle":@(currentAngle), @"angle":@(sectionAngle)} inTime:self.animationSpeed];
            
            currentAngle += sectionAngle;
        }
        
        sectionCount++;
    }

 }

- (int) numberOfVisibleSections
{
    
    int numberOfVisibleSections = 0;
    
    for (XMCircleSection *section in self.circleSections) {
        if (!section.hidden) numberOfVisibleSections++;
    }
    
    return numberOfVisibleSections;
   
}

- (CGFloat) anglePerSection
{
    return self.availableAngle / [self numberOfVisibleSections];
}

- (XMCircleSection *) sectionForAngle:(float)angle
{
    
    int sectionIndex = angle / [self anglePerSection];
    
    if (sectionIndex < [self numberOfVisibleSections]) return [self sectionForIndex:sectionIndex];
    
    return nil;
    
}

- (int) indexForSection:(XMCircleSection *)sectionToFind;
{
    
    int index = 0;
    
    for (XMCircleSection *section in self.circleSections) {
        if (section == sectionToFind) return index;
        if (!section.hidden) index++;
    }
    
    return -1;
}

- (XMCircleSection *) sectionForIndex:(int)index
{
    
    int sectionIndex = 0;
    for (XMCircleSection *section in self.circleSections) {
        if (sectionIndex == index && !section.hidden) {
            return section;
        }
        if (!section.hidden) {
            sectionIndex++;
        }
    }
     
    return nil;
}

- (void) rotationGesture:(XMOneFingerRotationGestureRecognizer *)gesture
{

    self.angle = gesture.angle - self.startAngle;
    if (self.angle < 0) self.angle += M_PI * 2;
    if (self.angle > M_PI*2) self.angle -= M_PI * 2;

    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.activeSection = [self sectionForAngle:self.angle];
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
            
            if (self.activeSection.continuous) {
                sectionValue = (sectionValue > 1) ? sectionValue - 1 : sectionValue;
                sectionValue = (sectionValue < 0) ? sectionValue + 1 : sectionValue;
            } else {
                sectionValue = (sectionValue > 1) ? 1 : sectionValue;
                sectionValue = (sectionValue < 0) ? 0 : sectionValue;
            }
            
            
            self.activeSection.value = sectionValue;

            [self sectionChanged:self.activeSection];
            
            self.animationSpeed = 0;
            [self updateSectionLayers];
        }
        
    } else
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        self.animationSpeed = self.touchUpSpeed;
        self.activeSection = nil;
        [self updateSectionLayers];
    }
}


#pragma mark - Getters & Setters

@synthesize circleSections = _circleSections;

- (NSArray *)circleSections
{
    if (!_circleSections) _circleSections = [NSArray new];
    return _circleSections;
}

- (void)setCircleSections:(NSArray *)circleSections
{
    
    
    //remove old layers
    for (XMCircleSection *section in _circleSections) {
        [section.layer removeFromSuperlayer];
    }
    
    //set new sections
    _circleSections = circleSections;
    
    //add layers
    [self addSectionLayers];
    
    //set angles
    [self updateSectionLayers];
    
    
}

- (void)setOuterRadius:(CGFloat)outerRadius
{
    _outerRadius = outerRadius;
    
    for (XMCircleSection *section in self.circleSections) {
        XMCircleSectionLayer *csl = section.layer;
        csl.outerRadius = outerRadius;
    }
    
    self.rotationGestureRecognizer.outerRadius = outerRadius;
    [self updateSectionLayers];
}

- (void)setInnerRadius:(CGFloat)innerRadius
{
    _innerRadius = innerRadius;
    for (XMCircleSection *section in self.circleSections) {
        XMCircleSectionLayer *csl = section.layer;
        csl.innerRadius = innerRadius;
    }
    
    self.rotationGestureRecognizer.outerRadius = innerRadius;
    [self updateSectionLayers];
}

@end
