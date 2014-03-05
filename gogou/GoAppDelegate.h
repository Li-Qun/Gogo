//
//  GoAppDelegate.h
//  goshopping
//
//  Created by ss4346 on 13-11-11.
//  Copyright (c) 2013年 huiztech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "BMKMapManager.h"
#import "GuideViewController.h"
#import "BMapKit.h"

@interface GoAppDelegate : NSObject <UIApplicationDelegate,UINavigationControllerDelegate>{
    UIWindow *window;
    BMKMapManager* _mapManager;
    UINavigationController *navigationController;
    
}

@property (retain, nonatomic) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet UIViewController *guideController;

@end
