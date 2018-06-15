//
//  CRVideoConnectionView.m
//  WEBRtcTest
//
//  Created by Тимофей Буторин on 09/06/2018.
//  Copyright © 2018 Тимофей Буторин. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import "CRVideoConnectionView.h"
#import "AppDelegate.h"
#import "CRTwoStateButton.h"

@interface CRVideoConnectionView()

@property (nonatomic) CRUpdatableView *vControlPanel;
@property (nonatomic) CRTwoStateButton *btnEndCall;
@property (nonatomic) CRTwoStateButton *btnTurnOffVideo;
@property (nonatomic) CRTwoStateButton *btnMute;
@property (nonatomic) UILabel *lblStatus;
@property (nonatomic) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic) BOOL isControlPanelShown;

@end

@implementation CRVideoConnectionView

-(instancetype)init
{
    self = [super init];
    if (!self) {
        return nil;
    }

    self.isControlPanelShown = YES;
    self.backgroundColor = UIColor.whiteColor;
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [self addGestureRecognizer:self.tapGestureRecognizer];

    self.vControlPanel = [[CRUpdatableView alloc] init];
    self.vControlPanel.delegate = self;
    self.vControlPanel.backgroundColor = UIColor.clearColor;
    [self addSubview:self.vControlPanel];
    
    
    UIImage *phoneImage = [UIImage imageNamed:@"phone.png"];
    self.btnEndCall = [[CRTwoStateButton alloc] initWithColor:RGB(0xCC3728) highlightColor:RGB(0xFF8A7E) imageOn:phoneImage imageOff:nil];
    [self.btnEndCall addTarget:self action:@selector(endCall:) forControlEvents:UIControlEventTouchUpInside];
    [self.vControlPanel addSubview:self.btnEndCall];
    
    UIImage *muteImage = [UIImage imageNamed:@"microphone.png"];
    UIImage *unmuteImage = [UIImage imageNamed:@"microphone.off.png"];
    self.btnMute = [[CRTwoStateButton alloc] initWithColor:RGB(0xCC3728) highlightColor:RGB(0xFF8A7E) imageOn:muteImage imageOff:unmuteImage];
    [self.vControlPanel addSubview:self.btnMute];
    
    UIImage *cameraOnImage = [UIImage imageNamed:@"video.png"];
    UIImage *cameraOffImage = [UIImage imageNamed:@"video.off.png"];
    self.btnTurnOffVideo = [[CRTwoStateButton alloc] initWithColor:RGB(0xCC3728) highlightColor:RGB(0xFF8A7E) imageOn:cameraOnImage imageOff:cameraOffImage];
    [self.vControlPanel addSubview:self.btnTurnOffVideo];
    
    UIView *superview = self;
    [self.vControlPanel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(superview.mas_centerY);
        make.height.equalTo(@210);
        make.width.equalTo(@80);
        make.left.equalTo(superview.mas_left);
    }];

    [self.btnMute mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.vControlPanel.mas_centerX);
        make.top.equalTo(self.vControlPanel.mas_top).offset(15);
        make.width.equalTo(@50);
        make.height.equalTo(@50);
    }];
    
    [self.btnTurnOffVideo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.vControlPanel.mas_centerX);
        make.top.equalTo(self.btnMute.mas_bottom).offset(15);
        make.width.equalTo(@50);
        make.height.equalTo(@50);
    }];
    
    [self.btnEndCall mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.vControlPanel.mas_centerX);
        make.top.equalTo(self.btnTurnOffVideo.mas_bottom).offset(15);
        make.width.equalTo(@50);
        make.height.equalTo(@50);
    }];
    
    return self;
}


-(void)viewTapped:(id)sender
{
    if (self.isControlPanelShown) {
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            CGPoint origin = self.vControlPanel.center;
            CGSize size = self.vControlPanel.frame.size;
            self.vControlPanel.center = CGPointMake(origin.x - size.width, origin.y);
        } completion:nil];
    } else {
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            CGPoint origin = self.vControlPanel.center;
            CGSize size = self.vControlPanel.frame.size;
            self.vControlPanel.center = CGPointMake(origin.x + size.width, origin.y);
        } completion:nil];
    }
    self.isControlPanelShown = !self.isControlPanelShown;
}

//do additional setup for control panel views if needed
-(void)didUpdateLayout
{
    
}

#pragma mark - Actions
-(void)endCall:(id)sender
{
    [self.delegate endCall];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
