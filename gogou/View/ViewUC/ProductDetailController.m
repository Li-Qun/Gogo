//
//  ProductDetailController.m
//  goshopping
//
//  Created by ss4346 on 13-11-18.
//  Copyright (c) 2013年 huiztech. All rights reserved.
//

#import "ProductDetailController.h"
#import "CommondListViewController.h"
#import "ShopViewController.h"
#import "PictureViewController.h"

@interface ProductDetailController ()

@end

@implementation ProductDetailController

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
    [self createMainView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self createNavigationItem];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma -mark
#pragma -custom method
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
    [request setPostValue:self.infor.productId              forKey:CONTENT_ID];
    [request setPostValue:@"2"                              forKey:CONTENT_TYPE];
    [request setPostValue:nil                               forKey:CONTENT_EXTRA];
    
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

- (void)shareAction
{
    
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"ShareSDK"  ofType:@"jpg"];
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:@"分享内容"
                                       defaultContent:@"默认分享内容，没内容时显示"
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:@"ShareSDK"
                                                  url:@"http://www.sharesdk.cn"
                                          description:@"这是一条测试信息"
                                            mediaType:SSPublishContentMediaTypeNews];
    
    [ShareSDK showShareActionSheet:nil
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions: nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                }
                            }];
}

- (void)addAttenionAction
{
    //判断当前是否有网络
    if ([GoUtilMethod existNetWork] == 0) {
        return;
    };
    
    [SVProgressHUD show];
    NSURL *url = [[NSURL alloc] initWithString:USER_ADD_ATTENTION];
    
    __weak  ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    
    [request setPostValue:[GoUtilMethod getTelephone]       forKey:TELEPHONE ];
    [request setPostValue:[GoUtilMethod getPassword]        forKey:PASSWORD];
    [request setPostValue:[GoUtilMethod getUserType]        forKey:ACCOUNT_TYPE];
    [request setPostValue:self.infor.productId              forKey:CONTENT_ID];
    
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

- (void)toShopAction
{
    ShopViewController *view = [[ShopViewController alloc] init];
    view.infor = self.infor;
    [self.navigationController pushViewController:view animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addCommentsAction
{
    CommondListViewController *view = [[CommondListViewController alloc] init];
    view.productID = self.infor.productId;
    [self.navigationController pushViewController:view animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)detailAction
{
    PictureViewController *view = [[PictureViewController alloc] init];
    view.productID = self.infor.productId;
    [self.navigationController pushViewController:view animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma -mark
#pragma -subview
- (void)createMainView
{
    //========================================================================================================================
    //页面主体部分
    //========================================================================================================================
    
    UIScrollView *mainScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, BOTTOM_BAR_HEIGHT-44)];
    mainScroll.backgroundColor = GO_BACKGROUND;
    mainScroll.contentSize = CGSizeMake(320, 960);
    mainScroll.clipsToBounds = NO;
    mainScroll.scrollsToTop = YES;
    mainScroll.showsVerticalScrollIndicator = NO;
    
    
    headBg = [[EGOImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    NSURL *url = [NSURL URLWithString:BASE_IMAGE(self.infor.image)];
    [headBg setImageURL:url];
    [mainScroll addSubview:headBg];
    
    UIImageView *iconFav = [[UIImageView alloc] initWithFrame:CGRectMake(240, 200, 20, 20)];
    iconFav.image = [UIImage imageNamed:@"bottom_collect_baby"];
    [mainScroll addSubview:iconFav];
    
    favors = [[UILabel alloc] initWithFrame:CGRectMake(265, 200, 50, 20)];
    favors.font = [UIFont fontWithName:@"Helvetica-Bold" size:13.0];
    favors.backgroundColor = [UIColor clearColor];
    favors.textColor = [UIColor blackColor];
    favors.text = self.infor.favCount;
    [mainScroll addSubview:favors];
    
    UILabel *productLabelName = [[UILabel alloc] initWithFrame:CGRectMake(10, 220, 50, 25)];
    productLabelName.text = @"产品名:";
    productLabelName.backgroundColor = [UIColor clearColor];
    productLabelName.textColor = [UIColor blackColor];
    productLabelName.font = [UIFont fontWithName:@"Helvetica" size:13.0];
    [mainScroll addSubview:productLabelName];
    
    UILabel *productName = [[UILabel alloc] initWithFrame:CGRectMake(65, 220, 265, 25)];
    productName.text = self.infor.name;
    productName.backgroundColor = [UIColor clearColor];
    productName.textColor = [UIColor blackColor];
    productName.font = [UIFont fontWithName:@"Helvetica" size:13.0];
    [mainScroll addSubview:productName];
    
    contentText = [[UITextView alloc] init];
    contentText.text = self.infor.description;
    [contentText sizeToFit];
    contentText.backgroundColor = [UIColor clearColor];
    int contentTextViewHeight = contentText.contentSize.height;
    contentText.frame = CGRectMake(10, 250, 300, contentTextViewHeight+10);
    contentText.editable = NO;
    contentText.scrollEnabled = NO;
    [mainScroll addSubview:contentText];
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 255 + contentTextViewHeight, 40, 25)];
    priceLabel.text = @"原价：";
    priceLabel.backgroundColor = [UIColor clearColor];
    priceLabel.textColor = [UIColor lightGrayColor];
    priceLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
    [mainScroll addSubview:priceLabel];
    
    productPrice = [[StrikeThroughLabel alloc] initWithFrame:CGRectMake(60, 255 + contentTextViewHeight, 80, 25)];
    productPrice.text = self.infor.price;
    productPrice.textColor = [UIColor lightGrayColor];
    productPrice.backgroundColor = [UIColor clearColor];
    productPrice.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
    productPrice.strikeThroughEnabled = YES;
    [mainScroll addSubview:productPrice];
    
    UILabel *lowerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 270 + contentTextViewHeight, 40, 25)];
    lowerLabel.text = @"促销价";
    lowerLabel.backgroundColor = [UIColor clearColor];
    lowerLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13.0];
    [mainScroll addSubview:lowerLabel];
    
    lowerPrice = [[UILabel alloc] initWithFrame:CGRectMake(60, 270 + contentTextViewHeight, 80, 25)];
    lowerPrice.text = self.infor.price;
    lowerPrice.backgroundColor = [UIColor clearColor];
    lowerPrice.font = [UIFont fontWithName:@"Helvetica-Bold" size:13.0];
    [mainScroll addSubview:lowerPrice];
    
    
    addComments = [[UIButton alloc] initWithFrame:CGRectMake(6, 295 + contentTextViewHeight, 150, 30)];
    addComments.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    [addComments setTitle:@"吐槽" forState:UIControlStateNormal];
    [addComments setBackgroundImage:[UIImage imageNamed:@"blue_btn"] forState:UIControlStateNormal];
    [addComments addTarget:self action:@selector(addCommentsAction) forControlEvents:UIControlEventTouchUpInside ];
    [addComments setImage:[UIImage imageNamed:@"commont_icon"] forState:UIControlStateNormal];
    [mainScroll addSubview:addComments];
    
    detail = [[UIButton alloc] initWithFrame:CGRectMake(158, 295 + contentTextViewHeight, 150, 30)];
    detail.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    [detail setTitle:@"多图" forState:UIControlStateNormal];
    [detail setBackgroundImage:[UIImage imageNamed:@"blue_btn"] forState:UIControlStateNormal];
    [detail addTarget:self action:@selector(detailAction) forControlEvents:UIControlEventTouchUpInside ];
    [detail setImage:[UIImage imageNamed:@"commont_icon"] forState:UIControlStateNormal];
    [mainScroll addSubview:detail];
    
    [mainScroll setContentSize:CGSizeMake(320, 325 + contentTextViewHeight)];
    
    //========================================================================================================================
    //底部菜单栏
    //========================================================================================================================
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, VIEW_HEIGHT-44, 320, 49)];
    bottomView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"prodetail_bottom_bg"]];
    
    addfavorite = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 49)];
    [addfavorite setTitle:@"收藏宝贝" forState:UIControlStateNormal];
    [addfavorite setTitleColor:GO_ORANGE forState:UIControlStateNormal];
    [addfavorite setImage:[UIImage imageNamed:@"bottom_collect_baby"] forState:UIControlStateNormal ];
    [addfavorite setImage:[UIImage imageNamed:@"bottom_collect_baby"] forState:UIControlStateHighlighted];
    [addfavorite setImage:[UIImage imageNamed:@"collected"] forState:UIControlStateSelected];
    [addfavorite setTitleEdgeInsets:UIEdgeInsetsMake(30.0, -22.0, 5.0, 0.0)];
    [addfavorite setImageEdgeInsets:UIEdgeInsetsMake(-10, 20, 0, 0)];
    [addfavorite addTarget:self action:@selector(addfavoriteAction) forControlEvents:UIControlEventTouchUpInside];
    addfavorite.backgroundColor = [UIColor clearColor];
    addfavorite.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:10.0];
    [bottomView addSubview:addfavorite];
    
    share= [[UIButton alloc] initWithFrame:CGRectMake(83.3, 0, 70, 49)];
    [share setTitle:@"分享" forState:UIControlStateNormal];
    [share setTitleColor:GO_ORANGE forState:UIControlStateNormal];
    [share setImage:[UIImage imageNamed:@"prodetail_bottom_share"] forState:UIControlStateNormal ];
    [share setImage:[UIImage imageNamed:@"prodetail_bottom_share"] forState:UIControlStateHighlighted];
    [share setTitleEdgeInsets:UIEdgeInsetsMake(30.0, -26.0, 5.0, 0.0)];
    [share addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    [share setImageEdgeInsets:UIEdgeInsetsMake(-10, 20, 0, 0)];
    share.backgroundColor = [UIColor clearColor];
    share.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:10.0];
    [bottomView addSubview:share];
    
    //分享按钮
    addAttenion = [[UIButton alloc] initWithFrame:CGRectMake(166.6, 0, 70, 49)];
    [addAttenion setTitle:@"关注" forState:UIControlStateNormal];
    [addAttenion setTitleColor:GO_ORANGE forState:UIControlStateNormal];
    [addAttenion setImage:[UIImage imageNamed:@"bottom_my_attention"] forState:UIControlStateNormal];
    [addAttenion setImage:[UIImage imageNamed:@"bottom_my_attention"] forState:UIControlStateHighlighted];
    [addAttenion setTitleEdgeInsets:UIEdgeInsetsMake(30.0, -24.0, 5.0, 0.0)];
    [addAttenion setImageEdgeInsets:UIEdgeInsetsMake(-10, 20, 0, 0)];
    [addAttenion addTarget:self action:@selector(addAttenionAction) forControlEvents:UIControlEventTouchUpInside];
    addAttenion.backgroundColor = [UIColor clearColor];
    addAttenion.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:10.0];
    [bottomView addSubview:addAttenion];
    
    //购物车按钮
    toShop = [[UIButton alloc] initWithFrame:CGRectMake(249.9, 0, 70, 49)];
    [toShop setTitle:@"商铺" forState:UIControlStateNormal];
    [toShop setTitleColor:GO_ORANGE forState:UIControlStateNormal];
    [toShop setImage:[UIImage imageNamed:@"bottom_collect_merchant"] forState:UIControlStateNormal];
    [toShop setImage:[UIImage imageNamed:@"bottom_collect_merchant"] forState:UIControlStateHighlighted];
    [toShop setTitleEdgeInsets:UIEdgeInsetsMake(30.0, -24.0, 5.0, 0.0)];
    [toShop setImageEdgeInsets:UIEdgeInsetsMake(-10, 20, 0, 0)];
    [toShop addTarget:self action:@selector(toShopAction) forControlEvents:UIControlEventTouchUpInside];
    toShop.backgroundColor = [UIColor clearColor];
    toShop.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:10.0];
    [bottomView addSubview:toShop];
    
    [self.view addSubview:mainScroll];
    [self.view addSubview:bottomView];
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
