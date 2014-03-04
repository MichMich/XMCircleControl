//
//  UIColor+ColorTemperature.m
//  QuickHue
//
//  Created by Michael Teeuw on 14-01-14.
//  Copyright (c) 2014 Michael Teeuw. All rights reserved.
//

#import "UIColor+ColorTemperature.h"

#define HUE_FOR_COLD_COLOR 200 / 360.0
#define HUE_FOR_WARM_COLOR 50 / 360.0
@implementation UIColor (ColorTemperature)

+ (UIColor *) colorWithColorTemperature:(float)colorTemperature brightness:(float)brightness andAlpha:(float)alpha
{
    colorTemperature = colorTemperature - 0.5;
    
    float hue = (colorTemperature <=0) ? HUE_FOR_COLD_COLOR : HUE_FOR_WARM_COLOR;
    float saturation = 0 + fabs(colorTemperature);
    
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha];
}

+ (UIColor *) colorWithColorTemperature:(float)colorTemperature andBrightness:(float)brightness
{
    return [UIColor colorWithColorTemperature:colorTemperature brightness:brightness andAlpha:1];
}

@end
