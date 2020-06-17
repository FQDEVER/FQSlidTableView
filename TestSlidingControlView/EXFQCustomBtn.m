//
//  EXFQCustomBtn.m
//  QHZC_DEV
//
//  Created by 范奇 on 2019/8/19.
//  Copyright © 2019 QHJF. All rights reserved.
//

#import "EXFQCustomBtn.h"

@implementation UIView (FQExtension)
+ (instancetype)viewFromNib
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (void)setFQ_x:(CGFloat)FQ_x
{
    CGRect frame = self.frame;
    frame.origin.x = FQ_x;
    self.frame = frame;
}

- (CGFloat)FQ_x
{
    return self.frame.origin.x;
}

- (void)setFQ_y:(CGFloat)FQ_y
{
    CGRect frame = self.frame;
    frame.origin.y = FQ_y;
    self.frame = frame;
}

- (CGFloat)FQ_y
{
    return self.frame.origin.y;
}

- (void)setFQ_width:(CGFloat)FQ_width
{
    CGRect frame = self.frame;
    frame.size.width = FQ_width;
    self.frame = frame;
}

- (CGFloat)FQ_width
{
    return self.frame.size.width;
}

- (void)setFQ_height:(CGFloat)FQ_height
{
    CGRect frame = self.frame;
    frame.size.height = FQ_height;
    self.frame = frame;
}

- (CGFloat)FQ_height
{
    return self.frame.size.height;
}

-(void)setFQ_centerX:(CGFloat)FQ_centerX
{
    CGPoint center = self.center;
    center.x = FQ_centerX;
    self.center = center;
}

- (CGFloat)FQ_centerX
{
    return self.center.x;
}

-(void)setFQ_centerY:(CGFloat)FQ_centerY
{
    CGPoint center = self.center;
    center.y = FQ_centerY;
    self.center = center;
}

- (CGFloat)FQ_centerY
{
    return self.center.y;
}

- (void)setFQ_right:(CGFloat)FQ_right
{
    self.FQ_x = FQ_right - self.FQ_width;
}

- (CGFloat)FQ_right
{
    return CGRectGetMaxX(self.frame);
}

- (void)setFQ_buttom:(CGFloat)FQ_buttom
{
    self.FQ_y = FQ_buttom - self.FQ_height;
}

- (CGFloat)FQ_buttom
{
    return CGRectGetMaxY(self.frame);
}

- (void)setFQ_size:(CGSize)FQ_size
{
    CGRect frame = self.frame;
    frame.size = FQ_size;
    self.frame = frame;
}

- (CGSize)FQ_size
{
    return self.frame.size;
}

- (void)setFQ_orign:(CGPoint)FQ_orign
{
    CGRect frame = self.frame;
    frame.origin = FQ_orign;
    self.frame = frame;
}
- (CGPoint)FQ_orign
{
    return self.frame.origin;
}
@end


