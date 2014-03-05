//
//  ShopViewController.m
//  goshopping
//
//  Created by ss4346 on 13-12-2.
//  Copyright (c) 2013年 huiztech. All rights reserved.
//

#import "ShopViewController.h"

@interface ShopViewController ()

@end

@implementation ShopViewController

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
	[self createNavigaitonItem];
    
    [self getDetail];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self createNavigation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma -mark
#pragma custom action
- (void)toAdr
{
    
}


-(void)toTel
{
    NSLog(@"to tel");
    NSString *str = [commonDictionary objectForKey:@"telephone"];
    NSString *phoneNumber = [NSString stringWithFormat:@"tel://%@",str];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}

- (void)addfavoriteAction
{
    //判断当前是否有网络
    if ([GoUtilMethod existNetWork] == 0) {
        return;
    };
    
    [SVProgressHUD show];
    NSURL *url = [[NSURL alloc] initWithString:USER_FAVOVITE_ADD];
    
    __weak  ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    
    [request setPostValue:[GoUtilMethod getTelephone]       forKey:TELEPHONE ];
    [request setPostValue:[GoUtilMethod getPassword]        forKey:PASSWORD];
    [request setPostValue:[GoUtilMethod getUserType]        forKey:ACCOUNT_TYPE];
    [request setPostValue:self.infor.manufacturerId               forKey:CONTENT_ID];
    [request setPostValue:@"1"                              forKey:CONTENT_TYPE];
    [request setPostValue:self.infor.marketId               forKey:CONTENT_EXTRA];
    
    [request setCompletionBlock:^{
        
        [SVProgressHUD dismiss];
        NSString *jsonString = [request responseString];
        SBJsonParser *parser =[[SBJsonParser alloc] init];
        NSDictionary *dictionary = [parser objectWithString:jsonString];
        int state = [[dictionary objectForKey:@"state"] intValue];
        NSString *message = [dictionary objectForKey:@"message"];
        
        if (state ==1) {
            [SVProgressHUD showSuccessWithStatus:message duration:3];
        }else{
            [SVProgressHUD showErrorWithStatus:message duration:3];
        }
        
        
        NSLog(@" >>>  %@",jsonString);
        
    }];
    [request setFailedBlock:^{
        [SVProgressHUD dismiss];
        NSString *responseString = [request responseString];
        NSLog(@">>>>>>%@",responseString);
    }];
    
    [request startAsynchronous];
}



