//
//  GoAppDelegate.m
//  goshopping
//
//  Created by ss4346 on 13-11-11.
//  Copyright (c) 2013年 huiztech. All rights reserved.
//
#import <Parse/Parse.h>
#import "GoAppDelegate.h"

#import "RegisterAndLoginViewController.h"
#import "BMapKit.h"
@implementation GoAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize guideController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    navigationController.delegate = self;
    
//    //增加标识，用于判断是否是第一次启动应用...
//    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
//    }
//    
//    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
//        self.window.rootViewController = self.navigationController;
//    }else {
//        self.window.rootViewController = self.navigationController;
//    }
//
//    
//    [self.window makeKeyAndVisible];

    // Add the navigation controller's view to the window and display.
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];

    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"GZPNCG7GhpGiWMsrAgKDGnCG"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }else{
        NSLog(@"manager start success!");
    }
    
    //设置uitabbar 背景，文字颜色
    [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"bottom_title_bg"]];
    [[UITabBar appearance] setSelectionIndicatorImage:nil];
    [UITabBarItem.appearance setTitleTextAttributes:@{ UITextAttributeTextColor : [UIColor whiteColor]} forState:UIControlStateSelected];
 
    [Parse setApplicationId:@"QDWaPFxCgYoa5fmUfb1OviE8IBfjnhFiy0ppnAPq"
                  clientKey:@"8TLFBIwTcUiRStQpBXvdOgsDTAHUdT1tOkbsXJud"];
    
    //shareSDK
    [ShareSDK registerApp:@"f526c6a4e1e"];
    
    //添加新浪微博应用
    [ShareSDK connectSinaWeiboWithAppKey:@"2327661415"
                               appSecret:@"c0cd4667648959c3a277803e0e220aef"
                             redirectUri:@"http://huiztech.com/"];
    

    //连接QQ应用以使用相关功能，此应用需要引用QQConnection.framework和QQApi.framework库
    
    [ShareSDK connectQZoneWithAppKey:@"100398297"
                           appSecret:@"cf192ac13d8e19fc208880f6b9962c96"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    [self getLocation];
   
  //*/
    return YES;
}

- (void)getLocation
{
    //判断当前是否有网络
    if ([GoUtilMethod existNetWork] == 0) {
        return;
    };
    
//    [SVProgressHUD show];
    NSURL *url = [[NSURL alloc] initWithString:STRORE_RETRIEVE_LIST];
    
    __weak  ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request setCompletionBlock:^{
//        [SVProgressHUD dismiss];
        [GoUtilMethod setMarkets:[request responseString]];
        //显示在地图上
        NSLog(@"markets >> %@",[GoUtilMethod getMarkets]);
        
    }];
    [request setFailedBlock:^{
//        [SVProgressHUD dismiss];
    }];
    
    [request startAsynchronous];
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url wxDelegate:nil];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
