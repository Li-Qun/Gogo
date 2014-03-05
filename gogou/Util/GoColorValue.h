//
//  GoColorValue.h
//  goshopping
//
//  Created by ss4346 on 13-11-12.
//  Copyright (c) 2013年 huiztech. All rights reserved.
//

#import <Foundation/Foundation.h>

#define VIEW_HEIGHT         [UIScreen mainScreen].bounds.size.height - [UIApplication sharedApplication].statusBarFrame.size.height -44
#define BOTTOM_BAR_HEIGHT   VIEW_HEIGHT -5

#define GO_ORANGE           [UIColor colorWithRed:253.0/255.0 green:110.0/255.0 blue: 44.0/255.0 alpha:1.0]
#define GO_BLUE             [UIColor colorWithRed: 41.0/255.0 green:156.0/255.0 blue:203.0/255.0 alpha:1.0]
#define GO_GRAY             [UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1.0]
#define GO_BACKGROUND       [UIColor colorWithRed:221.0/255.0 green:227.0/255.0 blue:234.0/255.0 alpha:1.0]

@interface GoColorValue : NSObject

@end
