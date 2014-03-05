//
//  CommondListViewController.m
//  gogou
//
//  Created by ss4346 on 13-12-16.
//  Copyright (c) 2013年 huiztech. All rights reserved.
//

#import "CommondListViewController.h"
#import "CommentViewController.h"

#define TABLETAG 10000

@interface CommondListViewController ()

@end

@implementation CommondListViewController

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
    //初始化数据
    commendArray = [[NSMutableArray alloc] init];
    [self getCommendListWithPage:@"1"];
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
#pragma custom method
- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addCommend
{
    CommentViewController *view = [[CommentViewController alloc] init];
    view.productId = @"5";
    [self.navigationController pushViewController:view animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)getCommendListWithPage:(NSString *)page
{
    //判断当前是否有网络
    if ([GoUtilMethod existNetWork] == 0) {
        return;
    };
    
    [SVProgressHUD show];
    NSURL *url = [[NSURL alloc] initWithString:REVIEW_RETRIEVE_LIST];
    
    __weak  ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    
    [request setPostValue:self.productID      forKey:PRODUCT_ID ];
    [request setPostValue:page                forKey:PAGE];
    [request setCompletionBlock:^{
        
        [SVProgressHUD dismiss];
        NSString *jsonString = [request responseString];
        SBJsonParser *parser =[[SBJsonParser alloc] init];
        NSDictionary *dictionary = [parser objectWithString:jsonString];
        NSArray *res = [dictionary objectForKey:@"res"];
        totalPage = [[dictionary objectForKey:@"total_page"] intValue];
        for (int i=0; i < res.count; i++) {
            [commendArray addObject:res[i]];
        }
        [mainView reloadData];
        [mainView tableViewDidFinishedLoading];
        NSLog(@" >>>  %@",jsonString);
        
    }];
    [request setFailedBlock:^{
        [SVProgressHUD dismiss];
        [mainView tableViewDidFinishedLoading];
    }];
    
    [request startAsynchronous];
}

#pragma -mark
#pragma uitextfield delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    //开始编辑时触发，文本字段将成为first responder
    [textField resignFirstResponder];
    [self addCommend];
}

#pragma mark - PullingRefreshTableViewDelegate
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    NSLog(@"did start refreshing");

    [commendArray removeAllObjects];
    [tableView reloadData];
    NSLog(@"top list >>>>   %@",commendArray);
    currentPage = 1;
    [self getCommendListWithPage:@"1"];
}


- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    NSLog(@"did start loading");
    currentPage++;
    if (currentPage <= totalPage) {
        [self getCommendListWithPage:[NSString stringWithFormat:@"%d",currentPage]];
    }else if(currentPage > totalPage){
        [tableView tableViewDidFinishedLoadingWithMessage:@"没有了哦，亲"];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    PullingRefreshTableView *tableview = (PullingRefreshTableView *)[self.view viewWithTag:TABLETAG];
    [tableview tableViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    PullingRefreshTableView *tableview = (PullingRefreshTableView *)[self.view viewWithTag:TABLETAG];
    [tableview tableViewDidEndDragging:scrollView];
}

#pragma -mark tableview datasource delgate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return commendArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"commendCell";
    
    CommondCell *cell = (CommondCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CommendCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSDictionary *dictionary = [commendArray objectAtIndex:indexPath.row];
    NSString *imageUrl = [dictionary objectForKey:@"author_image"];
    if (![imageUrl isEqualToString:@""]) {
        NSURL *url = [NSURL URLWithString:BASE_UPLOAD(imageUrl)];
        [cell.headImage setImageURL:url];
    }else{
        [cell.headImage setImage:[UIImage imageNamed:@"myinfo_icon"]];
    }
    
    cell.titleLabel.text = [dictionary objectForKey:@"author"];
    cell.commendLabel.text = [dictionary objectForKey:@"text"];
    cell.shopLabel.text = @"";
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return indexPath;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 81;
}

#pragma -mark main view
- (void)addSubView
{
    mainView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, 320, VIEW_HEIGHT -40)];
    mainView.backgroundColor = [UIColor clearColor];
    mainView.dataSource = self;
    mainView.delegate   = self;
    mainView.pullingDelegate =self;
    mainView.tag = TABLETAG;
    
    UIView *commendView = [[UIView alloc] initWithFrame:CGRectMake(0, VIEW_HEIGHT -30, 320, 40)];
    commendView.backgroundColor =GO_GRAY;
    
    UITextField *commendTextField = [[UITextField alloc] initWithFrame:CGRectMake(40,  0, 280, 30)];
    commendTextField.placeholder = @"发表评论";
    commendTextField.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    [commendTextField setDelegate:self];
    [commendTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    
    UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(7.5, 7.5, 15, 15)];
    leftView.image = [UIImage imageNamed:@"icon_note"];
    
    [commendView addSubview:commendTextField];
    [commendView addSubview:leftView];
    
    [self.view addSubview:mainView];
    [self.view addSubview:commendView];
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
