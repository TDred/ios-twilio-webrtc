//
//  APGCredentialsViewController.m
//  WEBRtcTest
//
//  Created by Тимофей Буторин on 13/06/2018.
//  Copyright © 2018 Тимофей Буторин. All rights reserved.
//

#import <WebRtcComponents/WebRtcComponents.h>
#import "APGCredentialsViewController.h"
#import "APGCredentialsView.h"

@interface APGCredentialsViewController ()

@property (nonatomic) APGCredentialsView* credentialsView;

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
    APGVideoConnectonViewController *videoViewController = [[APGVideoConnectonViewController alloc] init];
    videoViewController.identity = identity;
    videoViewController.roomName = roomName;
    [self presentViewController:videoViewController animated:YES completion:nil];
}

@end
