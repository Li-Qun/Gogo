//
//  AOWaterView.h
//  AOWaterView
//
//  Created by akria.king on 13-4-10.
//  Copyright (c) 2013年 akria.king. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessTwoView.h"

@protocol AOTwoWaterViewDelegate <NSObject>

-(void)aowClick:(DataInfo *)data;

@end

@interface AOTwoWaterView : UIScrollView<imageDelegate>
{
    UIView *v1;// 第一列view
    UIView *v2;// 第二列view
    int higher;//最高列
    int lower;//最低列
    float highValue;//最高列高度

    int row ;//行数
    BOOL _reloading;
}
//数据
@property(nonatomic,strong)DataInfo *infor;
//代理
@property(nonatomic,strong)id<AOTwoWaterViewDelegate> adelegate;
//初始化view
-(id)initWithDataArray:(NSMutableArray *)array;
//刷新view
-(void)refreshView:(NSMutableArray *)array;
//获取下一页
-(void)getNextPage:(NSMutableArray *)array;

@end
