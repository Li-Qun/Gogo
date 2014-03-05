//
//  CatCell.m
//  goshopping
//
//  Created by ss4346 on 13-12-5.
//  Copyright (c) 2013年 huiztech. All rights reserved.
//

#import "CatCell.h"

@implementation CatCell

@synthesize thumbnail;
@synthesize label;


- (id)init {
	
    if (self = [super init]) {
		
        self.frame = CGRectMake(0, 0, 100, 145);
		
		[[NSBundle mainBundle] loadNibNamed:@"CatCell" owner:self options:nil];
    
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.view];
		

	}
	
    return self;
	
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code.
 }
 */

@end
