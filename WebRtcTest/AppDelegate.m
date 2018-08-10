//
//  AppDelegate.m
//  QRCodeScanner
//
//  Created by Тимофей Буторин on 24/04/2018.
//  Copyright © 2018 Тимофей Буторин. All rights reserved.
//

#import <UserNotifications/UserNotifications.h>
#import <WebRtcComponents/WebRtcComponents.h>
#import <PushKit/PushKit.h>
#import "AppDelegate.h"
#import "APGVideoAuthService.h"
#import "APGCredentialsViewController.h"

@interface AppDelegate () <PKPushRegistryDelegate>

@property (nonatomic) PKPushRegistry *pushRegistry;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UIWindow *mainWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window = mainWindow;
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[APGCredentialsViewController alloc] init];
    [self.window makeKeyAndVisible];
    
    [self registerForRemoteNotifications];
    
    self.pushRegistry = [[PKPushRegistry alloc] initWithQueue:nil];
    self.pushRegistry.delegate = self;
    self.pushRegistry.desiredPushTypes = [[NSSet alloc] initWithArray:@[PKPushTypeVoIP]];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - PKPushRegistryDelegate

- (NSString *)extractToken:(NSData*)pushToken {
    const char *data = [pushToken bytes];
    NSMutableString *token = [NSMutableString string];
    
    for (NSUInteger i = 0; i < [pushToken length]; i++) {
        [token appendFormat:@"%02.2hhX", data[i]];
    }
    return [token copy];
}

- (void)pushRegistry:(PKPushRegistry *)registry didUpdatePushCredentials:(PKPushCredentials *)pushCredentials forType:(PKPushType)type
{
    NSString* token = [self extractToken:pushCredentials.token];
    NSLog(@"PK Push Registry Device Token: %@", [token lowercaseString]);
}

-(void)pushRegistry:(PKPushRegistry *)registry didReceiveIncomingPushWithPayload:(PKPushPayload *)payload forType:(PKPushType)type withCompletionHandler:(void (^)(void))completion
{
    NSString *room = payload.dictionaryPayload[@"room"];
    APGVideoAuthService *authService = [APGVideoAuthService sharedService];
    [authService getAuthToken:@"Bob" completionBlock:^(NSString *token) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!token) {
                NSLog(@"Error getting access token");
                return;
            }
            
            APGVideoConnectionControllerOptions *options = [[APGVideoConnectionControllerOptions alloc] init];
            options.appIcon = UIImagePNGRepresentation([UIImage imageNamed:@"iLobby_logo_call_small"]);
            APGVideoConnectionViewController *callViewController = [[APGVideoConnectionViewController alloc] initWithToken:token options:options];
            UIViewController *rootViewController = self.window.rootViewController;
            [rootViewController presentViewController:callViewController animated:YES completion:nil];
            [callViewController reportIncomingCall:[NSUUID UUID] room:room];
            
            completion();
        });
    }];
}

#pragma mark - Push Notifications
-(void)registerForRemoteNotifications
{
    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound completionHandler:^(BOOL granted, NSError *error) {
        NSLog(@"Push notifications permission granted: %d", granted);
        if (!granted){
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication.sharedApplication registerForRemoteNotifications];
        });
    }];
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString* token = [self extractToken:deviceToken];
    NSLog(@"Push Registry Device Token: %@", [token lowercaseString]);
}


@end
