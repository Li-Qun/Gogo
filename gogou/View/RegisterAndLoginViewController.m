//
//  RegisterAndLoginViewController.m
//  goshopping
//
//  Created by ss4346 on 13-11-11.
//  Copyright (c) 2013年 huiztech. All rights reserved.
//

#import "RegisterAndLoginViewController.h"

#import "HomeTabbarViewController.h"

#import "GoColorValue.h"
#import "SBJsonParser.h"
#import <Parse/Parse.h>
@interface RegisterAndLoginViewController ()

@end

@implementation RegisterAndLoginViewController

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
    
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        //        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }
    
	[self mainView];
    
//    [GoUtilMethod clearMessage];
    if([self isLogin]){
        [self login];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    [self setNavigationBarTitleWithImage:[UIImage imageNamed:@"title_bg_logo"]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    registerSelected = nil;
    loginSelected = nil;
    
    //login
    registerView =nil;
    lPhone = nil;
    lPassword = nil;
    login = nil;
    
    tecentBtn = nil;
    sinaBtn = nil;
    
    //register
    loginView = nil;
    rPhone = nil;
    rPassword = nil;
    registerBtn = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma -mark button action
- (void)loginAction
{
    
    //判断是否是手机号
    if (![GoUtilMethod isPhoneNum:lPhone.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号" duration:3];
        return;
    }
    
    //判断当前是否有网络
    if ([GoUtilMethod existNetWork] == 0) {
        return;
    };
    
    [SVProgressHUD show];
    NSURL *url = [[NSURL alloc] initWithString:LOGIN];
    __weak  ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request setPostValue:lPhone.text          forKey:TELEPHONE ];
    [request setPostValue:lPassword.text       forKey:PASSWORD];
    [request setPostValue:@"1"              forKey:ACCOUNT_TYPE];
    [request setPostValue:@"1"              forKey:FOR_LOGIN];
    
    [request setCompletionBlock:^{
        [SVProgressHUD dismiss];
        NSString *jsonString = [request responseString];
        SBJsonParser *parser =[[SBJsonParser alloc] init];
        NSDictionary *dictionary = [parser objectWithString:jsonString];
        NSDictionary *customerData = [dictionary objectForKey:@"customer_data"];
        int state = [[dictionary objectForKey:@"state"]intValue];
        NSString *message = [dictionary objectForKey:@"message"];
        if (state == 1){
            [SVProgressHUD showSuccessWithStatus:message duration:3];
            
            //保存用户信息
            
            [GoUtilMethod writePlist:[customerData objectForKey:@"telephone"] password:lPassword.text userType:@"1"image:[customerData objectForKey:@"image"] nickname:[customerData objectForKey:@"nickname"]];
            HomeTabbarViewController *view = [[HomeTabbarViewController alloc] init];
            [self.navigationController pushViewController:view animated:YES];
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            
            [SVProgressHUD showErrorWithStatus:message duration:3];
        }
        
        NSLog(@">>>>> %@",[GoUtilMethod getNickName]);
        
    }];
    [request setFailedBlock:^{
        [SVProgressHUD dismiss];
        NSString *responseString = [request responseString];
        NSLog(@">>>>>>%@",responseString);
    }];
    
    [request startAsynchronous];
}

- (void)registerAction
{
    //判断是否是手机号
    if (![GoUtilMethod isPhoneNum:rPhone.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号" duration:3];
        return;
    }
    
    //判断当前是否有网络
    if ([GoUtilMethod existNetWork] == 0) {
        return;
    };
    
    [SVProgressHUD show];
    NSURL *url = [[NSURL alloc] initWithString:REGISTER];
    __weak  ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request setPostValue:rPhone.text          forKey:TELEPHONE ];
    [request setPostValue:rPassword.text       forKey:PASSWORD];
    
    [request setCompletionBlock:^{
        [SVProgressHUD dismiss];
        NSString *jsonString = [request responseString];
        SBJsonParser *parser =[[SBJsonParser alloc] init];
        NSDictionary *dictionary = [parser objectWithString:jsonString];
        int state = [[dictionary objectForKey:@"state"]intValue];
        NSString *message = [dictionary objectForKey:@"message"];
        if (state == 1){
            [SVProgressHUD showSuccessWithStatus:message duration:3];
            [GoUtilMethod clearMessage];
            [GoUtilMethod setPassword:rPassword.text];
            [GoUtilMethod setTelephone:rPhone.text];
        }else{

            [SVProgressHUD showErrorWithStatus:message duration:3];
        }
 
        NSLog(@">>>>> %@",[GoUtilMethod getPassword]);
        
    }];
    [request setFailedBlock:^{
        [SVProgressHUD dismiss];
        NSString *responseString = [request responseString];
        NSLog(@">>>>>>%@",responseString);
    }];
    
    [request startAsynchronous];
}

- (void)loginSelectedAction
{
    loginSelected.selected = YES;
    registerSelected.selected = NO;
    [self createLoginView];
}

- (void)registerSelectedAction
{
    loginSelected.selected = NO;
    registerSelected.selected = YES;
    [self createRegisterView];
}

#pragma -mark
#pragma other method
- (BOOL)isLogin
{
    if([[GoUtilMethod getPassword] isEqualToString:@""] || [GoUtilMethod getPassword] == nil){
        return NO;
    }else{
        return YES;
    }
}

- (void)login
{
    //判断当前是否有网络
    if ([GoUtilMethod existNetWork] == 0) {
        return;
    };

    [SVProgressHUD show];
    NSURL *url = [[NSURL alloc] initWithString:LOGIN];
    __weak  ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request setPostValue:[GoUtilMethod getTelephone]      forKey:TELEPHONE ];
    [request setPostValue:[GoUtilMethod getPassword]       forKey:PASSWORD];
    [request setPostValue:[GoUtilMethod getUserType]       forKey:ACCOUNT_TYPE];
    [request setPostValue:@"1"                             forKey:FOR_LOGIN];
    
    NSLog(@"USER INFOR >>  %@   ==   %@",[GoUtilMethod getTelephone],[GoUtilMethod getPassword]);
    
    [request setCompletionBlock:^{
        [SVProgressHUD dismiss];
        SBJsonParser *parser =[[SBJsonParser alloc] init];
        NSDictionary *dictionary = [parser objectWithString:[request responseString]];
        int state = [[dictionary objectForKey:@"state"]intValue];
        NSString *message = [dictionary objectForKey:@"message"];
        NSDictionary *customerData = [dictionary objectForKey:@"customer_data"];
        
        if (state == 1){
            //保存用户信息
            [GoUtilMethod writePlist:[customerData objectForKey:@"telephone"] password:[GoUtilMethod getPassword] userType:@"1"image:[customerData objectForKey:@"image"] nickname:[customerData objectForKey:@"nickname"]];
            HomeTabbarViewController *view = [[HomeTabbarViewController alloc] init];
            [self.navigationController pushViewController:view animated:NO];
            [self dismissViewControllerAnimated:YES completion:nil]; 
        }else{
            [SVProgressHUD showErrorWithStatus:message duration:3];
        }
        
        NSLog(@">>>>> %@",[GoUtilMethod getNickName]);
        
    }];
    [request setFailedBlock:^{
        [SVProgressHUD dismiss];
        NSString *responseString = [request responseString];
        NSLog(@">>>>>>%@",responseString);
    }];
    
    [request startAsynchronous];
}

- (void)tecentBtnAction
{
    [ShareSDK getUserInfoWithType:ShareTypeQQSpace authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
        
        if (result)
        {
             PFQuery *query = [PFQuery queryWithClassName:@"UserInfo"];
            [query whereKey:@"uid" equalTo:[userInfo uid]];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                
                if ([objects count] == 0)
                {
                    PFObject *newUser = [PFObject objectWithClassName:@"UserInfo"];
                    [newUser setObject:[userInfo uid] forKey:@"uid"];
                    [newUser setObject:[userInfo nickname] forKey:@"name"];
                    //                [newUser setObject:[userInfo icon] forKey:@"icon"];
                    [newUser saveInBackground];
                    
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Hello" message:@"欢迎注册" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
                    [alertView show];
                }
                else
                {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Hello" message:@"欢迎回来" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
                    [alertView show];
                    
                }
            }];
            
            NSLog(@"成功");
    
            
        }
        
    }];
}

