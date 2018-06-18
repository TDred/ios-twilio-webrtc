//
//  CRVideoConnectonViewController.h
//  WEBRtcTest
//
//  Created by Тимофей Буторин on 09/06/2018.
//  Copyright © 2018 Тимофей Буторин. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRVideoConnectionView.h"

@interface CRVideoConnectonViewController : UIViewController <CRVideoViewDelegate, TVICameraCapturerDelegate, TVIVideoViewDelegate, TVIRemoteParticipantDelegate, TVIRoomDelegate>

@property (nonatomic,copy) NSString* identity;
@property (nonatomic,copy) NSString* roomName;

@end
