//
//  CRVideoConnectonViewController.m
//  WEBRtcTest
//
//  Created by Тимофей Буторин on 09/06/2018.
//  Copyright © 2018 Тимофей Буторин. All rights reserved.
//

#import <TwilioVideo/TwilioVideo.h>
#import "APGVideoConnectionView.h"
#import "APGVideoConnectonViewController.h"
#import "APGVideoAuthService.h"
#import "APGUtils.h"
#import "APGConnectionStatus.h"

@interface APGVideoConnectonViewController ()

@property (nonatomic) APGVideoConnectionView *connectionView;
@property (nonatomic, copy) NSString *authToken;

#pragma mark - Twilio components
@property (nonatomic) TVILocalVideoTrack *localVideoTrack;
@property (nonatomic) TVILocalAudioTrack *localAudioTrack;
@property (nonatomic) TVIRemoteParticipant *remoteParticipant;
@property (nonatomic) TVICameraCapturer *camera;
@property (nonatomic) TVIRoom *room;

@end

@implementation APGVideoConnectonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.connectionView = [[APGVideoConnectionView alloc] init];
    self.view = self.connectionView;
    self.connectionView.delegate = self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self prepareLocalMedia];
    
    APGVideoAuthService *authService = [APGVideoAuthService sharedService];
    [self.connectionView updateConnectionStatus:APGConnectionStatusConnectingToRoom];
    [authService getAuthToken:self.identity fromURL:nil completionBlock:^(NSString *token) {
        if (!token) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.connectionView updateConnectionStatus:APGConnectionStatusFailedToConnect];
            });
            return;
        };
        
        self.authToken = token;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self doConnect];
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    //before rotation
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        //during rotation
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        //after rotation
        [self.connectionView setNeedsUpdateConstraints];
        [self.connectionView updateConstraints];
    }];
}

-(void)doConnect
{
    TVIConnectOptions *connectOptions = [TVIConnectOptions optionsWithToken:self.authToken
                                                                      block:^(TVIConnectOptionsBuilder * _Nonnull builder) {
                                                                          
                                                                          // Use the local media that we prepared earlier.
                                                                          builder.audioTracks = self.localAudioTrack ? @[ self.localAudioTrack ] : @[ ];
                                                                          builder.videoTracks = self.localVideoTrack ? @[ self.localVideoTrack ] : @[ ];
                                                                          
                                                                          // The name of the Room where the Client will attempt to connect to. Please note that if you pass an empty
                                                                          // Room `name`, the Client will create one for you. You can get the name or sid from any connected Room.
                                                                          builder.roomName = self.roomName;
                                                                      }];
    
    // Connect to the Room using the options we provided.
    self.room = [TwilioVideo connectWithOptions:connectOptions delegate:self];
    [self logStatusWithMessage:[NSString stringWithFormat:@"Attempting to connect to room %@", self.roomName]];
}

#pragma mark - CRVideoViewDelegate
-(void)endCall
{
    [self.room disconnect];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)switchCamera
{
    if (self.camera.source == TVICameraCaptureSourceFrontCamera) {
        [self.camera selectSource:TVICameraCaptureSourceBackCameraWide];
    } else {
        [self.camera selectSource:TVICameraCaptureSourceFrontCamera];
    }
}

-(void)switchMicrophone:(BOOL)isOn
{
    if (self.localAudioTrack) {
        self.localAudioTrack.enabled = isOn;
    }
}

#pragma mark - Twilio Setup
- (void)prepareLocalMedia
{
    // We will share local audio and video when we connect to room.
    // Create an audio track.
    if (!self.localAudioTrack) {
        self.localAudioTrack = [TVILocalAudioTrack trackWithOptions:nil
                                                            enabled:YES
                                                               name:@"Microphone"];
        
        if (!self.localAudioTrack) {
            [self logStatusWithMessage:@"Failed to add audio track"];
        }
    }
    
    // Create a video track which captures from the camera.
    if (!self.localVideoTrack) {
        [self startPreview];
    }
}

- (void)startPreview {
    // TVICameraCapturer is not supported with the Simulator.
#if TARGET_IPHONE_SIMULATOR
    [self.connectionView removeRemoteVideo];
    return;
#endif
    
    self.camera = [[TVICameraCapturer alloc] initWithSource:TVICameraCaptureSourceFrontCamera delegate:self];
    self.localVideoTrack = [TVILocalVideoTrack trackWithCapturer:self.camera
                                                         enabled:YES
                                                     constraints:nil
                                                            name:@"Camera"];
    if (!self.localVideoTrack) {
        [self logStatusWithMessage:@"Failed to add video track"];
    } else {
        // Add renderer to video track for local preview
        [self.connectionView setLocalVideoTrack:self.localVideoTrack];
        [self logStatusWithMessage:@"Video track created"];
    }
}

