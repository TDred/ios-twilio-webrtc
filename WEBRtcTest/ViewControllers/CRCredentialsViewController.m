//
//  CRCredentialsViewController.m
//  WEBRtcTest
//
//  Created by Тимофей Буторин on 13/06/2018.
//  Copyright © 2018 Тимофей Буторин. All rights reserved.
//

#import "CRCredentialsViewController.h"
#import "CRCredentialsView.h"

@interface CRCredentialsViewController ()

@property (nonatomic) UIView* credentialsView;

@end

@implementation CRCredentialsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.credentialsView = [[CRCredentialsView alloc] init];
    self.view = self.credentialsView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
