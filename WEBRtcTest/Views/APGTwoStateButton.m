//
//  CRTwoStateButton.m
//  WEBRtcTest
//
//  Created by Тимофей Буторин on 15/06/2018.
//  Copyright © 2018 Тимофей Буторин. All rights reserved.
//

#import "APGTwoStateButton.h"

@implementation APGTwoStateButton

-(instancetype)init
{
    return [self initWithColor:UIColor.clearColor highlightColor:UIColor.clearColor imageOn:nil imageOff:nil];
}


//designamted initializer
-(instancetype)initWithColor:(UIColor *)normalColor highlightColor:(UIColor *)highlightColor imageOn:(UIImage *)imageOn imageOff:(UIImage *)imageOff
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.normalColor = normalColor;
    self.highlightColor = highlightColor;
    self.imageOn = imageOn;
    self.imageOff = imageOff;
    self.isOn = YES;
    self.adjustsImageWhenHighlighted = NO;
    self.tintColor = UIColor.whiteColor;
    self.titleLabel.font = [UIFont systemFontOfSize:22.0];
    self.backgroundColor = normalColor;
    
    [self addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self setImage];
    
    return self;
}

-(void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    if (highlighted) {
        self.backgroundColor = self.highlightColor;
    } else {
        self.backgroundColor = self.normalColor;
    }
}

-(void)buttonPressed:(id)sender
{
    self.isOn = !self.isOn;
    [self setImage];
}

- (void)setImage {
    if (self.isOn) {
        [self setImage:self.imageOn forState:UIControlStateNormal];
    } else {
        if (self.imageOff) {
            [self setImage:self.imageOff forState:UIControlStateNormal];
        }
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.layer.cornerRadius = self.bounds.size.height / 2.0;
    self.layer.masksToBounds = YES;
}
@end
