//
//  KYBubbleView.h
//  DrugRef
//
//  Created by chen xin on 12-6-6.
//  Copyright (c) 2012年 Kingyee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KYBubbleView : UIView {
    NSDictionary *_infoDict;
    UILabel         *titleLabel;
    UILabel         *detailLabel;
    UIButton        *rightButton;
    NSUInteger      index;
}

@property (nonatomic, retain)NSDictionary *infoDict;
@property NSUInteger index;

- (BOOL)showFromRect:(CGRect)rect;
- (void)makePhoneCall;

@end
