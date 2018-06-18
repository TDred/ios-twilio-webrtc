//
//  CRVideoConnectionView.h
//  WEBRtcTest
//
//  Created by Тимофей Буторин on 09/06/2018.
//  Copyright © 2018 Тимофей Буторин. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TwilioVideo/TwilioVideo.h>
#import "CRUpdatableView.h"
#import "CRVideoViewDelegate.h"

@interface CRVideoConnectionView : UIView

@property (nonatomic, weak) id<CRVideoViewDelegate> delegate;

-(void)setLocalVideoTrack:(TVILocalVideoTrack*)videoTrack;
-(void)setRemoteVideoTrack:(TVIRemoteVideoTrack*)videoTrack;
-(void)removeRemoteVideoTrack:(TVIRemoteVideoTrack*)videoTrack;
-(void)setNeedsMirrorCamera:(BOOL)mirror;

@end
