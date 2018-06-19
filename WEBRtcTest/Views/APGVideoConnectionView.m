//
//  APGVideoConnectionView.m
//  WEBRtcTest
//
//  Created by Тимофей Буторин on 09/06/2018.
//  Copyright © 2018 Тимофей Буторин. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import "APGVideoConnectionView.h"
#import "Utils.h"
#import "APGTwoStateButton.h"

@interface APGVideoConnectionView()

@property (nonatomic) UIView *vControlPanel;
@property (nonatomic) UIView *vDeviceCameraView;
@property (nonatomic) APGTwoStateButton *btnEndCall;
@property (nonatomic) APGTwoStateButton *btnSwitchVideo;
@property (nonatomic) APGTwoStateButton *btnMute;
@property (nonatomic) UILabel *lblLocalStatus;
@property (nonatomic) UILabel *lblRemoteStatus;
@property (nonatomic) UIStackView *svRemoteStatusPanel;
@property (nonatomic) UIActivityIndicatorView *aiRemoteLoader;
@property (nonatomic) UIActivityIndicatorView *aiLocalLoader;
@property (nonatomic) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic) BOOL isControlPanelShown;

#pragma mark - Twilio components
@property (nonatomic) TVIVideoView *remoteView;
@property (nonatomic) TVIVideoView *previewView;

@end

@implementation APGVideoConnectionView

-(instancetype)init
{
    return [self initWithColor:RGB(0xCC3728) highlightColor:RGB(0xFF8A7E)];
}

//designated initializer
-(instancetype)initWithColor:(UIColor*)color highlightColor:(UIColor*)highlightColor
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
    
    self.svRemoteStatusPanel = [[UIStackView alloc] init];
    self.svRemoteStatusPanel.spacing = 10;
    self.svRemoteStatusPanel.axis = UILayoutConstraintAxisVertical;
    self.svRemoteStatusPanel.distribution = UIStackViewDistributionFillProportionally;
    self.svRemoteStatusPanel.alignment = UIStackViewAlignmentCenter;
    [self addSubview:self.svRemoteStatusPanel];
    
    self.aiRemoteLoader = [[UIActivityIndicatorView alloc] init];
    self.aiRemoteLoader.hidesWhenStopped = YES;
    self.aiRemoteLoader.color = UIColor.blackColor;
    [self.svRemoteStatusPanel addArrangedSubview:self.aiRemoteLoader];
    
    self.lblRemoteStatus = [[UILabel alloc] init];
    self.lblRemoteStatus.font = [UIFont systemFontOfSize:15.0];
    self.lblRemoteStatus.numberOfLines = 0;
    self.lblRemoteStatus.lineBreakMode = NSLineBreakByWordWrapping;
    self.lblRemoteStatus.textColor = UIColor.blackColor;
    self.lblRemoteStatus.textAlignment = NSTextAlignmentCenter;
    [self.svRemoteStatusPanel addArrangedSubview:self.lblRemoteStatus];
    
    self.vDeviceCameraView = [[UIView alloc] init];
    self.vDeviceCameraView.backgroundColor = UIColor.blackColor;
    [self addSubview:self.vDeviceCameraView];
    
    self.aiLocalLoader = [[UIActivityIndicatorView alloc] init];
    self.aiLocalLoader.hidesWhenStopped = YES;
    self.aiLocalLoader.color = UIColor.whiteColor;
    [self.vDeviceCameraView addSubview:self.aiLocalLoader];
    
    UIImage *phoneImage = [UIImage imageNamed:@"phone.png"];
    self.btnEndCall = [[APGTwoStateButton alloc] initWithColor:color highlightColor:highlightColor imageOn:phoneImage imageOff:nil];
    [self.btnEndCall addTarget:self action:@selector(endCall:) forControlEvents:UIControlEventTouchUpInside];
    [self.vControlPanel addSubview:self.btnEndCall];
    
    UIImage *muteImage = [UIImage imageNamed:@"microphone.png"];
    UIImage *unmuteImage = [UIImage imageNamed:@"microphone.off.png"];
    self.btnMute = [[APGTwoStateButton alloc] initWithColor:color highlightColor:highlightColor imageOn:muteImage imageOff:unmuteImage];
    [self.btnMute addTarget:self action:@selector(switchMicrophone:) forControlEvents:UIControlEventTouchUpInside];
    [self.vControlPanel addSubview:self.btnMute];
    
    UIImage *cameraFlipImage = [UIImage imageNamed:@"camera_flip.png"];
    self.btnSwitchVideo = [[APGTwoStateButton alloc] initWithColor:color highlightColor:highlightColor imageOn:cameraFlipImage imageOff:nil];
    [self.btnSwitchVideo addTarget:self action:@selector(switchCamera:) forControlEvents:UIControlEventTouchUpInside];
    [self.vControlPanel addSubview:self.btnSwitchVideo];
    
    self.previewView = [[TVIVideoView alloc] init];
    self.previewView.contentMode = UIViewContentModeScaleAspectFill;
    [self.vDeviceCameraView addSubview:self.previewView];
    
    UIView *superview = self;
    [self.svRemoteStatusPanel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(superview.mas_centerY);
        make.centerX.equalTo(superview.mas_centerX);
        make.left.equalTo(superview.mas_left).offset(80);
        make.right.equalTo(superview.mas_right).offset(-80);
    }];
    
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
    
    [self.aiLocalLoader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.vDeviceCameraView.mas_centerX);
        make.centerY.equalTo(self.vDeviceCameraView.mas_centerY);
    }];
    
    [self.aiLocalLoader startAnimating];
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.vDeviceCameraView.layer.shadowRadius = 5.0f;
    self.vDeviceCameraView.layer.shadowOpacity = 0.7f;
    
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
    [self.aiLocalLoader stopAnimating];
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

-(void)updateConnectionStatus:(APGConnectionStatus)connectionStatus
{
    switch (connectionStatus) {
        case APGConnectionStatusConnectingToRoom:
            [self.aiRemoteLoader startAnimating];
            self.lblRemoteStatus.text = @"Connecting to room";
            break;
        case APGConnectionStatusConnectedToRoom:
            self.lblRemoteStatus.text = @"Connected to room, waiting for second participant";
            break;
        case APGConnectionStatusParticipantConnected:
            [self.aiRemoteLoader stopAnimating];
            self.lblRemoteStatus.text = @"";
            break;
        case APGConnectionStatusParticipantDisconnected:
            [self.aiRemoteLoader stopAnimating];
            self.lblRemoteStatus.text = @"Second participant disconnected";
            break;
        case APGConnectionStatusFailedToConnect:
            [self.aiRemoteLoader stopAnimating];
            self.lblRemoteStatus.text = @"Failed to connect, try again";
            break;
        case APGConnectionStatusDisconnectedDueToError:
            [self.aiRemoteLoader stopAnimating];
            self.lblRemoteStatus.text = @"Connection failure, try again";
            break;
        default:
            break;
    }
}

@end
