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

@property (nonatomic) UIView *vControlPanel;
@property (nonatomic) UIView *vDeviceCameraView;
@property (nonatomic) CRTwoStateButton *btnEndCall;
@property (nonatomic) CRTwoStateButton *btnSwitchVideo;
@property (nonatomic) CRTwoStateButton *btnMute;
@property (nonatomic) UILabel *lblStatus;
@property (nonatomic) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic) BOOL isControlPanelShown;

#pragma mark - Twilio options
@property (nonatomic) TVIVideoView *remoteView;
@property (nonatomic) TVIVideoView *previewView;

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

    self.vControlPanel = [[UIView alloc] init];
    self.vControlPanel.backgroundColor = UIColor.clearColor;
    [self addSubview:self.vControlPanel];
    
    self.vDeviceCameraView = [[UIView alloc] init];
    self.vDeviceCameraView.backgroundColor = UIColor.whiteColor;
    self.vDeviceCameraView.layer.borderWidth = 3.0f;
    self.vDeviceCameraView.layer.borderColor = [RGB(0xCC3728) CGColor];
    [self addSubview:self.vDeviceCameraView];
    
    UIImage *phoneImage = [UIImage imageNamed:@"phone.png"];
    self.btnEndCall = [[CRTwoStateButton alloc] initWithColor:RGB(0xCC3728) highlightColor:RGB(0xFF8A7E) imageOn:phoneImage imageOff:nil];
    [self.btnEndCall addTarget:self action:@selector(endCall:) forControlEvents:UIControlEventTouchUpInside];
    [self.vControlPanel addSubview:self.btnEndCall];
    
    UIImage *muteImage = [UIImage imageNamed:@"microphone.png"];
    UIImage *unmuteImage = [UIImage imageNamed:@"microphone.off.png"];
    self.btnMute = [[CRTwoStateButton alloc] initWithColor:RGB(0xCC3728) highlightColor:RGB(0xFF8A7E) imageOn:muteImage imageOff:unmuteImage];
    [self.btnMute addTarget:self action:@selector(switchMicrophone:) forControlEvents:UIControlEventTouchUpInside];
    [self.vControlPanel addSubview:self.btnMute];
    
    UIImage *cameraFlipImage = [UIImage imageNamed:@"camera_flip.png"];
    self.btnSwitchVideo = [[CRTwoStateButton alloc] initWithColor:RGB(0xCC3728) highlightColor:RGB(0xFF8A7E) imageOn:cameraFlipImage imageOff:nil];
    [self.btnSwitchVideo addTarget:self action:@selector(switchCamera:) forControlEvents:UIControlEventTouchUpInside];
    [self.vControlPanel addSubview:self.btnSwitchVideo];
    
    self.previewView = [[TVIVideoView alloc] init];
    self.previewView.contentMode = UIViewContentModeScaleAspectFill;
    [self.vDeviceCameraView addSubview:self.previewView];
    
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
    
    [self.btnSwitchVideo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.vControlPanel.mas_centerX);
        make.top.equalTo(self.btnMute.mas_bottom).offset(15);
        make.width.equalTo(@50);
        make.height.equalTo(@50);
    }];
    
    [self.btnEndCall mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.vControlPanel.mas_centerX);
        make.top.equalTo(self.btnSwitchVideo.mas_bottom).offset(15);
        make.width.equalTo(@50);
        make.height.equalTo(@50);
    }];
    
    [self.previewView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.vDeviceCameraView.mas_top);
        make.left.equalTo(self.vDeviceCameraView.mas_left);
        make.right.equalTo(self.vDeviceCameraView.mas_right);
        make.bottom.equalTo(self.vDeviceCameraView.mas_bottom);
    }];
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self adjustLayoutForOrientation:UIDevice.currentDevice.orientation];
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

-(void)updateConstraints
{
    [self adjustLayoutForOrientation:UIDevice.currentDevice.orientation];
    [super updateConstraints];
}

-(void)adjustLayoutForOrientation:(UIDeviceOrientation)orientation
{
    UIView *superview = self;
    float width = superview.frame.size.width;
    float height = superview.frame.size.height;
    float aspectRatio = height / width;
    float localVideoWidth = width / 3;
    if (UIDeviceOrientationIsPortrait(orientation)) {
        [self.vDeviceCameraView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(superview.mas_right).offset(-20);
            make.bottom.equalTo(superview.mas_bottom).offset(-20);
            make.width.equalTo([NSNumber numberWithFloat:localVideoWidth]);
            make.height.equalTo(self.vDeviceCameraView.mas_width).multipliedBy(aspectRatio);
        }];
    } else {
        [self.vDeviceCameraView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(superview.mas_right).offset(-20);
            make.bottom.equalTo(superview.mas_bottom).offset(-20);
            make.width.equalTo([NSNumber numberWithFloat:localVideoWidth]);
            make.height.equalTo(self.vDeviceCameraView.mas_width).multipliedBy(aspectRatio);
        }];
    }
}

-(void)setUpRemoteVideo
{
    self.remoteView = [[TVIVideoView alloc] init];
    self.remoteView.contentMode = UIViewContentModeScaleAspectFit;
    [self insertSubview:self.remoteView atIndex:0];
    
    UIView *superview = self;
    [self.remoteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview.mas_top);
        make.left.equalTo(superview.mas_left);
        make.right.equalTo(superview.mas_right);
        make.bottom.equalTo(superview.mas_bottom);
    }];
    
    [self setNeedsUpdateConstraints];
}

#pragma mark - Actions
-(void)endCall:(id)sender
{
    [self.delegate endCall];
}

-(void)switchMicrophone:(id)sender
{
    [self.delegate switchMicrophone:self.btnMute.isOn];
}

-(void)switchCamera:(id)sender
{
    [self.delegate switchCamera];
}

#pragma mark - Public interface

-(void)setLocalVideoTrack:(TVILocalVideoTrack *)videoTrack
{
    [videoTrack addRenderer:self.previewView];
}

-(void)setRemoteVideoTrack:(TVIRemoteVideoTrack *)videoTrack
{
    if (!self.remoteView){
        [self setUpRemoteVideo];
    }
    [videoTrack addRenderer:self.remoteView];
}

-(void)removeRemoteVideoTrack:(TVIRemoteVideoTrack *)videoTrack
{
    [videoTrack removeRenderer:self.remoteView];
    [self.remoteView removeFromSuperview];
    self.remoteView = nil;
}

-(void)setNeedsMirrorCamera:(BOOL)mirror
{
    self.previewView.mirror = mirror;
}

@end
