//
//  RecommendViewController.m
//  goshopping
//
//  Created by ss4346 on 13-11-13.
//  Copyright (c) 2013年 huiztech. All rights reserved.
//

#import "RecommendViewController.h"
#import "ProductListViewController.h"
#import "RecommendCell.h"

@interface RecommendViewController ()

@end

@implementation RecommendViewController

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
    
    totalArray  = [[NSMutableArray alloc] init];
    
    self.jsonString = @"[{\"promotion_id\":\"123\",\"image\":data/demo/apple_logo.jpg,\"name\":\"jack\"},{\"promotion_id\":\"789\",\"id\":1002,\"name\":\"rose\"},{\"promotion_id\":\"456\",\"id\":1003,\"name\":\"mick\"}]";
    
    [self createMainView];
    [self getData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setTabBarNavigationBarTitleWithImage:[UIImage imageNamed:@"title_bg_logo"]];
    [self hideLeftBtn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark
#pragma custom method
- (void)getData
{
    //判断当前是否有网络
    if ([GoUtilMethod existNetWork] == 0) {
        return;
    };
    
    [totalArray removeAllObjects];
    
    [SVProgressHUD show];
    NSURL *url = [[NSURL alloc] initWithString:PROMOTION_RETRIEVE_LIST];
    
    __weak  ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    
    [request setCompletionBlock:^{
        [SVProgressHUD dismiss];
        NSString *jsonString = [request responseString];
        NSLog(@"json string >> %@",jsonString);
        SBJsonParser *parser =[[SBJsonParser alloc] init];
        NSMutableArray *array = [parser objectWithString:jsonString];
        
        [totalArray removeAllObjects];
        for (int i = 0; i < array.count; i ++) {
            [totalArray addObject:[array objectAtIndex:i]];
        }
    
        if (totalArray.count == 0) {
            [SVProgressHUD showErrorWithStatus:@"没有结果"];
        }else{
            [mainTable reloadData];
        }
        
    }];
    [request setFailedBlock:^{
        [SVProgressHUD dismiss];
        NSString *responseString = [request responseString];
        NSLog(@">>>>>>%@",responseString);
    }];
    
    [request startAsynchronous];
}


#pragma -mark tableview delegate datasoucre
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return totalArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //moreDSCell

    RecommendCell *cell = (RecommendCell *)[tableView dequeueReusableCellWithIdentifier:@"recommendCell"];
	
	if (cell == nil) {
		cell = [[RecommendCell alloc] init];
	}
    
    NSDictionary *dictionary = [totalArray objectAtIndex:indexPath.section];
    
    NSURL *url = [[NSURL alloc] initWithString:[dictionary objectForKey:@"image"]];
    [cell.imageView setImageURL:url];
    
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //跳转界面
    ReListViewController *view = [[ReListViewController alloc] init];
    [self.navigationController pushViewController:view animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];

    return indexPath;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 145;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
    
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 82, 22)];
    
    switch (section%3) {
        case 0:
            label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"recommend_book1.png"]];
            break;
        case 1:
            label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"recommend_book2.png"]];
            break;
        case 2:
            label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"recommend_book3.png"]];
            break;
        default:
            
            break;
    }
    
    NSDictionary *dictionary = [totalArray objectAtIndex:section];
    
    [label setFont:[UIFont boldSystemFontOfSize:9]];
    [label setTextColor:[UIColor whiteColor]];
    label.textAlignment = NSTextAlignmentCenter;
    NSString *string =[dictionary objectForKey:@"name"];
    
    /* Section header is in 0th index... */
    [label setText:string];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor clearColor]];
    return view;
}

#pragma -mark
#pragma main view
- (void)createMainView
{
    mainTable = [[UITableView alloc] initWithFrame:CGRectMake(15, 0, 305, VIEW_HEIGHT)];
    mainTable.backgroundColor = [UIColor clearColor] ;
    mainTable.dataSource = self;
    mainTable.delegate = self;
    [mainTable setSeparatorColor:[UIColor clearColor]];
    
    UIView *verticalView = [[UIView alloc] initWithFrame:CGRectMake(18, 0, 2, VIEW_HEIGHT)];
    verticalView.backgroundColor = GO_ORANGE;
    
    [self.view addSubview:verticalView];
    [self.view addSubview:mainTable];
    
}

@end
