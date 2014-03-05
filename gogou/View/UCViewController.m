//
//  UCViewController.m
//  goshopping
//
//  Created by ss4346 on 13-11-13.
//  Copyright (c) 2013年 huiztech. All rights reserved.
//

#import "UCViewController.h"

#import "ILikedViewController.h"
#import "WishShopViewController.h"
#import "UserInforViewController.h"
#import "WishProductViewController.h"
#import "LeaveMessageViewController.h"


//=====================
//Test
//=====================

@interface UCViewController ()

@end

@implementation UCViewController

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
    [self mainView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self createNavigationItem];
    
    //更新图片
    NSURL *url = [[NSURL alloc] initWithString:BASE_UPLOAD([GoUtilMethod getImagePath])];
    NSLog(@"image >> %@",BASE_UPLOAD([GoUtilMethod getImagePath]));
    [headImage setImageURL:url];
    
    titleLabel.text = [GoUtilMethod getNickName];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:NO];
    CGRect frame = self.view.frame;
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        frame.origin.y = 20;
        frame.size.height = self.view.frame.size.height - 20;
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        
    } else {
        
        frame.origin.x = 0;
        
    }
    
    self.view.frame = frame;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma -mark button action
- (void)wishProductBtnAction
{
    WishProductViewController *view = [[WishProductViewController alloc] init];
    [self.navigationController pushViewController:view animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil]; 
}

