//
//  CRVideoViewDelegate.h
//  WEBRtcTest
//
//  Created by Тимофей Буторин on 15/06/2018.
//  Copyright © 2018 Тимофей Буторин. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CRVideoViewDelegate <NSObject>

-(void)endCall;
-(void)switchCamera;
-(void)switchMicrophone:(BOOL)isOn;

@end
