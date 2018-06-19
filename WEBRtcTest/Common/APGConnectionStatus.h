//
//  APGConnectionStatus.h
//  WEBRtcTest
//
//  Created by Тимофей Буторин on 19/06/2018.
//  Copyright © 2018 Тимофей Буторин. All rights reserved.
#import <Foundation/Foundation.h>

typedef NS_ENUM (NSUInteger, APGConnectionStatus){
    APGConnectionStatusConnectingToRoom = 0,
    APGConnectionStatusConnectedToRoom = 1,
    APGConnectionStatusParticipantConnected = 2,
    APGConnectionStatusParticipantDisconnected = 3,
    APGConnectionStatusFailedToConnect = 4,
    APGConnectionStatusDisconnectedDueToError = 5
};
