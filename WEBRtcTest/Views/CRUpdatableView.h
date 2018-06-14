//
//  CRUpdatableView.h
//  WEBRtcTest
//
//  Created by Тимофей Буторин on 14/06/2018.
//  Copyright © 2018 Тимофей Буторин. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRLayoutUpdatedDelegate.h"

@interface CRUpdatableView : UIView

@property (nonatomic,weak) id<CRLayoutUpdatedDelegate> delegate;

@end
