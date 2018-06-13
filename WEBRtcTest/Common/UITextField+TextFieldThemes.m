//
//  UILabel+TextFieldThemes.m
//  WEBRtcTest
//
//  Created by Тимофей Буторин on 13/06/2018.
//  Copyright © 2018 Тимофей Буторин. All rights reserved.
//

#import "UITextField+TextFieldThemes.h"
#import "AppDelegate.h"

@implementation UITextField (TextFieldThemes)

-(void)setDefaultTheme:(UIColor *)backgroundColor withBottomBorderColor:(UIColor *)bottomBorderColor withFrame:(CGRect)frame
{
    UITextField *textField = self;
    textField.backgroundColor = backgroundColor;
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, frame.size.height)];
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    CAShapeLayer *bottomBorderLayer = [[CAShapeLayer alloc] init];
    //bottomBorderLayer.frame = frame;
    
    UIBezierPath *bottomBorder = [[UIBezierPath alloc] init];
    [bottomBorder moveToPoint:CGPointMake(0, frame.size.height)];
    [bottomBorder addLineToPoint:CGPointMake(frame.size.width, frame.size.height)];
    bottomBorder.lineWidth = 3.0f;
    [bottomBorder closePath];
    
    bottomBorderLayer.strokeColor = [bottomBorderColor CGColor];
    [bottomBorderLayer setPath:[bottomBorder CGPath]];
    [textField.layer addSublayer:bottomBorderLayer];
}

@end