- (void)logStatusWithMessage:(NSString *)msg {
    NSLog(@"%@", msg);
    //self.messageLabel.text = msg;
}

-(void)updateConnectionStatus:(APGConnectionStatus)connectionStatus
{
    [self.connectionView updateConnectionStatus:connectionStatus];
}

- (void)cleanupRemoteParticipant {
    if (self.remoteParticipant) {
        if ([self.remoteParticipant.videoTracks count] > 0) {
            TVIRemoteVideoTrack *videoTrack = self.remoteParticipant.remoteVideoTracks[0].remoteTrack;
            [self.connectionView removeRemoteVideoTrack:videoTrack];
        }
        self.remoteParticipant = nil;
    }
}

#pragma mark - TVIRoomDelegate

- (void)didConnectToRoom:(TVIRoom *)room {
    // At the moment, this example only supports rendering one Participant at a time.
    
    [self logStatusWithMessage:[NSString stringWithFormat:@"Connected to room %@ as %@", room.name, room.localParticipant.identity]];
    [self updateConnectionStatus:APGConnectionStatusConnectedToRoom];
    
    if (room.remoteParticipants.count > 0) {
        self.remoteParticipant = room.remoteParticipants[0];
        self.remoteParticipant.delegate = self;
    }
}

- (void)room:(TVIRoom *)room didDisconnectWithError:(nullable NSError *)error {
    [self logStatusWithMessage:[NSString stringWithFormat:@"Disconncted from room %@, error = %@", room.name, error]];
    [self updateConnectionStatus:APGConnectionStatusDisconnectedDueToError];
    [self updateConnectionStatus:APGConnectionStatusFailedToConnect];
    [self cleanupRemoteParticipant];
    self.room = nil;
}

- (void)room:(TVIRoom *)room didFailToConnectWithError:(nonnull NSError *)error{
    [self logStatusWithMessage:[NSString stringWithFormat:@"Failed to connect to room, error = %@", error]];
    [self updateConnectionStatus:APGConnectionStatusFailedToConnect];
    self.room = nil;
}

- (void)room:(TVIRoom *)room participantDidConnect:(TVIRemoteParticipant *)participant {
    if (!self.remoteParticipant) {
        self.remoteParticipant = participant;
        self.remoteParticipant.delegate = self;
    }
    [self logStatusWithMessage:[NSString stringWithFormat:@"Participant %@ connected with %lu audio and %lu video tracks",
                      participant.identity,
                      (unsigned long)[participant.audioTracks count],
                      (unsigned long)[participant.videoTracks count]]];
    [self updateConnectionStatus:APGConnectionStatusParticipantConnected];
}

- (void)room:(TVIRoom *)room participantDidDisconnect:(TVIRemoteParticipant *)participant {
    if (self.remoteParticipant == participant) {
        [self cleanupRemoteParticipant];
    }
    [self logStatusWithMessage:[NSString stringWithFormat:@"Room %@ participant %@ disconnected", room.name, participant.identity]];
    [self updateConnectionStatus:APGConnectionStatusParticipantDisconnected];
}

#pragma mark - TVIRemoteParticipantDelegate

- (void)remoteParticipant:(TVIRemoteParticipant *)participant
      publishedVideoTrack:(TVIRemoteVideoTrackPublication *)publication {
    
    // Remote Participant has offered to share the video Track.
    [self logStatusWithMessage:[NSString stringWithFormat:@"Participant %@ published %@ video track .",
                      participant.identity, publication.trackName]];
}

- (void)remoteParticipant:(TVIRemoteParticipant *)participant
    unpublishedVideoTrack:(TVIRemoteVideoTrackPublication *)publication {
    
    // Remote Participant has stopped sharing the video Track.
    [self logStatusWithMessage:[NSString stringWithFormat:@"Participant %@ unpublished %@ video track.",
                      participant.identity, publication.trackName]];
}

- (void)remoteParticipant:(TVIRemoteParticipant *)participant
      publishedAudioTrack:(TVIRemoteAudioTrackPublication *)publication {
    
    // Remote Participant has offered to share the audio Track.
    [self logStatusWithMessage:[NSString stringWithFormat:@"Participant %@ published %@ audio track.",
                      participant.identity, publication.trackName]];
}

- (void)remoteParticipant:(TVIRemoteParticipant *)participant
    unpublishedAudioTrack:(TVIRemoteAudioTrackPublication *)publication {
    
    // Remote Participant has stopped sharing the audio Track.
    [self logStatusWithMessage:[NSString stringWithFormat:@"Participant %@ unpublished %@ audio track.",
                      participant.identity, publication.trackName]];
}

