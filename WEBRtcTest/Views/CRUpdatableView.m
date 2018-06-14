//
//  CRUpdatableView.m
//  WEBRtcTest
//
//  Created by Тимофей Буторин on 14/06/2018.
//  Copyright © 2018 Тимофей Буторин. All rights reserved.
//

#import "CRUpdatableView.h"

@implementation CRUpdatableView

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.delegate didUpdateLayout];
}

@end
