//
//  UIColor+ColorTemperature.h
//  QuickHue
//
//  Created by Michael Teeuw on 14-01-14.
//  Copyright (c) 2014 Michael Teeuw. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIColor (ColorTemperature)

+ (UIColor *) colorWithColorTemperature:(float)colorTemperature andBrightness:(float)brightness;
+ (UIColor *) colorWithColorTemperature:(float)colorTemperature brightness:(float)brightness andAlpha:(float)alpha;

@end
