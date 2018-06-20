//
//  CRTwoStateButton.h
//  WEBRtcTest
//
//  Created by Тимофей Буторин on 15/06/2018.
//  Copyright © 2018 Тимофей Буторин. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APGTwoStateButton : UIButton

@property (nonatomic) UIColor *normalColor;
@property (nonatomic) UIColor *highlightColor;
@property (nonatomic) UIImage *imageOn;
@property (nonatomic) UIImage *imageOff;
@property (nonatomic) BOOL isOn;

-(instancetype)initWithColor:(UIColor*)normalColor highlightColor:(UIColor*)highlightColor imageOn: (UIImage*)imageOn
                    imageOff:(UIImage*)imageOff;
@end
