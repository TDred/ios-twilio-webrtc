//
//  CRCredentialsViewController.m
//  WEBRtcTest
//
//  Created by Тимофей Буторин on 13/06/2018.
//  Copyright © 2018 Тимофей Буторин. All rights reserved.
//

#import "CRCredentialsViewController.h"
#import "CRVideoConnectonViewController.h"
#import "CRCredentialsView.h"

@interface CRCredentialsViewController ()

@property (nonatomic) CRCredentialsView* credentialsView;

@end

@implementation CRCredentialsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.credentialsView = [[CRCredentialsView alloc] init];
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
    CRVideoConnectonViewController *videoViewController = [[CRVideoConnectonViewController alloc] init];
    videoViewController.identity = identity;
    videoViewController.room = roomName;
    [self presentViewController:videoViewController animated:YES completion:nil];
}

@end
