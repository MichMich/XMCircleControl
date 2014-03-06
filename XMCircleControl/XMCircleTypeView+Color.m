//
//  XMCircleTypeView+Color.m
//  
//
//  Created by Michael Teeuw on 06-03-14.
//
//

#import "XMCircleTypeView+Color.h"

@implementation XMCircleTypeView (Color)

- (void) setColor:(UIColor *)color
{
    NSMutableDictionary *textAttributes = [self.textAttributes mutableCopy];
    [textAttributes setValue:color forKey:NSForegroundColorAttributeName];
    self.textAttributes = [textAttributes copy];
}

@end
