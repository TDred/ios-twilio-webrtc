//
//  UILabel+TextFieldThemes.h
//  WEBRtcTest
//
//  Created by Тимофей Буторин on 13/06/2018.
//  Copyright © 2018 Тимофей Буторин. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (TextFieldThemes)

-(void) setDefaultTheme : (UIColor*) backgroundColor withBottomBorderColor:(UIColor*) bottomBorderColor withSize: (CGSize) size;

@end
