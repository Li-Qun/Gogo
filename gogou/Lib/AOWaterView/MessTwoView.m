//
//  MessView.m
//  AOWaterView
//
//  Created by akria.king on 13-4-10.
//  Copyright (c) 2013年 akria.king. All rights reserved.
//

#import "MessTwoView.h"
#import "UrlImageButton.h"
#define WIDTH 320/2

@implementation MessTwoView
@synthesize idelegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithData:(DataInfo *)data yPoint:(float) y{

    float imgW=data.width;//图片原宽度
    float imgH=data.height;//图片原高度
    float sImgW = WIDTH-6;//缩略图宽带
    float sImgH = sImgW*imgH/imgW;//缩略图高度
    
    CGSize newSize = [data.name sizeWithFont:[UIFont fontWithName:@"Helvetica" size:9] constrainedToSize:CGSizeMake(sImgW,400) lineBreakMode:NSLineBreakByWordWrapping];
    
    self = [super initWithFrame:CGRectMake(0, y, WIDTH, sImgH + newSize.height+20)];
    if (self) {
        
        UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(1, 2, WIDTH-2, sImgH + newSize.height+19)];
        baseView.layer.cornerRadius = 6.0;
        baseView.layer.borderWidth = 1.0;
        baseView.layer.borderColor = [[UIColor whiteColor] CGColor];
        baseView.layer.masksToBounds = YES;
        baseView.backgroundColor = [UIColor whiteColor];
        
        //图片部分
        UrlImageButton *imageBtn = [[UrlImageButton alloc]initWithFrame:CGRectMake(2,2, sImgW, sImgH)];//初始化url图片按钮控件
        
        [imageBtn setImageFromUrl:YES withUrl:BASE_IMAGE(data.image)];//设置图片地质
        [imageBtn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
        //主体文字
        UILabel *contentTextView = [[UILabel alloc] init];
        contentTextView.text = data.name;
        contentTextView.textColor = [UIColor grayColor];
        contentTextView.backgroundColor = [UIColor clearColor];
        contentTextView.numberOfLines = 0;
        contentTextView.font = [UIFont fontWithName:@"Helvetica" size:9];
        contentTextView.frame = CGRectMake(2, 4+sImgH, sImgW, newSize.height);
        //价格文字
        UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(5, sImgH +newSize.height, 50, 20)];
        price.text = data.price;
        price.backgroundColor = [UIColor clearColor];
        price.textColor = GO_ORANGE;
        price.font = [UIFont fontWithName:@"Helvetica" size:9];
        //评论图标
        UIImageView *imageComment = [[UIImageView alloc] initWithFrame:CGRectMake(80, sImgH +newSize.height +4, 15, 15)];
        imageComment.image = [UIImage imageNamed:@"commont_icon"];
        //评论数量
        UILabel *comment = [[UILabel alloc] initWithFrame:CGRectMake(95, sImgH +newSize.height, 30, 20)];
        comment.text = data.reviewCount;
        comment.backgroundColor = [UIColor clearColor];
        comment.textColor = [UIColor grayColor];
        comment.font = [UIFont fontWithName:@"Helvetica" size:8];
        //收藏图标
        UIImageView *imagefav = [[UIImageView alloc] initWithFrame:CGRectMake(120, sImgH +newSize.height +3, 15, 15)];
        imagefav.image = [UIImage imageNamed:@"collect_count_icon"];
        //收藏数量
        UILabel *fav = [[UILabel alloc] initWithFrame:CGRectMake(135, sImgH +newSize.height, 30, 20)];
        fav.text = data.favCount;
        fav.backgroundColor = [UIColor clearColor];
        fav.textColor = [UIColor grayColor];
        fav.font = [UIFont fontWithName:@"Helvetica" size:8];
        
        [baseView addSubview:imageBtn];
        [baseView addSubview:contentTextView];
        [baseView addSubview:price];
        [baseView addSubview:imageComment];
        [baseView addSubview:comment];
        [baseView addSubview:imagefav];
        [baseView addSubview:fav];
        [self addSubview:baseView];
    }
    self.dataInfo=data;
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)click{
    [self.idelegate click:self.dataInfo];
}
@end
