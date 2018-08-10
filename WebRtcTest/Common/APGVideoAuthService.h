//
//  AuthService.h
//  WEBRtcTest
//
//  Created by Тимофей Буторин on 13/06/2018.
//  Copyright © 2018 Тимофей Буторин. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APGVideoAuthService : NSObject

+(APGVideoAuthService*)sharedService;

-(void)sendCallNotification : (NSString*)room device:(NSString*) hardwareId;
-(void)getAuthToken : (NSString*)userName completionBlock : (void(^)(NSString*))completionBlock;

@end
