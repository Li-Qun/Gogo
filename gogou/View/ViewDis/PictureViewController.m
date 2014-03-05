//
//  PictureViewController.m
//  gogou
//
//  Created by ss4346 on 13-12-16.
//  Copyright (c) 2013年 huiztech. All rights reserved.
//

#import "PictureViewController.h"

@interface PictureViewController ()

@end

@implementation PictureViewController

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
	
    //初始化数据
    advList = [[NSMutableArray alloc] init];
    [self getAdvList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark
#pragma custom method
- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)getAdvList
{
    //判断当前是否有网络
    if ([GoUtilMethod existNetWork] == 0) {
        return;
    };
    
    [SVProgressHUD show];
    NSURL *url = [[NSURL alloc] initWithString:IMAGE_RETRIEVE_LIST];
    
    __weak  ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request setPostValue:self.productID      forKey:PRODUCT_ID];
    
    [request setCompletionBlock:^{
        
        [SVProgressHUD dismiss];
        NSString *jsonString = [request responseString];
        SBJsonParser *parser =[[SBJsonParser alloc] init];
        NSArray *array = [parser objectWithString:jsonString];
        
        for(int i =0 ;i <array.count; i++)
        {
            [advList addObject:BASE_IMAGE([array[i] objectForKey:@"image"])];
        }
        
        NSLog(@" >>>  %@",jsonString);
        [self createBannerView];
        
    }];
    [request setFailedBlock:^{
        [SVProgressHUD dismiss];
        NSString *responseString = [request responseString];
        NSLog(@">>>>>>%@",responseString);
    }];
    
    [request startAsynchronous];
}

- (void)createBannerView
{
    //添加最后一张图 用于循环
    NSMutableArray *itemArray = [NSMutableArray arrayWithCapacity:advList.count+2];
    if (advList.count > 1)
    {
        SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithTitle:nil image:[advList objectAtIndex:advList.count-1] tag:-1];
        [itemArray addObject:item];
    }
    for (int i = 0; i < advList.count; i++)
    {
        SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithTitle:nil image:[advList objectAtIndex:i] tag:i];
        [itemArray addObject:item];
        
    }
    //添加第一张图 用于循环kl
    if (advList.count >1)
    {
        SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithTitle:nil image:[advList objectAtIndex:0] tag:advList.count];
        [itemArray addObject:item];
    }
    
    SGFocusImageFrame *bannerView = [[SGFocusImageFrame alloc] initWithFrame:CGRectMake(0, 100, 320, 250) delegate:self imageItems:itemArray isAuto:NO];
    [bannerView scrollToIndex:2];
    
    [self.view addSubview:bannerView];
    [self.view sendSubviewToBack:bannerView];
}

- (void)createNavigationItem
{
    self.navigationController.navigationBarHidden = NO;
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 50, 25);
    [leftButton setImage:[UIImage imageNamed:@"back_top"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] init];
    [leftItem setCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    [self setNavigationBarTitleWithImage:[UIImage imageNamed:@"title_bg_logo"]];
}

@end
