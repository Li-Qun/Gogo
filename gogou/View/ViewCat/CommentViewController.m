//
//  CommentViewController.m
//  goshopping
//
//  Created by ss4346 on 13-12-6.
//  Copyright (c) 2013年 huiztech. All rights reserved.
//

#import "CommentViewController.h"
#import "TPKeyboardAvoidingScrollView.h"

@interface CommentViewController ()

@end

@implementation CommentViewController

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
    [self createNavitationItem];
}

- (void)viewDidAppear:(BOOL)animated
{
//    backBtn = nil;
//    confirmBtn = nil;
//    message = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma -mark
#pragma custom method
- (void)backToPreviousView
{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil]; 
}

- (void)cofirm
{
    //判断当前是否有网络
    if ([GoUtilMethod existNetWork] == 0) {
        return;
    };
    
    [SVProgressHUD show];
    NSURL *url = [[NSURL alloc] initWithString:REVIEW_ADD];
    
    __weak  ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request setPostValue:[GoUtilMethod getTelephone]       forKey:TELEPHONE ];
    [request setPostValue:[GoUtilMethod getPassword]        forKey:PASSWORD ];
    [request setPostValue:[GoUtilMethod getUserType]        forKey:ACCOUNT_TYPE];
    [request setPostValue:self.productId                    forKey:PRODUCT_ID ];
    [request setPostValue:message.text                      forKey:TEXT ];
    
    [request setCompletionBlock:^{
        
        [SVProgressHUD dismiss];
        NSString *jsonString = [request responseString];
        SBJsonParser *parser =[[SBJsonParser alloc] init];
        NSDictionary *dictionary = [parser objectWithString:jsonString];
        
        int state = [[dictionary objectForKey:@"state"] intValue];
        NSString *text = [dictionary objectForKey:@"message"];
        
        if (state ==1) {
            [SVProgressHUD showSuccessWithStatus:text duration:3];
        }else{
            [SVProgressHUD showErrorWithStatus:text duration:3];
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

#pragma -mark
#pragma main view
- (void)createMainView
{
    self.view = [[TPKeyboardAvoidingScrollView alloc] init];
    self.view.backgroundColor = GO_BACKGROUND;
    //取消按钮
    backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0 , 0, 160, 41)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"btn_cancel"] forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backToPreviousView) forControlEvents:UIControlEventTouchUpInside];
    
    confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(160, 0, 160, 41)];
    [confirmBtn setBackgroundImage:[UIImage imageNamed:@"btn_send"] forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(cofirm) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *messageBg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 41, 300, 119)];
    messageBg.image = [UIImage imageNamed:@"leavenote_bg"];
    
    message = [[UITextView alloc] initWithFrame:CGRectMake(20, 10, 270, 100)];
    message.backgroundColor = [UIColor clearColor];
    [messageBg addSubview:message];
    messageBg.userInteractionEnabled = YES;
    
    [self.view addSubview:backBtn];
    [self.view addSubview:confirmBtn];
    [self.view addSubview:messageBg];
}

- (void)createNavitationItem
{
    self.navigationController.navigationBarHidden = YES;
}

@end
