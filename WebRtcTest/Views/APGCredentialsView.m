//
//  APGCredentialsView.m
//  WEBRtcTest
//
//  Created by Тимофей Буторин on 13/06/2018.
//  Copyright © 2018 Тимофей Буторин. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebRtcComponents/WebRtcComponents.h>
#import <Masonry/Masonry.h>
#import "APGCredentialsView.h"
#import "UITextField+TextFieldThemes.h"

@interface APGCredentialsView()

@property (nonatomic) UILabel *lblName;
@property (nonatomic) UILabel *lblRoom;
@property (nonatomic) UITextField *txtName;
@property (nonatomic) UITextField *txtRoom;
@property (nonatomic) UIButton *btnConnect;
@property (nonatomic) UIActivityIndicatorView *aiLoader;

@end

@implementation APGCredentialsView

-(instancetype)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.lblName = [[UILabel alloc] init];
    self.lblName.text = @"Enter your name:";
    [self addSubview:self.lblName];
    
    self.lblRoom = [[UILabel alloc] init];
    self.lblRoom.text = @"Enter room:";
    [self addSubview:self.lblRoom];
    
    self.btnConnect = [[UIButton alloc] init];
    [self.btnConnect addTarget:self action:@selector(connect:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnConnect setTitle:@"CONNECT" forState:UIControlStateNormal];
    [self addSubview:self.btnConnect];
    
    self.txtName = [[UITextField alloc] init];
    self.txtName.delegate = self;
    self.txtName.tag = 1;
    [self addSubview:self.txtName];
    
    self.txtRoom = [[UITextField alloc] init];
    self.txtRoom.delegate = self;
    self.txtRoom.tag = 2;
    [self addSubview:self.txtRoom];
    
    self.aiLoader = [[UIActivityIndicatorView alloc] init];
    self.aiLoader.color = UIColor.whiteColor;
    self.aiLoader.hidesWhenStopped = YES;
    [self.btnConnect addSubview:self.aiLoader];
    
    UIView *superview = self;
    [self.lblName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview.mas_top).offset(50);
        make.left.equalTo(superview.mas_left).offset(20);
        make.right.equalTo(superview.mas_right).offset(-20);
        make.height.equalTo(@45);
    }];
    
    [self.txtName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lblName.mas_bottom).offset(5);
        make.left.equalTo(superview.mas_left).offset(20);
        make.right.equalTo(superview.mas_right).offset(-20);
        make.height.equalTo(@45);
    }];
    
    [self.lblRoom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.txtName.mas_bottom).offset(20);
        make.left.equalTo(superview.mas_left).offset(20);
        make.right.equalTo(superview.mas_right).offset(-20);
        make.height.equalTo(@35);
    }];
    
    [self.txtRoom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lblRoom.mas_bottom).offset(5);
        make.left.equalTo(superview.mas_left).offset(20);
        make.right.equalTo(superview.mas_right).offset(-20);
        make.height.equalTo(@45);
    }];
    
    [self.btnConnect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.txtRoom.mas_bottom).offset(45);
        make.left.equalTo(superview.mas_left).offset(20);
        make.right.equalTo(superview.mas_right).offset(-20);
        make.height.equalTo(@45);
    }];
    
    [self.aiLoader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.btnConnect.mas_centerX);
        make.centerY.equalTo(self.btnConnect.mas_centerY);
    }];
    
    return self;
}

- (void)addLoaderToButton {
    [self.btnConnect setTitle:@"" forState:UIControlStateNormal];
    [self.aiLoader startAnimating];
}

- (void)removeLoaderFromButton {
    [self.btnConnect setTitle:@"CONNECT" forState:UIControlStateNormal];
    [self.aiLoader stopAnimating];
}

-(void)connect:(id)sender
{
    [self addLoaderToButton];
    [self.delegate didEnterCredentials:self.txtName.text roomName:self.txtRoom.text];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect buttonFrame = self.btnConnect.frame;
    [self.btnConnect roundedButton:RGB(0xCC3728) withSecondaryColor:RGB(0xFF8A7E) withSize:buttonFrame.size];
    
    CGRect nameFrame = self.txtName.frame;
    [self.txtName setDefaultTheme:RGB(0xD9D3D2) withBottomBorderColor:RGB(0xCC3728) withSize:nameFrame.size];
    
    CGRect roomFrame = self.txtRoom.frame;
    [self.txtRoom setDefaultTheme:RGB(0xD9D3D2) withBottomBorderColor:RGB(0xCC3728) withSize:roomFrame.size];
}

#pragma mark - Public interface
-(void)focusOnFirstInput
{
    if (self.txtName.canBecomeFirstResponder)
    {
        [self.txtName becomeFirstResponder];
    }
}

-(void)didEndLoad
{
    [self removeLoaderFromButton];
}

#pragma mark - UITextFieldDelegate implementation

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.backgroundColor = RGBA(0xD9D3D264);
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    textField.backgroundColor = RGB(0xD9D3D2);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    return NO;
}

@end