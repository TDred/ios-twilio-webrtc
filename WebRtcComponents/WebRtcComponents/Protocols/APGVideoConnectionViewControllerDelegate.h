//
//  APGVideoConnectionViewDelegate.h
//  WebRtcComponents
//
//  Created by Тимофей Буторин on 22/06/2018.
//  Copyright © 2018 App Gear. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol APGVideoConnectionViewControllerDelegate <NSObject>

@required
-(void)callEnded:(id)sender;
-(void)callStarted:(id)sender;
-(void)callFailed:(id)sender;

@end
