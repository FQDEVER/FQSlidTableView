//
//  EXFQCustomBtn.h
//  QHZC_DEV
//
//  Created by 范奇 on 2019/8/19.
//  Copyright © 2019 QHJF. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/*
 针对同时设置了Image和Title的场景时UIButton中的图片和文字的关系
 */
typedef NS_ENUM(NSInteger, FQ_ButtonImageTitleStyle ) {
    FQ_ButtonImageTitleStyleLeft  = 1,         //图片在左，文字在右，整体居中。
    FQ_ButtonImageTitleStyleRight     = 2,     //图片在右，文字在左，整体居中。
    FQ_ButtonImageTitleStyleTop  = 3,          //图片在上，文字在下，整体居中。
    FQ_ButtonImageTitleStyleBottom    = 4,     //图片在下，文字在上，整体居中。
    
    FQ_ButtonImageTitleStyleCenterTop = 5,     //图片居中，文字在上,距离按钮顶部。
    FQ_ButtonImageTitleStyleCenterBottom = 6,  //图片居中，文字在下,距离按钮底部。
    
    
    FQ_ButtonImageTitleStyleCenterUp = 7,      //图片居中，文字在图片上面,距离图片顶部。
    FQ_ButtonImageTitleStyleCenterDown = 8,    //图片居中，文字在图片下面,距离图片底部。
    
    FQ_ButtonImageTitleStyleRightLeft = 9,     //图片在右，文字在左，距离按钮两边边距
    FQ_ButtonImageTitleStyleLeftRight = 10,    //图片在左，文字在右，距离按钮两边边距
    
    FQ_ButtonImageTitleStyleFloatingTop = 11,  //图片在下，文字浮在上层，均居中
    FQ_ButtonImageTitleStyleDoubleLeft = 12,   // |-leftMargin-图片-fq_padding-文字- |
    FQ_ButtonImageTitleStyleWeatherBtn = 13,   // 天气按钮特定.图标宽30.高21
    FQ_ButtonImageTitleStyleRight_Right     = 14,     //图片在右，文字在左，整体居右
    FQ_ButtonImageTitleStyleRight_IDCard     = 15,     //图片在上，文字在下，整体居中。针对身份证样式
    FQ_ButtonImageTitleStyleRight_Certification     = 16,     //图片在上，文字在下，整体居中。针对认证界面
    
};

@interface UIView (FQExtension)
@property (nonatomic, assign) CGFloat FQ_x;
@property (nonatomic, assign) CGFloat FQ_y;
@property (nonatomic, assign) CGFloat FQ_width;
@property (nonatomic, assign) CGFloat FQ_height;
@property (nonatomic, assign) CGFloat FQ_centerX;
@property (nonatomic, assign) CGFloat FQ_centerY;
@property (nonatomic, assign) CGFloat FQ_right;
@property (nonatomic, assign) CGFloat FQ_buttom;
@property (nonatomic, assign) CGSize  FQ_size;
@property (nonatomic, assign) CGPoint FQ_orign;

+ (instancetype)viewFromNib;

@end

@interface EXFQCustomBtn : UIButton

@property (nonatomic, assign) FQ_ButtonImageTitleStyle style;

/**
 图片与文本的间距
 */
@property (nonatomic, assign) CGFloat fq_padding;

/**
 距离左侧的间距
 */
@property (nonatomic, assign) CGFloat leftMargin;

/**
 距离右侧的间距
 */
@property (nonatomic, assign) CGFloat rightMargin;

@end


NS_ASSUME_NONNULL_END
