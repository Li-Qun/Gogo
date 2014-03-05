//
//  DataInfo.h
//  AOWaterView
//
//  Created by akria.king on 13-4-10.
//  Copyright (c) 2013年 akria.king. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataInfo : NSObject
@property float width;
@property float height;

@property(nonatomic,strong)NSString *productId;
@property(nonatomic,strong)NSString *marketId;
@property(nonatomic,strong)NSString *manufacturerId;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *description;
@property(nonatomic,strong)NSString *image;
@property(nonatomic,strong)NSString *price;
@property(nonatomic,strong)NSString *reviewCount;
@property(nonatomic,strong)NSString *favCount;



@end