- (void)viewAll
{
    ProductListViewController *view = [[ProductListViewController alloc] init];
    view.filterMarketId = self.infor.marketId;
    [self.navigationController pushViewController:view animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewMore
{
    ProductListViewController *view = [[ProductListViewController alloc] init];
    view.filterManufacturerId = self.infor.manufacturerId;
    view.filterMarketId = self.infor.marketId;
    [self.navigationController pushViewController:view animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)getDetail
{
    //判断当前是否有网络
    if ([GoUtilMethod existNetWork] == 0) {
        return;
    };
    
    [SVProgressHUD show];
    NSURL *url = [[NSURL alloc] initWithString:MANUFACTURER_RETRIEVE_DETAIL];
    
    __weak  ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    
    if([GoUtilMethod isLogin]){
        [request setPostValue:[GoUtilMethod getTelephone]       forKey:TELEPHONE ];
        [request setPostValue:[GoUtilMethod getPassword]        forKey:PASSWORD];
        [request setPostValue:[GoUtilMethod getUserType]        forKey:ACCOUNT_TYPE];
        [request setPostValue:@"1"                              forKey:FOR_IS_LOGIN];
    }else{
        [request setPostValue:nil                       forKey:TELEPHONE ];
        [request setPostValue:nil                       forKey:PASSWORD];
        [request setPostValue:nil                       forKey:ACCOUNT_TYPE];
        [request setPostValue:nil                       forKey:FOR_IS_LOGIN];
    }
    
    [request setPostValue:self.infor.marketId                  forKey:MARKET_ID];
    [request setPostValue:self.infor.manufacturerId            forKey:MANUFACTURER_ID];
    
    [request setCompletionBlock:^{
        
        [SVProgressHUD dismiss];
        NSString *jsonString = [request responseString];
        SBJsonParser *parser =[[SBJsonParser alloc] init];
        NSDictionary *dictionary = [parser objectWithString:jsonString];
        
        commonDictionary = dictionary;
        NSLog(@" >>>  %@",jsonString);
        [self createMainView];
        
    }];
    [request setFailedBlock:^{
        [SVProgressHUD dismiss];
        NSString *responseString = [request responseString];
        NSLog(@">>>>>>%@",responseString);
    }];
    
    [request startAsynchronous];
}

#pragma -mark
#pragma add subview

- (void)createNavigaitonItem
{
    self.navigationController.navigationBarHidden = NO;
}

- (void)createMainView
{
    mainScrollView = [[UIScrollView alloc]init];
    mainScrollView.frame = CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - [UIApplication sharedApplication].statusBarFrame.size.height);
    mainScrollView.contentSize = CGSizeMake(320, 600);
    

    mainScrollView.backgroundColor = GO_BACKGROUND;
    
    EGOImageView *headBg = [[EGOImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 150)];
    NSURL *url = [NSURL URLWithString:BASE_IMAGE([commonDictionary objectForKey:@"image_bg"])];
    [headBg setImageURL:url];
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(10, 80, 300, 100)];
    headView.backgroundColor = GO_GRAY;
    
    imageHead = [[EGOImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
    NSURL *imageUrl = [NSURL URLWithString:BASE_IMAGE([commonDictionary objectForKey:@"image"])];
    [imageHead setImageURL:imageUrl];
    [headView addSubview:imageHead];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, 80, 30)];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    titleLabel.text = [commonDictionary objectForKey:@"name"];
    titleLabel.backgroundColor = [UIColor clearColor];
    [headView addSubview:titleLabel];
    
    typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 50, 180, 30)];
    typeLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    typeLabel.textColor = [UIColor blackColor];
    typeLabel.text = [commonDictionary objectForKey:@"keyword"];
    typeLabel.backgroundColor = [UIColor clearColor];
    [headView addSubview:typeLabel];
    
    //地图
    UIView *mapView = [[UIView alloc] initWithFrame:CGRectMake(6, 190, 308, 31)];
    mapView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"table_top"]];
    UITapGestureRecognizer *toAdr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toAdr)];
    [mapView addGestureRecognizer:toAdr];
    
    UIImageView *mapImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"merchant_address"]];
    mapImage.frame = CGRectMake(5, 5, 20, 20);
    [mapView addSubview:mapImage];
    
    UILabel *mapLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 1.5, 260, 28)];
    mapLabel.backgroundColor = [UIColor clearColor];
    mapLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    mapLabel.text = [commonDictionary objectForKey:@"address"];
    mapLabel.textColor = GO_GRAY;
    [mapView addSubview:mapLabel];
    
    //电话
    UIView *telView = [[UIView alloc] initWithFrame:CGRectMake(6, 220, 308, 28)];
    telView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"table_bottom"]];
    UITapGestureRecognizer *toTel = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toTel)];
    [telView addGestureRecognizer:toTel];
    
    UIImageView *telImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"merchant_telephone"]];
    telImage.frame = CGRectMake(5, 5, 20, 20);
    [telView addSubview:telImage];
    
    UILabel *telLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 260, 28)];
    telLabel.backgroundColor = [UIColor clearColor];
    telLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    telLabel.text = [commonDictionary objectForKey:@"telephone"];
    telLabel.textColor = GO_GRAY;
    [telView addSubview:telLabel];
    
    addFav = [[UIButton alloc] initWithFrame:CGRectMake(10, 260, 300, 30)];
    addFav.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    [addFav setBackgroundImage:[UIImage imageNamed:@"blue_btn"] forState:UIControlStateNormal];
    [addFav addTarget:self action:@selector(addfavoriteAction) forControlEvents:UIControlEventTouchUpInside];
    [addFav setTitle:@"加入收藏" forState:UIControlStateNormal];
    
    //商家介绍
    UIView *shopView = [[UIView alloc] initWithFrame:CGRectMake(6, 300, 308, 31)];
    shopView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"table_top"]];
    
    UILabel *shopLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 31)];
    shopLabel.backgroundColor = [UIColor clearColor];
    shopLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    shopLabel.textColor = GO_GRAY;
    shopLabel.text = @"商家介绍";
    [shopView addSubview:shopLabel];
    
    
    contentTextView = [[UITextView alloc] init];
    contentTextView.text = [commonDictionary objectForKey:@"description"];
    [contentTextView sizeToFit];
    int contentTextViewHeight = contentTextView.contentSize.height;
    contentTextView.frame = CGRectMake(6, 331, 308, contentTextViewHeight+10);
    contentTextView.editable = NO;
    contentTextView.scrollEnabled = NO;
    contentTextView.backgroundColor = [UIColor clearColor];
    
    
    
    btnViewAll = [[UIButton alloc] initWithFrame:CGRectMake(6, 351 + contentTextViewHeight , 150, 30)];
    btnViewAll.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    [btnViewAll setTitle:@"显示所有" forState:UIControlStateNormal];
    [btnViewAll setBackgroundImage:[UIImage imageNamed:@"blue_btn"] forState:UIControlStateNormal];
    [btnViewAll addTarget:self action:@selector(viewAll) forControlEvents:UIControlEventTouchUpInside ];
    
    
    btnViewNew = [[UIButton alloc] initWithFrame:CGRectMake(158, 351 + contentTextViewHeight , 150, 30)];
    btnViewNew.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    [btnViewNew setTitle:@"商品动态" forState:UIControlStateNormal];
    [btnViewNew setBackgroundImage:[UIImage imageNamed:@"blue_btn"] forState:UIControlStateNormal];
    [btnViewNew addTarget:self action:@selector(viewMore) forControlEvents:UIControlEventTouchUpInside ];
    
    [mainScrollView addSubview: headBg];
    [mainScrollView addSubview: headView];
    [mainScrollView addSubview: mapView];
    [mainScrollView addSubview: telView];
    [mainScrollView addSubview: addFav];
    [mainScrollView addSubview: shopView];
    [mainScrollView addSubview:contentTextView];
    [mainScrollView addSubview:btnViewAll];
    [mainScrollView addSubview:btnViewNew];
    
    [self.view addSubview:mainScrollView];
}

- (void)createNavigation
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