- (void)sinaBtnAction
{
    [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                               
    if (result)
    {
        PFQuery *query = [PFQuery queryWithClassName:@"UserInfo"];
        [query whereKey:@"uid" equalTo:[userInfo uid]];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                       
        if ([objects count] == 0)
        {
                PFObject *newUser = [PFObject objectWithClassName:@"UserInfo"];
                [newUser setObject:[userInfo uid] forKey:@"uid"];
                [newUser setObject:[userInfo nickname] forKey:@"name"];
//                [newUser setObject:[userInfo icon] forKey:@"icon"];
                [newUser saveInBackground];
                                           
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Hello" message:@"欢迎注册" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
                [alertView show];
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Hello" message:@"欢迎回来" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
                [alertView show];

            }
        }];
                                   
    NSLog(@"成功");
    }
                               
    }];
}

#pragma -mark add subview
- (void)mainView
{
    loginSelected = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 160, 45)];
    [loginSelected setBackgroundImage:[UIImage imageNamed:@"loginregister_title_bg_1"] forState:UIControlStateNormal];
    [loginSelected setBackgroundImage:[UIImage imageNamed:@"loginregister_title_bg_1"] forState:UIControlStateHighlighted];
    [loginSelected setBackgroundImage:[UIImage imageNamed:@"loginregister_title_bg_2"] forState:UIControlStateSelected];
    [loginSelected setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
    [loginSelected setTitle:@"登陆" forState:UIControlStateNormal];
    [loginSelected addTarget:self action:@selector(loginSelectedAction) forControlEvents:UIControlEventTouchUpInside];
    
    registerSelected = [[UIButton alloc] initWithFrame:CGRectMake(160, 0, 160, 45)];
    [registerSelected setBackgroundImage:[UIImage imageNamed:@"loginregister_title_bg_1"] forState:UIControlStateNormal];
    [registerSelected setBackgroundImage:[UIImage imageNamed:@"loginregister_title_bg_1"] forState:UIControlStateHighlighted];
    [registerSelected setBackgroundImage:[UIImage imageNamed:@"loginregister_title_bg_2"] forState:UIControlStateSelected];
    [registerSelected setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
    [registerSelected setTitle:@"注册" forState:UIControlStateNormal];
    [registerSelected addTarget:self action:@selector(registerSelectedAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:loginSelected];
    [self.view addSubview:registerSelected];
    
    [self loginSelectedAction];
}

- (void)createLoginView
{
    //清除注册界面内容
    [registerView removeFromSuperview];
    
    
    //创建登陆界面内容
    loginView = [[UIView alloc] initWithFrame:CGRectMake(0, 45, 320, VIEW_HEIGHT -45) ];
    
    lPhone = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 300, 40)];
    lPhone.placeholder = @"请输入你常用的手机号码";
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    nameLabel.text = @"  手机:";
    nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.backgroundColor = [UIColor clearColor];
    lPhone.leftView = nameLabel;
    lPhone.leftViewMode = UITextFieldViewModeAlways;
    lPhone.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    lPhone.background = [UIImage imageNamed:@"input_edit_layout_bg"];
    [loginView addSubview:lPhone];
    
    lPassword = [[UITextField alloc] initWithFrame:CGRectMake(10, 60, 300, 40)];
    lPassword.placeholder = @"输入密码";
    UILabel *passLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    passLabel.text = @"  密码:";
    passLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    passLabel.textColor = [UIColor blackColor];
    passLabel.backgroundColor = [UIColor clearColor];
    lPassword.leftView = passLabel;
    lPassword.leftViewMode = UITextFieldViewModeAlways;
    lPassword.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    lPassword.background = [UIImage imageNamed:@"input_edit_layout_bg"];
    [loginView addSubview:lPassword];
    lPassword.secureTextEntry = YES;
    
    login = [[UIButton alloc] initWithFrame:CGRectMake(10, 110, 300, 40)];
    [login setBackgroundImage:[UIImage imageNamed:@"loginregister_btn"] forState:UIControlStateNormal];
    [login addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [login setTitle:@"登陆" forState:UIControlStateNormal];
    [login addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [loginView addSubview:login];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 160, 239, 13)];
    imageView.image = [UIImage imageNamed:@"label_login"];
    [loginView addSubview:imageView];
    
    tecentBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 180, 40, 40)];
    [tecentBtn setBackgroundImage:[UIImage imageNamed:@"icon_qq"] forState:UIControlStateNormal];
    [tecentBtn addTarget:self action:@selector(tecentBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    sinaBtn = [[UIButton alloc] initWithFrame:CGRectMake(180, 180, 40, 40)];
    [sinaBtn setBackgroundImage:[UIImage imageNamed:@"icon_sinaweibo"] forState:UIControlStateNormal];
    [sinaBtn addTarget:self action:@selector(sinaBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    [loginView addSubview:tecentBtn];
    [loginView addSubview:sinaBtn];
    
    [self.view addSubview:loginView];
}


- (void)createRegisterView
{
    //清除登陆界面内容
    [loginView removeFromSuperview];
    
    //创建注册界面内容
    registerView = [[UIView alloc] initWithFrame:CGRectMake(0, 45, 320, VIEW_HEIGHT -45)];
    
    rPhone = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 300, 40)];
    rPhone.placeholder = @"请输入你常用的手机号码";
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    nameLabel.text = @"  手机:";
    nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.backgroundColor = [UIColor clearColor];
    rPhone.leftView = nameLabel;
    rPhone.leftViewMode = UITextFieldViewModeAlways;
    rPhone.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    rPhone.background = [UIImage imageNamed:@"input_edit_layout_bg"];
    [registerView addSubview:rPhone];
    
    rPassword = [[UITextField alloc] initWithFrame:CGRectMake(10, 60, 300, 40)];
    rPassword.placeholder = @"输入密码";
    UILabel *passLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    passLabel.text = @"  密码:";
    passLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    passLabel.textColor = [UIColor blackColor];
    passLabel.backgroundColor = [UIColor clearColor];
    rPassword.leftView = passLabel;
    rPassword.leftViewMode = UITextFieldViewModeAlways;
    rPassword.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    rPassword.background = [UIImage imageNamed:@"input_edit_layout_bg"];
    rPassword.secureTextEntry = YES;
    [registerView addSubview:rPassword];
    
    
    
    registerBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 110, 300, 40)];
    [registerBtn setBackgroundImage:[UIImage imageNamed:@"loginregister_btn"] forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    [registerView addSubview:registerBtn];
    
    [self.view addSubview:registerView];
}




@end
