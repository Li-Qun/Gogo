//
//  PictureViewController.h
//  gogou
//
//  Created by ss4346 on 13-12-16.
//  Copyright (c) 2013年 huiztech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGFocusImageFrame.h"
#import "SGFocusImageItem.h"
#import "GoBaseViewController.h"

@interface PictureViewController : GoBaseViewController<SGFocusImageFrameDelegate>
{
    UIScrollView *galleryView;
    
    NSMutableArray *advList;
}

@property (strong,nonatomic) NSString *productID;

@end
