//
//  LeaveMessageViewController.m
//  goshopping
//
//  Created by ss4346 on 13-11-15.
//  Copyright (c) 2013年 huiztech. All rights reserved.
//

#import "LeaveMessageViewController.h"
#import "TPKeyboardAvoidingScrollView.h"

@interface LeaveMessageViewController ()

@end

@implementation LeaveMessageViewController

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
	[self addSubView];
}

- (void)viewWillAppear:(BOOL)animated
{
//    [self createNavigationItem];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark button action

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
    
//    if (name.text == nil || [name.text isKindOfClass:[NSNull class]]) {
//        [SVProgressHUD showErrorWithStatus:@"姓名不能为空" duration:3];
//        return;
//    }
//    
//    if (phone.text == nil || [phone.text isKindOfClass:[NSNull class]]) {
//        [SVProgressHUD showErrorWithStatus:@"电话不能为空" duration:3];
//        return;
//    }
//    
//    if (qq.text == nil || [qq.text isKindOfClass:[NSNull class]]) {
//        [SVProgressHUD showErrorWithStatus:@"电话不能为空" duration:3];
//        return;
//    }
//    
//    if (address.text == nil || [address.text isKindOfClass:[NSNull class]]) {
//        [SVProgressHUD showErrorWithStatus:@"姓名不能为空" duration:3];
//        return;
//    }

    if ([message.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"信息不能为空" duration:3];
        return;
    }
    
    NSURL *url = [[NSURL alloc] initWithString:LEAVE_NOTE];
    __weak  ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request setPostValue:phone.text                       forKey:TELEPHONE];
    [request setPostValue:name.text                        forKey:NAME];
    [request setPostValue:qq.text                          forKey:QQ];
    [request setPostValue:address.text                     forKey:ADDRESS];
    [request setPostValue:message.text                     forKey:MESSAGE];
    [request setPostValue:@""                              forKey:EMAIL];
       
    [request setCompletionBlock:^{
        SBJsonParser *parser =[[SBJsonParser alloc] init];
        NSDictionary *dictionary = [parser objectWithString:[request responseString]];
        int state = [[dictionary objectForKey:@"state"]intValue];
        NSString *str = [dictionary objectForKey:@"message"];
        
        if (state == 1){
            //保存用户信息
            [SVProgressHUD showSuccessWithStatus:str duration:3];
            [self backToPreviousView];
            
        }else{
            [SVProgressHUD showErrorWithStatus:str duration:3];
        }
        
    }];
    [request setFailedBlock:^{
        NSString *responseString = [request responseString];
        NSLog(@">>>>>>%@",responseString);
    }];
    
    [request startAsynchronous];
}

#pragma -mark main view

- (void)addSubView
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
    
    name = [[UITextField alloc] initWithFrame:CGRectMake(10,50, 300, 40)];
    name.placeholder = @"请输入你的姓名";
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    nameLabel.text = @"  姓名:";
    nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.backgroundColor = [UIColor clearColor];
    name.leftView = nameLabel;
    name.leftViewMode = UITextFieldViewModeAlways;
    name.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    name.background = [UIImage imageNamed:@"input_edit_layout_bg"];
    
    phone = [[UITextField alloc] initWithFrame:CGRectMake(10,100, 300, 40)];
    phone.placeholder = @"请输入你常用的手机号码";
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    phoneLabel.text = @"  手机:";
    phoneLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    phoneLabel.textColor = [UIColor blackColor];
    phoneLabel.backgroundColor = [UIColor clearColor];
    phone.leftView = phoneLabel;
    phone.leftViewMode = UITextFieldViewModeAlways;
    phone.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    phone.background = [UIImage imageNamed:@"input_edit_layout_bg"];
    
    qq = [[UITextField alloc] initWithFrame:CGRectMake(10,150, 300, 40)];
    qq.placeholder = @"请输入你常用的QQ号码";
    UILabel *qqLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    qqLabel.text = @"  QQ:";
    qqLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    qqLabel.textColor = [UIColor blackColor];
    qqLabel.backgroundColor = [UIColor clearColor];
    qq.leftView = qqLabel;
    qq.leftViewMode = UITextFieldViewModeAlways;
    qq.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    qq.background = [UIImage imageNamed:@"input_edit_layout_bg"];
    
    address = [[UITextField alloc] initWithFrame:CGRectMake(10,200, 300, 40)];
    address.placeholder = @"请输入你的地址";
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    addressLabel.text = @"  地址:";
    addressLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    addressLabel.textColor = [UIColor blackColor];
    addressLabel.backgroundColor = [UIColor clearColor];
    address.leftView = addressLabel;
    address.leftViewMode = UITextFieldViewModeAlways;
    address.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    address.background = [UIImage imageNamed:@"input_edit_layout_bg"];

    UIImageView *messageBg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 250, 300, 119)];
    messageBg.image = [UIImage imageNamed:@"leavenote_bg"];
    
    message = [[UITextView alloc] initWithFrame:CGRectMake(20, 10, 270, 100)];
    message.backgroundColor = [UIColor clearColor];
    [messageBg addSubview:message];
    messageBg.userInteractionEnabled = YES;
    
    [self.view addSubview:backBtn];
    [self.view addSubview:confirmBtn];
    [self.view addSubview:name];
    [self.view addSubview:phone];
    [self.view addSubview:qq];
    [self.view addSubview:address];
    [self.view addSubview:messageBg];
}

- (void)createNavigationItem
{
    self.navigationController.navigationBarHidden = NO;
}

@end
