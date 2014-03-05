//
//  CatCell.h
//  goshopping
//
//  Created by ss4346 on 13-12-5.
//  Copyright (c) 2013年 huiztech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyUIGridViewCell.h"
#import "EGOImageView.h"

@interface CatCell : MyUIGridViewCell{
    
}

@property (nonatomic, retain) IBOutlet EGOImageView *thumbnail;
@property (nonatomic, retain) IBOutlet UILabel *label;

@end
