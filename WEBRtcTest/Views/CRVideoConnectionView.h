//
//  CRVideoConnectionView.h
//  WEBRtcTest
//
//  Created by Тимофей Буторин on 09/06/2018.
//  Copyright © 2018 Тимофей Буторин. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRUpdatableView.h"
#import "CRVideoViewDelegate.h"

@interface CRVideoConnectionView : UIView <CRLayoutUpdatedDelegate>

@property (nonatomic, weak) id<CRVideoViewDelegate> delegate;

@end