- (void)iLikedBtnAction
{
    ILikedViewController *view = [[ILikedViewController alloc] init];
    [self.navigationController pushViewController:view animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
   
}

- (void)wishShopBtnAction
{
    WishShopViewController *view = [[WishShopViewController alloc] init];
    [self.navigationController pushViewController:view animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)leaveMessageAction
{
    LeaveMessageViewController *view = [[LeaveMessageViewController alloc] init];
    [self.navigationController pushViewController:view animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)editAction
{
    UserInforViewController *view = [[UserInforViewController alloc] init];
    [self.navigationController pushViewController:view animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)exitAction
{
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma -mark custom method
- (void) setButtonTextImageCenterWithButton:(UIButton *)btn
{
    // the space between the image and text
    CGFloat spacing = 6.0;
    
    // get the size of the elements here for readability
    CGSize imageSize = btn.imageView.frame.size;
    CGSize titleSize = btn.titleLabel.frame.size;
    
    // lower the text and push it left to center it
    btn.titleEdgeInsets = UIEdgeInsetsMake( 0.0, - imageSize.width, - (imageSize.height + spacing), 0.0);
    
    // the text width might have changed (in case it was shortened before due to
    // lack of space and isn't anymore now), so we get the frame size again
    titleSize = btn.titleLabel.frame.size;
    
    // raise the image and push it right to center it
    btn.imageEdgeInsets = UIEdgeInsetsMake( - (titleSize.height + spacing), 0.0, 0.0, - titleSize.width);
}

#pragma -mark add subview
- (void)mainView
{
    //头像部分
    UIView *headBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 134)];
    headBg.backgroundColor = GO_BLUE;
        
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 7, 320, 30)];
    titleLabel.text = [GoUtilMethod getNickName];
    titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    UIImageView *headCircle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"usersenter_alpha_bg"]];
    headCircle.frame = CGRectMake(122, 51, 76, 76);
    
    headImage = [[EGOImageView alloc] initWithFrame:CGRectMake(122, 51, 76, 76)];
    headImage.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"myinfo_icon"]];
    
    UIButton *edit = [[UIButton alloc] initWithFrame:CGRectMake(92, 74, 30, 30)];
    UILabel *btnLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    btnLabel.numberOfLines = 2;
    btnLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    btnLabel.textColor = [UIColor whiteColor];
    btnLabel.text = @"编辑账户";
    btnLabel.textAlignment = NSTextAlignmentCenter;
    btnLabel.backgroundColor = [UIColor clearColor];
    [edit addTarget:self action:@selector(editAction) forControlEvents:UIControlEventTouchUpInside];
    [edit addSubview:btnLabel];
    
    UIButton *exit = [[UIButton alloc] initWithFrame:CGRectMake(198, 74, 30, 30)];
    UILabel *btnExitLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    btnExitLabel.numberOfLines = 2;
    btnExitLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    btnExitLabel.textColor = [UIColor whiteColor];
    btnExitLabel.text = @"切换账户";
    btnExitLabel.textAlignment = NSTextAlignmentCenter;
    btnExitLabel.backgroundColor = [UIColor clearColor];
    [exit addTarget:self action:@selector(exitAction) forControlEvents:UIControlEventTouchUpInside];
    [exit addSubview:btnExitLabel];
    
    [headBg addSubview:titleLabel];
    [headBg addSubview:headImage];
    [headBg addSubview:headCircle];
    [headBg addSubview:edit];
    [headBg addSubview:exit];
    
    UIView *ucView = [[UIView alloc] initWithFrame:CGRectMake(0, 134, 320, 195)];
    ucView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"uc_bg"]];
    
    //主按钮
    wishProductBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 160, 97.5)];
    wishProductBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    [wishProductBtn setImage:[UIImage imageNamed:@"usercenter_collect_baby"] forState:UIControlStateNormal];
    [wishProductBtn setImage:[UIImage imageNamed:@"usercenter_collect_baby_select"] forState:UIControlStateHighlighted];
    [wishProductBtn setImage:[UIImage imageNamed:@"usercenter_collect_baby_select"] forState:UIControlStateSelected];
    [wishProductBtn setTitleColor:GO_GRAY forState:UIControlStateNormal];
    [wishProductBtn setTitleColor:GO_ORANGE forState:UIControlStateHighlighted];
    [wishProductBtn setTitleColor:GO_ORANGE forState:UIControlStateSelected];
    [wishProductBtn setTitle:@"收藏宝贝" forState:UIControlStateNormal];
    [wishProductBtn addTarget:self action:@selector(wishProductBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self setButtonTextImageCenterWithButton:wishProductBtn];
    
    iLikedBtn = [[UIButton alloc] initWithFrame:CGRectMake(160, 0, 160, 97.5)];
    iLikedBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    [iLikedBtn setImage:[UIImage imageNamed:@"usercenter_my_attention"] forState:UIControlStateNormal];
    [iLikedBtn setImage:[UIImage imageNamed:@"usercenter_my_attention_selecter"] forState:UIControlStateHighlighted];
    [iLikedBtn setImage:[UIImage imageNamed:@"usercenter_my_attention_selecter"] forState:UIControlStateSelected];
    [iLikedBtn setTitleColor:GO_GRAY forState:UIControlStateNormal];
    [iLikedBtn setTitleColor:GO_ORANGE forState:UIControlStateHighlighted];
    [iLikedBtn setTitleColor:GO_ORANGE forState:UIControlStateSelected];
    [iLikedBtn setTitle:@"我关注的" forState:UIControlStateNormal];
    [iLikedBtn addTarget:self action:@selector(iLikedBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self setButtonTextImageCenterWithButton:iLikedBtn];;
    
    wishShopBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 97.5, 160, 97.5)];
    wishShopBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    [wishShopBtn setImage:[UIImage imageNamed:@"usercenter_collect_merchant"] forState:UIControlStateNormal];
    [wishShopBtn setImage:[UIImage imageNamed:@"usercenter_collect_merchant_select"] forState:UIControlStateHighlighted];
    [wishShopBtn setImage:[UIImage imageNamed:@"usercenter_collect_merchant_select"] forState:UIControlStateSelected];
    [wishShopBtn setTitleColor:GO_GRAY forState:UIControlStateNormal];
    [wishShopBtn setTitleColor:GO_ORANGE forState:UIControlStateHighlighted];
    [wishShopBtn setTitleColor:GO_ORANGE forState:UIControlStateSelected];
    [wishShopBtn setTitle:@"收藏商铺" forState:UIControlStateNormal];
    [wishShopBtn addTarget:self action:@selector(wishShopBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self setButtonTextImageCenterWithButton:wishShopBtn];
    
    leaveMessage = [[UIButton alloc] initWithFrame:CGRectMake(160, 97.5, 160, 97.5)];
    leaveMessage.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    [leaveMessage setImage:[UIImage imageNamed:@"usercenter_exit_app"] forState:UIControlStateNormal];
    [leaveMessage setImage:[UIImage imageNamed:@"usercenter_exit_app_select"] forState:UIControlStateHighlighted];
    [leaveMessage setImage:[UIImage imageNamed:@"usercenter_exit_app_select"] forState:UIControlStateSelected];
    [leaveMessage setTitleColor:GO_GRAY forState:UIControlStateNormal];
    [leaveMessage setTitleColor:GO_ORANGE forState:UIControlStateHighlighted];
    [leaveMessage setTitleColor:GO_ORANGE forState:UIControlStateSelected];
    [leaveMessage setTitle:@"留言给我们" forState:UIControlStateNormal];
    [leaveMessage addTarget:self action:@selector(leaveMessageAction) forControlEvents:UIControlEventTouchUpInside];
    [self setButtonTextImageCenterWithButton:leaveMessage];
    
    [self.view addSubview:headBg];
    [ucView addSubview:wishProductBtn];
    [ucView addSubview:iLikedBtn];
    [ucView addSubview:wishShopBtn];
    [ucView addSubview:leaveMessage];
    [self.view addSubview:ucView];
}

- (void)createNavigationItem
{
    self.tabBarController.navigationController.navigationBarHidden = YES;
}

@end
