//
//  APGVideoConnectionView.h
//  WEBRtcTest
//
//  Created by Тимофей Буторин on 09/06/2018.
//  Copyright © 2018 Тимофей Буторин. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TwilioVideo/TwilioVideo.h>
#import "APGVideoViewDelegate.h"
#import "APGConnectionStatus.h"

@interface APGVideoConnectionView : UIView

@property (nonatomic, weak) id<APGVideoViewDelegate> delegate;

-(void)setLocalVideoTrack:(TVILocalVideoTrack*)videoTrack;
-(void)setRemoteVideoTrack:(TVIRemoteVideoTrack*)videoTrack;
-(void)removeRemoteVideoTrack:(TVIRemoteVideoTrack*)videoTrack;
-(void)setNeedsMirrorCamera:(BOOL)mirror;
-(void)updateConnectionStatus:(APGConnectionStatus)connectionStatus;

@end
