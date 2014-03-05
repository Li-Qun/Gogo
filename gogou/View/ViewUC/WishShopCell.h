//
//  WishShopCell.h
//  goshopping
//
//  Created by ss4346 on 13-11-18.
//  Copyright (c) 2013年 huiztech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@interface WishShopCell : UITableViewCell

@property (strong,nonatomic) IBOutlet EGOImageView *headImage;
@property (strong,nonatomic) IBOutlet UILabel *titelLabel;
@property (strong,nonatomic) IBOutlet UILabel *userLabel;
@property (strong,nonatomic) IBOutlet UIButton *delBtn;

@end
