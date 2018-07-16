//  Created by Тимофей Буторин on 09/06/2018.
//  Copyright © 2018 Тимофей Буторин. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CallKit/CallKit.h>
#import "APGVideoConnectionControllerOptions.h"
#import "APGVideoConnectionViewControllerDelegate.h"

@interface APGVideoConnectionViewController : UIViewController<CXProviderDelegate>

@property (nonatomic, weak) id<APGVideoConnectionViewControllerDelegate> delegate;
@property (nonatomic) BOOL connectOnLaunch;
@property (nonatomic) UIColor *controlsColor;
@property (nonatomic) UIColor *controlsHighlightColor;

-(instancetype)initWithToken:(NSString*)token room:(NSString*)room options:(APGVideoConnectionControllerOptions*)options;
-(instancetype)initWithToken:(NSString *)token options:(APGVideoConnectionControllerOptions*)options;;
-(void)reportIncomingCall:(NSUUID*)uuid room:(NSString*)room;
-(void)performStartCallAction:(NSUUID*)uuid room:(NSString*)room;
-(void)performEndCallAction:(NSUUID*)uuid;

@end
