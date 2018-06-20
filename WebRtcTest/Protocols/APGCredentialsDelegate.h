//
//  CRCrediantialsDelegate.h
//  WEBRtcTest
//
//  Created by Тимофей Буторин on 14/06/2018.
//  Copyright © 2018 Тимофей Буторин. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol APGCredentialsDelegate <NSObject>

-(void)didEnterCredentials : (NSString*)identity roomName : (NSString*)roomName;

@end