- (void)subscribedToVideoTrack:(TVIRemoteVideoTrack *)videoTrack
                   publication:(TVIRemoteVideoTrackPublication *)publication
                forParticipant:(TVIRemoteParticipant *)participant {
    
    // We are subscribed to the remote Participant's audio Track. We will start receiving the
    // remote Participant's video frames now.
    [self logStatusWithMessage:[NSString stringWithFormat:@"Subscribed to %@ video track for Participant %@",
                      publication.trackName, participant.identity]];
    
    if (self.remoteParticipant == participant) {
        [self.connectionView setRemoteVideoTrack:videoTrack];
        [self.connectionView updateConnectionStatus:APGConnectionStatusParticipantConnected];
    }
}

- (void)unsubscribedFromVideoTrack:(TVIRemoteVideoTrack *)videoTrack
                       publication:(TVIRemoteVideoTrackPublication *)publication
                    forParticipant:(TVIRemoteParticipant *)participant {
    
    // We are unsubscribed from the remote Participant's video Track. We will no longer receive the
    // remote Participant's video.
    [self logStatusWithMessage:[NSString stringWithFormat:@"Unsubscribed from %@ video track for Participant %@",
                      publication.trackName, participant.identity]];
    
    if (self.remoteParticipant == participant) {
        [self.connectionView removeRemoteVideoTrack:videoTrack];
    }
}

- (void)subscribedToAudioTrack:(TVIRemoteAudioTrack *)audioTrack
                   publication:(TVIRemoteAudioTrackPublication *)publication
                forParticipant:(TVIRemoteParticipant *)participant {
    
    // We are subscribed to the remote Participant's audio Track. We will start receiving the
    // remote Participant's audio now.
    [self logStatusWithMessage:[NSString stringWithFormat:@"Subscribed to %@ audio track for Participant %@",
                      publication.trackName, participant.identity]];
}

- (void)unsubscribedFromAudioTrack:(TVIRemoteAudioTrack *)audioTrack
                       publication:(TVIRemoteAudioTrackPublication *)publication
                    forParticipant:(TVIRemoteParticipant *)participant {
    
    // We are unsubscribed from the remote Participant's audio Track. We will no longer receive the
    // remote Participant's audio.
    [self logStatusWithMessage:[NSString stringWithFormat:@"Unsubscribed from %@ audio track for Participant %@",
                      publication.trackName, participant.identity]];
}

- (void)remoteParticipant:(TVIRemoteParticipant *)participant
        enabledVideoTrack:(TVIRemoteVideoTrackPublication *)publication {
    [self logStatusWithMessage:[NSString stringWithFormat:@"Participant %@ enabled %@ video track.",
                      participant.identity, publication.trackName]];
}

- (void)remoteParticipant:(TVIRemoteParticipant *)participant
       disabledVideoTrack:(TVIRemoteVideoTrackPublication *)publication {
    [self logStatusWithMessage:[NSString stringWithFormat:@"Participant %@ disabled %@ video track.",
                      participant.identity, publication.trackName]];
}

- (void)remoteParticipant:(TVIRemoteParticipant *)participant
        enabledAudioTrack:(TVIRemoteAudioTrackPublication *)publication {
    [self logStatusWithMessage:[NSString stringWithFormat:@"Participant %@ enabled %@ audio track.",
                      participant.identity, publication.trackName]];
}

- (void)remoteParticipant:(TVIRemoteParticipant *)participant
       disabledAudioTrack:(TVIRemoteAudioTrackPublication *)publication {
    [self logStatusWithMessage:[NSString stringWithFormat:@"Participant %@ disabled %@ audio track.",
                      participant.identity, publication.trackName]];
}

- (void)failedToSubscribeToAudioTrack:(TVIRemoteAudioTrackPublication *)publication
                                error:(NSError *)error
                       forParticipant:(TVIRemoteParticipant *)participant {
    [self logStatusWithMessage:[NSString stringWithFormat:@"Participant %@ failed to subscribe to %@ audio track.",
                      participant.identity, publication.trackName]];
}

- (void)failedToSubscribeToVideoTrack:(TVIRemoteVideoTrackPublication *)publication
                                error:(NSError *)error
                       forParticipant:(TVIRemoteParticipant *)participant {
    [self logStatusWithMessage:[NSString stringWithFormat:@"Participant %@ failed to subscribe to %@ video track.",
                      participant.identity, publication.trackName]];
}

#pragma mark - TVIVideoViewDelegate implementation

- (void)videoView:(TVIVideoView *)view videoDimensionsDidChange:(CMVideoDimensions)dimensions {
    NSLog(@"Dimensions changed to: %d x %d", dimensions.width, dimensions.height);
    [self.connectionView setNeedsLayout];
}

#pragma mark - TVICameraCapturerDelegate

- (void)cameraCapturer:(TVICameraCapturer *)capturer didStartWithSource:(TVICameraCaptureSource)source {
    [self.connectionView setNeedsMirrorCamera:(source == TVICameraCaptureSourceFrontCamera)];
}

@end
