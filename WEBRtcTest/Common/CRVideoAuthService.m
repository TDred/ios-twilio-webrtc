//
//  AuthService.m
//  WEBRtcTest
//
//  Created by Тимофей Буторин on 13/06/2018.
//  Copyright © 2018 Тимофей Буторин. All rights reserved.
//

#import "CRVideoAuthService.h"

static NSString* const AUTH_SERVICE_URL = @"http://192.168.7.84:8080/token?identity=%@";

@interface CRVideoAuthService ()

@end

@implementation CRVideoAuthService

-(instancetype)init
{
    [NSException raise:NSGenericException format:@"Use [sharedService] instead"];
    return nil;
}

-(instancetype)initPrivate
{
    self = [super init];
    return self;
}

+(CRVideoAuthService*)sharedService
{
    static CRVideoAuthService* sharedService;
    static dispatch_once_t onceToken;
    
    if (!sharedService) {
        dispatch_once(&onceToken, ^{
            sharedService = [[CRVideoAuthService alloc] initPrivate];
        });
    }
    
    return sharedService;
}

-(void)getAuthToken:(NSString *)userName fromURL:(NSString*)URL completionBlock:(void (^)(NSString *))completionBlock
{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURL *url = URL
            ? [NSURL URLWithString:[NSString stringWithFormat:URL,userName]]
            : [NSURL URLWithString:[NSString stringWithFormat:AUTH_SERVICE_URL,userName]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Error proccessing auth request: %@", error.localizedDescription);
        }
        
        NSJSONSerialization *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSString *token = [json valueForKey:@"token"];
        completionBlock(token);
    }];
    
    [task resume];
}

@end
