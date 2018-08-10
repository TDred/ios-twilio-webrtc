//
//  APGCredentialsViewController.m
//  WEBRtcTest
//
//  Created by Тимофей Буторин on 13/06/2018.
//  Copyright © 2018 Тимофей Буторин. All rights reserved.
//

#import <WebRtcComponents/WebRtcComponents.h>
#import "APGCredentialsViewController.h"
#import "APGVideoAuthService.h"
#import "APGCredentialsView.h"

@interface APGCredentialsViewController () <APGVideoConnectionViewControllerDelegate>

@property (nonatomic) APGCredentialsView* credentialsView;

@property (nonatomic, copy) NSString *roomName;

@end

@implementation APGCredentialsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.credentialsView = [[APGCredentialsView alloc] init];
    self.credentialsView.delegate = self;
    self.view = self.credentialsView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.credentialsView focusOnFirstInput];
}

-(void)didEnterCredentials:(NSString *)identity roomName:(NSString *)roomName
{
    self.roomName = roomName;
    APGVideoAuthService *authService = [APGVideoAuthService sharedService];
    
    __weak APGCredentialsViewController* weakSelf = self;
    [authService getAuthToken:identity completionBlock:^(NSString *token) {
        APGCredentialsViewController *strongSelf = weakSelf;
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.credentialsView didEndLoad];
                if (!token) {
                    [strongSelf showConnectionErrorAlert];
                    return;
                }
                
                APGVideoConnectionControllerOptions *options = [[APGVideoConnectionControllerOptions alloc] init];
                options.appIcon = UIImagePNGRepresentation([UIImage imageNamed:@"iLobby_logo_call_small"]);
                APGVideoConnectionViewController *videoViewController = [[APGVideoConnectionViewController alloc] initWithToken:token room:roomName options:options];
                videoViewController.connectOnLaunch = YES;
                videoViewController.delegate = self;
                [strongSelf presentViewController:videoViewController animated:YES completion:nil];
            });
    }];
    
}

-(void)showConnectionErrorAlert
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error connecting to server" message:@"Cannot obtain an access token.\nCheck your internet connection" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:dismissAction];
    [self presentViewController:alertController animated:YES  completion:nil];
}

- (void)callEnded:(id)sender
{
    self.roomName = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)callStarted:(id)sender
{
    APGVideoAuthService *authService = [APGVideoAuthService sharedService];
    [authService sendCallNotification:self.roomName device:@"3b1ffa6e54a54f3eac5a5a555c658bea"];
    
}

@end
