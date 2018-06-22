//  Created by Тимофей Буторин on 09/06/2018.
//  Copyright © 2018 Тимофей Буторин. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APGVideoConnectionViewControllerDelegate.h"

@interface APGVideoConnectionViewController : UIViewController 

@property (nonatomic, weak) id<APGVideoConnectionViewControllerDelegate> delegate;
@property (nonatomic,copy) NSString* identity;
@property (nonatomic,copy) NSString* roomName;
@property (nonatomic,copy) NSString* authToken;
@property (nonatomic) UIColor *controlsColor;
@property (nonatomic) UIColor *controlsHighlightColor;

@end
