//
//  CRVideoConnectonViewController.m
//  WEBRtcTest
//
//  Created by Тимофей Буторин on 09/06/2018.
//  Copyright © 2018 Тимофей Буторин. All rights reserved.
//

#import "CRVideoConnectonViewController.h"
#import "CRVideoConnectionView.h"

@interface CRVideoConnectonViewController ()

@property (nonatomic) CRVideoConnectionView *connectionView;

@end

@implementation CRVideoConnectonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.connectionView = [[CRVideoConnectionView alloc] init];
    self.view = self.connectionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
