//
//  UserInforViewController.m
//  goshopping
//
//  Created by ss4346 on 13-11-18.
//  Copyright (c) 2013年 huiztech. All rights reserved.
//

#import "UserInforViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "GoColorValue.h"

#import "SBJsonParser.h"

@interface UserInforViewController ()

@end

@implementation UserInforViewController

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
    [self createNavigationItem];
	[self mainView];
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


- (void)ScanAction
{
    
}

- (void)changeInfor
{
    //判断当前是否有网络
    if ([GoUtilMethod existNetWork] == 0) {
        return;
    };
    
    if ((![newPassword.text isEqualToString:reNewPassword.text]) &&(newPassword.text != nil )) {
        [SVProgressHUD showErrorWithStatus:@"两次如输入的密码不一致" duration:3];
        return;
    }
    
    if (nickName.text == nil || [nickName.text isKindOfClass:[NSNull class]]) {
        [SVProgressHUD showErrorWithStatus:@"请输入昵称" duration:3];
    }

    NSURL *url = [[NSURL alloc] initWithString:EDIT_USER];
    __weak  ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request setPostValue:[GoUtilMethod getTelephone]      forKey:TELEPHONE ];
    [request setPostValue:[GoUtilMethod getPassword]       forKey:PASSWORD];
    [request setPostValue:[GoUtilMethod getUserType]       forKey:ACCOUNT_TYPE];
    [request setPostValue:password.text                    forKey:OLD_PASSWORD ];
    [request setPostValue:newPassword.text                 forKey:NES_PASSWORD];
    [request setPostValue:nickName.text                    forKey:NICKNAME];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:tempImagePath]) {
        NSLog(@"FILE PATH IS %@",tempImagePath);
        [request setFile:tempImagePath                     forKey:FILE];
    }
    
    
    [request setCompletionBlock:^{
        SBJsonParser *parser =[[SBJsonParser alloc] init];
        NSDictionary *dictionary = [parser objectWithString:[request responseString]];
        int state = [[dictionary objectForKey:@"state"]intValue];
        NSString *message = [dictionary objectForKey:@"message"];
        NSDictionary *customerData = [dictionary objectForKey:@"customer_data"];
        
        if (state == 1){
            //保存用户信息
            [SVProgressHUD showSuccessWithStatus:message duration:3];
            [GoUtilMethod setImage:[customerData objectForKey:@"image"]];
            [GoUtilMethod setNickName:nickName.text];
            
            if (newPassword.text != nil || [newPassword.text isKindOfClass:[NSNull class]]) {
                [GoUtilMethod setPassword:newPassword.text];
            }
            
            NSLog(@"image>>>> %@",[GoUtilMethod getImagePath]);
            
        }else{
            [SVProgressHUD showErrorWithStatus:message duration:3];
        }
        
        NSLog(@">>>>> %@",[GoUtilMethod getNickName]);
        
        NSString *responseString = [request responseString];
        NSLog(@">>>>>>%@",responseString);
        
    }];
    [request setFailedBlock:^{
        NSString *responseString = [request responseString];
        NSLog(@">>>>>>%@",responseString);
    }];
    
    [request startAsynchronous];
}

-(IBAction)getAPhoto:(id)sender
{
    //初始化数据
    tempImagePath = [ NSTemporaryDirectory() stringByAppendingPathComponent:@"temp_image.png"];
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}


#pragma -mark UIImagePickerController delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    chosenImage = info[UIImagePickerControllerEditedImage];
    //删除缓存文件
    if ([[NSFileManager defaultManager] fileExistsAtPath:tempImagePath]) {
        NSLog(@"the image is exist");
        NSFileManager *defaultManager;
        
        defaultManager = [NSFileManager defaultManager];
        NSError *error = [[NSError alloc] init];
        [defaultManager removeItemAtPath:tempImagePath error:&error];
        
    }
    
    [UIImagePNGRepresentation(chosenImage) writeToFile:[ NSTemporaryDirectory() stringByAppendingPathComponent:@"temp_image.png"] atomically:YES];
    
    [headImage setImage:chosenImage];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


#pragma -mark add subview

- (void)createNavigationItem
{
    self.navigationController.navigationBarHidden = NO;
    
    //左键
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 20, 20);
    [leftButton addTarget:self action:@selector(backToPreviousView) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"back_top"] forState:UIControlStateNormal];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] init];
    [leftItem setCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    //右键
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 20, 20);
    [rightButton addTarget:self action:@selector(changeInfor) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"confirm"] forState:UIControlStateNormal];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] init];
    [rightItem setCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self setNavigationBarTitleWithImage:[UIImage imageNamed:@"title_bg_logo"]];
}

/**
 * 主界面
 */
