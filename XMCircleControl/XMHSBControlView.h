//
//  XMHSBControlView.h
//  XMCircleControl
//
//  Created by Michael Teeuw on 03-03-14.
//  Copyright (c) 2014 Michael Teeuw. All rights reserved.
//

#import "XMCircleControlView.h"

@protocol ColorControlViewDelegate <NSObject>

- (void)hueChanged: (id)sender;
- (void)colorTemperatureChanged: (id)sender;
- (void)saturationChanged: (id)sender;
- (void)brightnessChanged: (id)sender;
- (void)powerChanged: (id)sender;

@end

@interface XMHSBControlView : XMCircleControlView

@property (nonatomic,strong) id <ColorControlViewDelegate> delegate;

@property (nonatomic) float hue;
@property (nonatomic) float colorTemperature;
@property (nonatomic) float saturation;
@property (nonatomic) float brightness;
@property (nonatomic) BOOL power;

@property (nonatomic) BOOL hueDisabled;
@property (nonatomic) BOOL colorTemperatureDisabled;
@property (nonatomic) BOOL saturationDisabled;
@property (nonatomic) BOOL brightnessDisabled;
@property (nonatomic) BOOL powerDisabled;

@property (nonatomic) BOOL colorModeIsHue;

@end
