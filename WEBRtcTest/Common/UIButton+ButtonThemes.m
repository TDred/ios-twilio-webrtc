//
//  UILabel+ButtonThemes.m
//  WEBRtcTest
//
//  Created by Тимофей Буторин on 13/06/2018.
//  Copyright © 2018 Тимофей Буторин. All rights reserved.
//

#import "UIButton+ButtonThemes.h"

@implementation UIButton (ButtonThemes)

- (void)roundedButton:(UIColor *)color withSecondaryColor:(UIColor *)secondaryColor withFrame:(CGRect)frame
{
    UIButton *button = self;
    button.titleLabel.font = [UIFont systemFontOfSize:22.0];
    
    [button setBackgroundImage:[self imageWithColor:color] forState:UIControlStateNormal];
    [button setBackgroundImage:[self imageWithColor:secondaryColor] forState:UIControlStateHighlighted];
    button.layer.frame = frame;
    button.layer.cornerRadius = frame.size.height / 2.0;
    button.layer.masksToBounds = YES;
}


#pragma mark - Private helpers

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