- (void)mainView
{
    self.view = [[TPKeyboardAvoidingScrollView alloc] init];
    self.view.backgroundColor = GO_BACKGROUND;
    
    //设置
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 30)];
    titleLabel.textColor = GO_ORANGE;
    titleLabel.text = @"设置(微博登陆不能修改密码)";
    titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    titleLabel.backgroundColor = [UIColor clearColor];
    
    //昵称
    UIView *nickNameView = [[UIView alloc] initWithFrame:CGRectMake(6, 30, 308, 31)];
    nickNameView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"table_top"]];
    
    UILabel *nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 1.5f, 40, 28)];
    nickNameLabel.textAlignment = NSTextAlignmentLeft;
    nickNameLabel.textColor = GO_ORANGE;
    nickNameLabel.backgroundColor = [UIColor clearColor];
    nickNameLabel.text = @"昵称";
    nickNameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    [nickNameView addSubview:nickNameLabel];
    
    nickName = [[UITextField alloc] initWithFrame:CGRectMake(60, 1.5f, 240, 28)];
    nickName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    nickName.textColor = GO_ORANGE;
    nickName.backgroundColor = [UIColor clearColor];
    nickName.text = [GoUtilMethod getNickName];
    nickName.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    [nickNameView addSubview:nickName];
    
    //密码
    UIView *passwordView = [[UIView alloc] initWithFrame:CGRectMake(6, 61, 308, 28)];
    passwordView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"table_middle"]];
    
    UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 40, 28)];
    passwordLabel.textAlignment = NSTextAlignmentLeft;
    passwordLabel.textColor = GO_ORANGE;
    passwordLabel.backgroundColor = [UIColor clearColor];
    passwordLabel.text = @"密码";
    passwordLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    [passwordView addSubview:passwordLabel];
    
    password = [[UITextField alloc] initWithFrame:CGRectMake(60, 0, 240, 28)];
    password.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    password.textColor = GO_ORANGE;
    password.backgroundColor = [UIColor clearColor];
    password.placeholder = @"不填则不修改";
    password.font = [UIFont fontWithName:@"Helvetica-Bold" size:11];
    password.secureTextEntry = YES;
    [passwordView addSubview:password];
    
    //新密码
    UIView *newPasswordView = [[UIView alloc] initWithFrame:CGRectMake(6, 89, 308, 28)];
    newPasswordView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"table_middle"]];
    
    UILabel *newPasswordLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 40, 28)];
    newPasswordLabel.textAlignment = NSTextAlignmentLeft;
    newPasswordLabel.textColor = GO_ORANGE;
    newPasswordLabel.backgroundColor = [UIColor clearColor];
    newPasswordLabel.text = @"新密码";
    newPasswordLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:11];
    [newPasswordView addSubview:newPasswordLabel];
    
    newPassword = [[UITextField alloc] initWithFrame:CGRectMake(60, 0, 240, 28)];
    newPassword.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    newPassword.textColor = GO_ORANGE;
    newPassword.backgroundColor = [UIColor clearColor];
    newPassword.placeholder = @"不填则不修改";
    newPassword.font = [UIFont fontWithName:@"Helvetica-Bold" size:11];
    newPassword.secureTextEntry = YES;
    [newPasswordView addSubview:newPassword];
    
    //确认密码
    UIView *reNewPasswordView = [[UIView alloc] initWithFrame:CGRectMake(6, 117, 308, 28)];
    reNewPasswordView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"table_middle"]];
    
    UILabel *reNewPasswordLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 40, 28)];
    reNewPasswordLabel.textAlignment = NSTextAlignmentLeft;
    reNewPasswordLabel.textColor = GO_ORANGE;
    reNewPasswordLabel.backgroundColor = [UIColor clearColor];
    reNewPasswordLabel.text = @"确认密码";
    reNewPasswordLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:9];
    [reNewPasswordView addSubview:reNewPasswordLabel];
    
    reNewPassword = [[UITextField alloc] initWithFrame:CGRectMake(60, 0, 240, 28)];
    reNewPassword.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    reNewPassword.textColor = GO_ORANGE;
    reNewPassword.backgroundColor = [UIColor clearColor];
    reNewPassword.placeholder = @"不填则不修改";
    reNewPassword.font = [UIFont fontWithName:@"Helvetica-Bold" size:11];
    reNewPassword.secureTextEntry = YES;
    [reNewPasswordView addSubview:reNewPassword];
    
    //头像
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(6, 145, 308, 31)];
    headView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"table_bottom"]];
    
    UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 1.5f, 40, 28)];
    headLabel.textAlignment = NSTextAlignmentLeft;
    headLabel.textColor = GO_ORANGE;
    headLabel.backgroundColor = [UIColor clearColor];
    headLabel.text = @"头像";
    headLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    [headView addSubview:headLabel];
    
    UIButton *setHead = [[UIButton alloc] initWithFrame:CGRectMake(60, 0, 60, 31)];
    [setHead setTitle:@"设置头像" forState:UIControlStateNormal];
    [setHead setTitleColor:GO_ORANGE forState:UIControlStateNormal];
    setHead.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    [setHead addTarget:self action:@selector(getAPhoto:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:setHead];
    
    headImage = [[UIImageView alloc] initWithFrame:CGRectMake(120, 3, 20, 20)];
    [headView addSubview:headImage];
    
    //扫一扫
    UIButton *scanView = [[UIButton alloc] initWithFrame:CGRectMake(6, 196, 308, 32)];
    [scanView setBackgroundImage:[UIImage imageNamed:@"table_row"] forState:UIControlStateNormal];
    [scanView addTarget:self action:@selector(ScanAction) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *scanLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, 40, 28)];
    scanLabel.textAlignment = NSTextAlignmentLeft;
    scanLabel.textColor = GO_ORANGE;
    scanLabel.backgroundColor = [UIColor clearColor];
    scanLabel.text = @"扫一扫";
    scanLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    [scanView addSubview:scanLabel];
    
    
    [self.view addSubview:titleLabel];
    [self.view addSubview:nickNameView];
    [self.view addSubview:passwordView];
    [self.view addSubview:newPasswordView];
    [self.view addSubview:reNewPasswordView];
    [self.view addSubview:headView];
    [self.view addSubview:scanView];
    
}

@end
