//
//  AppDelegate.m
//  BookSouls
//
//  Created by Dong Vo on 10/16/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import "AppDelegate.h"
#import <Google/SignIn.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "LoginViewController.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "IQKeyboardManager.h"
#import "PushNotificationView.h"
#import "Notify.h"
#import "OrderViewController.h"
#import "ContentOrderBuyingViewController.h"
#import "ContentOrderViewSellingController.h"

#define DEFAULT_HEIGHT_PUSHNOTIFY 64

@interface AppDelegate ()<UIApplicationDelegate, GIDSignInDelegate>{
    
    PushNotificationView *pushNotificationView;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    for(NSString *fontfamilyname in [UIFont familyNames])
//    {
//        NSLog(@"Family:'%@'",fontfamilyname);
//        for(NSString *fontName in [UIFont fontNamesForFamilyName:fontfamilyname])
//        {
//            NSLog(@"\tfont:'%@'",fontName);
//        }
//        NSLog(@"~~~~~~~~");
//    }
//
    
   
    
    // IQKeyboard
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    [[IQKeyboardManager sharedManager] setShouldShowToolbarPlaceholder:NO];
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    
    // Faric
     [Fabric with:@[[Crashlytics class]]];
    
    // config Google Sign In
    NSError* configureError;
    [[GGLContext sharedInstance] configureWithError: &configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
    [GIDSignIn sharedInstance].delegate = self;
    
    // config Facebook Login
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
   
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
       
      
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
    
    NSUserDefaults * defaults =  [NSUserDefaults standardUserDefaults];
    
    NSData *encodedObject = [defaults objectForKey:@"FirstRun"];
    SessionUser *object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    
    
    if(!object){
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *vcLogin = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        
        self.navigation = [[UINavigationController alloc] initWithRootViewController:vcLogin];
        
    }
    else{
        
        self.sesstionUser = object;
        
        SlideMenuViewController *vcSlideMenu = [SlideMenuViewController sharedInstance];
        self.navigation = [[UINavigationController alloc] initWithRootViewController:vcSlideMenu];
       
        
    }
    
    self.navigation.navigationBarHidden = YES;
    [self.window setRootViewController:self.navigation];
    
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
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
     [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:sourceApplication
                                                               annotation:annotation
                    ];
   
     [[GIDSignIn sharedInstance] handleURL:url
                               sourceApplication:sourceApplication
                                      annotation:annotation];
    
    return YES;
}

- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary *)options {
    [[FBSDKApplicationDelegate sharedInstance] application:app
                                                   openURL:url
                                                   options:options];
    
    [[GIDSignIn sharedInstance] handleURL:url
                        sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                               annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
    return YES;
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    if (notificationSettings.types != UIUserNotificationTypeNone) {
        NSLog(@"didRegisterUser");
        [application registerForRemoteNotifications];
    }
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler{
    
    
    if (userInfo != nil) {

        if(userInfo){
            
            NSDictionary *dicAps = [userInfo objectForKey:@"aps"];
            
            if(dicAps){
                
                NSDictionary *dicAlert = [dicAps objectForKey:@"alert"];
                
                if(dicAlert){
                    
                    Notify *notify = [[Notify alloc] init];
                    notify.content = [dicAlert objectForKey:@"body"];
                    notify.title = [dicAlert objectForKey:@"title"];
                    notify.type = [dicAlert objectForKey:@"collapsekey"];
                    
                    if(application.applicationState == UIApplicationStateActive){
                        
                         [self showMessageBoxNotification:notify];
                    }
                    else if([UIApplication sharedApplication].applicationState == UIApplicationStateInactive){
                        
                        Appdelegate_BookSouls.notiType = notify.type;
                        
                        if([[SlideMenuViewController sharedInstance] indexSelectedCurr] != Item_Order){
                            
                             [[SlideMenuViewController sharedInstance] selecItemCurr:Item_Order];
                        }
                        else{
                            
                            OrderViewController *vcOrder = [[[[SlideMenuViewController sharedInstance] vcNavigation] viewControllers] firstObject];
                            
                            [self redirectOrderWithNotification:vcOrder];
                        }
                        
                    }
                   
                    
                    SlideMenuViewController *vcSlide = [SlideMenuViewController sharedInstance];
                    
                    if(vcSlide){
                        
                        [vcSlide getNumNotiNoRead];
                    }
                    
                }
            }
        }
    }
}

- (void)redirectOrderWithNotification:(OrderViewController *)orderVC{
    
    
    if(Appdelegate_BookSouls.notiType){
        
        if([Appdelegate_BookSouls.notiType isEqualToString:@"BUYER_RECIVED_ORDER"]){
            
            [orderVC.vcSelling touchComment:nil];
        }
        else if([Appdelegate_BookSouls.notiType isEqualToString:@"BUYER_CANCEL_ORDER"]){
            
            [orderVC.vcSelling touchBtnCancel:nil];
        }
        else if ([Appdelegate_BookSouls.notiType isEqualToString:@"SELLER_CANCEL_ORDER"]){
            
            [orderVC.vcBuying touchBtnCancel:nil];
        }
        else if([Appdelegate_BookSouls.notiType isEqualToString:@"SELLER_SUCCESS_ORER"]){
            
            [orderVC.vcBuying touchBtnShping:nil];
        }
        
        Appdelegate_BookSouls.notiType = nil;
    }
    
}


- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    //NSString *str = [NSString stringWithFormat:@"Device Token=%@",deviceToken];
    
    self.deviceToken = [[[[deviceToken description]
                          stringByReplacingOccurrencesOfString: @"<" withString: @""]
                         stringByReplacingOccurrencesOfString: @">" withString: @""]
                        stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    NSLog(@"This is device token%@", deviceToken);
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    //  NSString *str = [NSString stringWithFormat: @"Error: %@", err];
    NSLog(@"Error %@",err.localizedDescription);
}

#pragma mark - Method
- (void)showMessageBoxNotification:(Notify *)notify{
        
    if(pushNotificationView){
        
        [pushNotificationView removeFromSuperview];
        pushNotificationView = nil;
    }
    
    pushNotificationView = [[PushNotificationView alloc] initWithFrame:CGRectMake(0, - DEFAULT_HEIGHT_PUSHNOTIFY, SW, DEFAULT_HEIGHT_PUSHNOTIFY) notify:notify];
    [self.window addSubview:pushNotificationView];

}


@end