@implementation EXFQCustomBtn
// 我们自己实现的方法，也就是和self的viewDidLoad方法进行交换的方法。
- (void)layoutSubviews {
    [super layoutSubviews];
    
    switch (self.style) {
        case FQ_ButtonImageTitleStyleLeft:
        {
            // 图片在左，标题在右
            
            self.imageView.FQ_x = (self.FQ_width - self.imageView.FQ_width - self.titleLabel.FQ_width - self.fq_padding) * 0.5;
            self.titleLabel.FQ_x = self.imageView.FQ_right + self.fq_padding;
            self.titleLabel.textAlignment = NSTextAlignmentLeft;
        }
            break;
        case FQ_ButtonImageTitleStyleRight:
        {
            // 图片在右，标题在左
            
            self.titleLabel.FQ_x = (self.FQ_width - self.imageView.FQ_width - self.titleLabel.FQ_width - self.fq_padding) * 0.5;
            self.titleLabel.textAlignment = NSTextAlignmentLeft;
            
            self.imageView.FQ_x = self.titleLabel.FQ_right + self.fq_padding;
        }
            break;
        case FQ_ButtonImageTitleStyleTop:
        {
            // 图片在上，文字在下,整体居中
            self.imageView.FQ_centerX = self.FQ_width * 0.5;
            self.imageView.FQ_y = (self.FQ_height - self.imageView.FQ_height - self.titleLabel.FQ_height - self.fq_padding) * 0.5;
            
            self.titleLabel.FQ_width = self.FQ_width;
            self.titleLabel.FQ_y = self.imageView.FQ_buttom + self.fq_padding;
            self.titleLabel.FQ_x = 0;
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
        }
            break;
        case FQ_ButtonImageTitleStyleBottom:
        {
            //图片在下，文字在上，整体居中。
            self.titleLabel.FQ_width = self.FQ_width;
            self.titleLabel.FQ_y = (self.FQ_height - self.imageView.FQ_height - self.titleLabel.FQ_height - self.fq_padding) * 0.5;
            self.titleLabel.FQ_x = 0;
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            
            self.imageView.FQ_centerX = self.FQ_width * 0.5;
            self.imageView.FQ_y = self.titleLabel.FQ_buttom + self.fq_padding;
        }
            break;
        case FQ_ButtonImageTitleStyleCenterTop:
        {
            //图片居中，文字在上 距离按钮顶部。
            self.imageView.FQ_centerX = self.FQ_width * 0.5;
            self.imageView.FQ_centerY = self.FQ_height * 0.5;
            
            self.titleLabel.FQ_width = self.FQ_width;
            self.titleLabel.FQ_y = self.fq_padding;
            self.titleLabel.FQ_x = 0;
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
        }
            break;
        case FQ_ButtonImageTitleStyleCenterBottom:
        {
            //图片居中，文字在下 距离按钮底部。
            self.imageView.FQ_centerX = self.FQ_width * 0.5;
            self.imageView.FQ_centerY = self.FQ_height * 0.5;
            
            self.titleLabel.FQ_width = self.FQ_width;
            self.titleLabel.FQ_y = self.FQ_height - self.titleLabel.FQ_height - self.fq_padding;
            self.titleLabel.FQ_x = 0;
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
        }
            break;
        case FQ_ButtonImageTitleStyleCenterUp:
        {
            //图片居中，文字在图片上面 距离图片顶部。
            self.imageView.FQ_centerX = self.FQ_width * 0.5;
            self.imageView.FQ_centerY = self.FQ_height * 0.5;
            
            self.titleLabel.FQ_width = self.FQ_width;
            self.titleLabel.FQ_y = self.imageView.FQ_y - self.fq_padding - self.titleLabel.FQ_height;
            self.titleLabel.FQ_x = 0;
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
        }
            break;
        case FQ_ButtonImageTitleStyleCenterDown:
        {
            
            //图片居中，文字在图片下面 距离图片底部。
            self.imageView.FQ_centerX = self.FQ_width * 0.5;
            self.imageView.FQ_centerY = self.FQ_height * 0.5;
            
            self.titleLabel.FQ_width = self.FQ_width;
            self.titleLabel.FQ_y = self.imageView.FQ_buttom + self.fq_padding;
            self.titleLabel.FQ_x = 0;
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
        }
            break;
        case FQ_ButtonImageTitleStyleRightLeft:
        {
            //图片在右，文字在左，距离按钮两边边距
            self.imageView.FQ_x = self.fq_padding;
            self.imageView.FQ_centerY = self.FQ_height * 0.5;
            
            self.titleLabel.FQ_centerY = self.FQ_height * 0.5;
            self.titleLabel.FQ_x = self.FQ_width - self.fq_padding - self.titleLabel.FQ_width;
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
        }
            break;
        case FQ_ButtonImageTitleStyleLeftRight:
        {
            
            //图片在左，文字在右，距离按钮两边边距
            self.titleLabel.FQ_x = self.fq_padding;
            self.titleLabel.FQ_centerY = self.FQ_height * 0.5;
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            
            self.imageView.FQ_centerY = self.FQ_height * 0.5;
            self.imageView.FQ_x = self.FQ_width - self.fq_padding - self.imageView.FQ_width;
            
        }
            break;
        case FQ_ButtonImageTitleStyleFloatingTop:
        {
            //图片在下, 文字浮在上层, 均居中
            self.imageView.FQ_centerY = self.FQ_height * 0.5;
            self.imageView.FQ_centerX = self.FQ_width * 0.5;
            
            self.titleLabel.FQ_centerX = self.FQ_width * 0.5;
            self.titleLabel.FQ_centerY = self.FQ_height * 0.5;
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            
        }
            break;
        case FQ_ButtonImageTitleStyleDoubleLeft:
        {
            //图片和文本居左.
            self.imageView.FQ_x = self.leftMargin;
            self.imageView.FQ_centerY = self.FQ_height * 0.5;
            
            self.titleLabel.FQ_x = self.imageView.FQ_x + self.imageView.FQ_width + self.fq_padding;
            self.titleLabel.FQ_centerY = self.FQ_height * 0.5;
            self.titleLabel.textAlignment = NSTextAlignmentLeft;
        }
            break;
        case FQ_ButtonImageTitleStyleWeatherBtn:
        {
            CGFloat imgW = 30;
            CGFloat imgH = 30;
            self.imageView.FQ_x = (self.FQ_width - self.imageView.FQ_width - self.titleLabel.FQ_width - self.fq_padding) * 0.5;
            self.imageView.FQ_width = imgW;
            self.imageView.FQ_height = imgH;
            self.imageView.FQ_y = (self.FQ_height - self.imageView.FQ_height) * 0.5;
            self.titleLabel.FQ_x = self.imageView.FQ_right + self.fq_padding;
            self.titleLabel.textAlignment = NSTextAlignmentLeft;
        }
            break;
        case FQ_ButtonImageTitleStyleRight_Right:{
            // 图片在右，标题在左.整体居右
            self.imageView.FQ_x = self.FQ_width - self.rightMargin - self.imageView.FQ_width;
            self.titleLabel.FQ_x = self.imageView.FQ_x - self.fq_padding - self.titleLabel.FQ_width;
            self.titleLabel.textAlignment = NSTextAlignmentRight;
        }
            break;
        case FQ_ButtonImageTitleStyleRight_IDCard:
        {
            // 图片在上，文字在下,整体居中
            self.imageView.FQ_width = self.imageView.FQ_height = 90;
            self.imageView.FQ_centerX = self.FQ_width * 0.5;
            self.imageView.FQ_y = (self.FQ_height - self.imageView.FQ_height - self.titleLabel.FQ_height - self.fq_padding) * 0.5;
            
            self.titleLabel.FQ_width = self.FQ_width;
            self.titleLabel.FQ_y = self.imageView.FQ_buttom + self.fq_padding;
            self.titleLabel.FQ_x = 0;
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
        }
            break;
        case FQ_ButtonImageTitleStyleRight_Certification:{
            // 图片在上，文字在下,整体居中
            self.imageView.FQ_width = self.imageView.FQ_height = 25;
            self.imageView.FQ_centerX = self.FQ_width * 0.5;
            self.imageView.FQ_y = (self.FQ_height - self.imageView.FQ_height - self.titleLabel.FQ_height - self.fq_padding) * 0.5;
            
            self.titleLabel.FQ_width = self.FQ_width;
            self.titleLabel.FQ_y = self.imageView.FQ_buttom + self.fq_padding;
            self.titleLabel.FQ_x = 0;
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
        }
            break;
        default:
            break;
    }
    
}

@end
