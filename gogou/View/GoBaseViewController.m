//
//  GoBaseViewController.m
//  goshopping
//
//  Created by ss4346 on 13-11-12.
//  Copyright (c) 2013年 huiztech. All rights reserved.
//

#import "GoBaseViewController.h"

@interface GoBaseViewController ()

@end

@implementation GoBaseViewController

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
	self.view.backgroundColor = GO_BACKGROUND;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma custom method
- (void)setNavigationBarTitleWithImage:(UIImage *)image
{
    UIImageView *titleView = [[UIImageView alloc] initWithImage:image];
    titleView.frame = CGRectMake(0, 0, 66, 28);
    self.navigationItem.titleView = titleView;
}

- (void)setTabBarNavigationBarTitleWithImage:(UIImage *)image
{
    self.navigationController.navigationBarHidden = NO;
    UIImageView *titleView = [[UIImageView alloc] initWithImage:image];
    titleView.frame = CGRectMake(0, 0, 66, 28);
    self.tabBarController.navigationItem.titleView = titleView;
}

- (void)hideLeftBtn
{
    self.tabBarController.navigationController.navigationBarHidden = NO;
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] init];
    [leftItem setCustomView:leftButton];
    self.tabBarController.navigationItem.leftBarButtonItem = leftItem;
}

@end
