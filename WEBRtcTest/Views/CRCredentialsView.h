//
//  CRCredentialsView.h
//  WEBRtcTest
//
//  Created by Тимофей Буторин on 13/06/2018.
//  Copyright © 2018 Тимофей Буторин. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRCredentialsDelegate.h"

@interface CRCredentialsView : UIView <UITextFieldDelegate>

@property (nonatomic, weak) id<CRCredentialsDelegate> delegate;

-(void)focusOnFirstInput;

@end
