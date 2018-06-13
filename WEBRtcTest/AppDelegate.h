//
//  AppDelegate.h
//  QRCodeScanner
//
//  Created by Тимофей Буторин on 24/04/2018.
//  Copyright © 2018 Тимофей Буторин. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RGB(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 \
green:((float)((hex & 0xFF00) >> 8)) / 255.0 \
blue:((float)(hex & 0xFF)) / 255.0 \
alpha:1.0]

#define RGBA(hex) [UIColor colorWithRed:((float)((hex & 0xFF000000) >> 24)) / 255.0 \
green:((float)((hex & 0xFF0000) >> 16)) / 255.0 \
blue:((float)((hex & 0xFF00) >> 8)) / 255.0 \
alpha:((float)(hex & 0xFF)) / 255.0]

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

