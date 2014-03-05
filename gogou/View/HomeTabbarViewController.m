//
//  HomeTabbarViewController.m
//  Maystall
//
//  Created by ss4346 on 13-10-28.
//  Copyright (c) 2013年 huiztech. All rights reserved.
//

#import "HomeTabbarViewController.h"

#import "CatViewController.h"
#import "RecommendViewController.h"
#import "MapViewController.h"
#import "UCViewController.h"
#import "DiscountViewController.h"

@interface HomeTabbarViewController ()

@end

@implementation HomeTabbarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //创建各部分选项卡
    [self setTabView];
    
    //指向首页
//    [self setSelectedIndex:2];
}

#pragma -mark add subview

-(void)setTabView
{
    CatViewController *catView = [[CatViewController alloc] initWithNibName:nil bundle:nil];
    catView.tabBarItem.title = @"分类";
    
    RecommendViewController *recommendView = [[RecommendViewController alloc] initWithNibName:nil bundle:nil];
    recommendView.tabBarItem.title = @"推荐";
    
    MapViewController *mapView = [[MapViewController alloc] initWithNibName:nil bundle:nil];
    mapView.tabBarItem.title = @"地图";
    
    UCViewController *ucView = [[UCViewController alloc] initWithNibName:nil bundle:nil];
    ucView.tabBarItem.title = @"用户中心";
    
    DiscountViewController *discountView = [[DiscountViewController alloc] initWithNibName:nil bundle:nil];
    discountView.tabBarItem.title = @"折上折";
    
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 7.0) {
        catView.tabBarItem.image = [[UIImage imageNamed:@"maintab_category"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        catView.tabBarItem.selectedImage = [[UIImage imageNamed:@"maintab_category_select"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        recommendView.tabBarItem.image = [[UIImage imageNamed:@"maintab_recommond"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        recommendView.tabBarItem.selectedImage = [[UIImage imageNamed:@"maintab_recommond_select"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        mapView.tabBarItem.image = [[UIImage imageNamed:@"maintab_map"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        mapView.tabBarItem.selectedImage = [[UIImage imageNamed:@"maintab_map_select"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        ucView.tabBarItem.image = [[UIImage imageNamed:@"maintab_usercenter"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        ucView.tabBarItem.selectedImage = [[UIImage imageNamed:@"maintab_usercenter_select"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        discountView.tabBarItem.image = [[UIImage imageNamed:@"maintab_scanner"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        discountView.tabBarItem.selectedImage = [[UIImage imageNamed:@"maintab_scanner_select"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
    }else{
        catView.tabBarItem.image = [UIImage imageNamed:@"maintab_category"];
        catView.tabBarItem.selectedImage = [UIImage imageNamed:@"maintab_category_select"];
        
        recommendView.tabBarItem.image = [UIImage imageNamed:@"maintab_recommond"];
        recommendView.tabBarItem.selectedImage = [UIImage imageNamed:@"maintab_recommond_select"];
        
        mapView.tabBarItem.image = [UIImage imageNamed:@"maintab_map"];
        mapView.tabBarItem.selectedImage = [UIImage imageNamed:@"maintab_map_select"];
        
        ucView.tabBarItem.image = [UIImage imageNamed:@"maintab_usercenter"];
        ucView.tabBarItem.selectedImage = [UIImage imageNamed:@"maintab_usercenter_select"];
        
        discountView.tabBarItem.image = [UIImage imageNamed:@"maintab_scanner"];
        discountView.tabBarItem.selectedImage = [UIImage imageNamed:@"maintab_scanner_select"];
        
    }
    
    self.viewControllers = [NSArray arrayWithObjects: catView ,recommendView, mapView, ucView, discountView, nil];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
