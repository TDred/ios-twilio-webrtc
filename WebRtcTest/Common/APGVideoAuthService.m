//
//  AuthService.m
//  WEBRtcTest
//
//  Created by Тимофей Буторин on 13/06/2018.
//  Copyright © 2018 Тимофей Буторин. All rights reserved.
//

#import "APGVideoAuthService.h"

static NSString* const AUTH_SERVICE_URL = @"http://192.168.7.84:9286/api%@";
//static NSString* const AUTH_SERVICE_URL = @"http://192.168.1.108:8080/token?identity=%@";

@interface APGVideoAuthService ()

@end

@implementation APGVideoAuthService

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

+(APGVideoAuthService*)sharedService
{
    static APGVideoAuthService* sharedService;
    static dispatch_once_t onceToken;
    
    if (!sharedService) {
        dispatch_once(&onceToken, ^{
            sharedService = [[APGVideoAuthService alloc] initPrivate];
        });
    }
    
    return sharedService;
}

-(void)getAuthToken:(NSString *)userName completionBlock:(void (^)(NSString *))completionBlock
{
    NSURLSession *session = [self getSession];
    NSString *serverPath = [NSString stringWithFormat:@"/video/accesstoken/%@", userName];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:AUTH_SERVICE_URL,serverPath]];
    NSURLRequest *request = [self getRequest:url];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Error proccessing auth request: %@", error.localizedDescription);
            completionBlock(nil);
            return;
        }
        
        NSJSONSerialization *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSString *token = [json valueForKey:@"Token"];
        completionBlock(token);
    }];
    
    [task resume];
}

-(void)sendCallNotification:(NSString *)room device:(NSString *)hardwareId
{
    NSURLSession *session = [self getSession];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:AUTH_SERVICE_URL,@"/video/reportcall"]];
    NSMutableURLRequest *request = [self getRequest:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSDictionary *jsonDictionary = @{@"Room":room, @"HardwareId":hardwareId};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary options:0 error:nil];
    request.HTTPBody = jsonData;
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Error proccessing notification request: %@", error.localizedDescription);
            return;
        }
    }];
    
    [task resume];
}


-(NSURLSession*)getSession
{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    return session;
    
}

-(NSMutableURLRequest*)getRequest:(NSURL*)url
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setValue:@"Basic ZjU4YTkyNmQwMmUxNGU3MzkzYzU3MzIyMjRkYTEwNTQ6ZHVtbXlfcGFzc3dvcmQ=" forHTTPHeaderField:@"Authorization"];
    [request setValue:@"F7294640D60142F0AABBB62230BB6A67" forHTTPHeaderField:@"X-ApiKey"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    return request;
}
@end
