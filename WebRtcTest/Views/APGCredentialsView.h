//
//  APGCredentialsView.h
//  WEBRtcTest
//
//  Created by Тимофей Буторин on 13/06/2018.
//  Copyright © 2018 Тимофей Буторин. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APGCredentialsDelegate.h"

@interface APGCredentialsView : UIView <UITextFieldDelegate>

@property (nonatomic, weak) id<APGCredentialsDelegate> delegate;

-(void)focusOnFirstInput;

@end
