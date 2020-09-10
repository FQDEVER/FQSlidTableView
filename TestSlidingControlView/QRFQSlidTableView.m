//
//  QRFQSlidingControlView.m
//  TestSlidingControlView
//
//  Created by 星砺达 on 2020/4/22.
//  Copyright © 2020 星砺达. All rights reserved.
//

#import "QRFQSlidTableView.h"
#import <Masonry/Masonry.h>
#import "EXFQCustomBtn.h"

#define FQSCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define FQSCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define kAppBottomMargin 0
#define KEY_WINDOW        [[UIApplication sharedApplication] keyWindow]

@interface QRFQSlidTableView ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,UIScrollViewDelegate>
{
    struct {
        unsigned int didSelectItemAtIndex :1;
        unsigned int scrollViewDidScroll :1;
    }_delegateFlags;
    struct {
        unsigned int cellForItemAtIndex   :1;
        unsigned int viewForHeaderInSection : 1;
        unsigned int numberOfItemsInPagerView : 1;
    }_dataSourceFlags;
}

/*
 总的容器视图
 */
@property (nonatomic, strong) UIView* containerView;//容器视图

/*
 顶部内容视图
 */
@property (nonatomic, strong) UIView* topContentView;

/*
 内容滚动视图
 */
@property (nonatomic, strong) UITableView * tableView;

/*
 遮罩按钮
 */
@property (nonatomic, strong) UIButton *coverBtn;

/**
 视图收起时.containerView与顶部的距离
 */
@property (nonatomic, assign) CGFloat fqTableViewCloseY;

/*
 hasOptionTable: 记录当前是否可操作tableView
 
 记录tableView当前的状态.若为YES.则可操作tableView.若为NO.则不可操作tableView.且禁用状态
 */
@property (nonatomic, assign) BOOL hasOptionTable;

/*
 hasFirstOption: 记录是否第一次操作.
 
 用来判断当前控件是否应该响应tableView还是containerView的手势
 */
@property (nonatomic, assign) BOOL hasFirstOption;

/*
 hasContainsTopContent:判断最初的手势是否在topContentView中
 
 手势最开始响应的控件是否是topContentView.偏移效果模拟苹果的方案:
 1.如果是topContentView.则tableView不做滚动.只负责整体视图的上或者下偏移.即hasOptionTable                                                                    = NO.
 2.如果是操作在tableView上.则依据之前的逻辑.即根据hasFirstOption == YES时.进一步判断
 a.如果tableView第一次的偏移值大于0.则是操作tableView.主要控制tableView.即hasOptionTable                                                                  = YES.
 b.如果tableView第一次的偏移值小于0.则禁用tableView的滚动事件.让整体containerView视图偏移.即hasOptionTable                                                       = NO.
 如果计算出的偏移后的y值小于最小值_fqTableViewOpenY时.则让containerView.y                                                                                  = _fqTableViewOpenY;并且让tableView做对应的偏移
 如果计算出的偏移后的y值大于最小值_fqTableViewOpenY时.则让containerView.y                                                                                  = 偏移值后的值;并且让tableView的偏移为CGPointZero
 */
@property (nonatomic, assign) BOOL hasContainsTopContent;

@end

@implementation QRFQSlidTableView


-(instancetype)initWithSuperView:(UIView *)superView{
    if (self            = [super init]) {
        self.userInteractionEnabled = NO;
        _fq_superView = superView;
        _fqTableViewOpenY = 125.0f;
        _fqTableViewHeaderH = 69.0f;
        _tableViewRowH = 44.0f;
        _topTableViewMargin = 0;
        _tableHeaderViewH = CGFLOAT_MIN;
        _fqTableViewCloseY = FQSCREEN_HEIGHT - _fqTableViewHeaderH - kAppBottomMargin;
        _hasTableViewEnable = YES;
        _hasShowCoverBtn = YES;
        [self creatUI];
        self.hasFirstOption = YES;
    }
    return self;
}

-(void)creatUI{
    
    [self.coverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.offset(0);
    }];
    
    if (self.fq_superView) {
        [self.fq_superView addSubview:self.containerView];
    }else{
        [KEY_WINDOW addSubview:self.containerView];
    }
    self.containerView.frame = CGRectMake(0, _fqTableViewCloseY, FQSCREEN_WIDTH, FQSCREEN_HEIGHT - _fqTableViewOpenY);
//    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.offset(_fqTableViewCloseY);
//        make.left.right.bottom.offset(0);
//    }];
    
    self.topContentView.frame = CGRectMake(0, 0, FQSCREEN_WIDTH, _fqTableViewHeaderH);
    [self.containerView addSubview:self.topContentView];
//    [self.topContentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.offset(0);
//        make.height.mas_equalTo(_fqTableViewHeaderH);
//    }];
    
    self.tableView.frame = CGRectMake(0, _fqTableViewHeaderH + kAppBottomMargin + _topTableViewMargin, FQSCREEN_WIDTH, FQSCREEN_HEIGHT - _fqTableViewOpenY - _fqTableViewHeaderH - _topTableViewMargin);
    [self.containerView addSubview:self.tableView];
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.topContentView.mas_bottom);
//        make.left.right.offset(0);
//        make.bottom.offset(0);
//        make.height.mas_equalTo(FQSCREEN_HEIGHT - _fqTableViewOpenY - _fqTableViewHeaderH);
//    }];
}

-(void)setFqTableViewHeaderH:(CGFloat)fqTableViewHeaderH
{
    _fqTableViewHeaderH = fqTableViewHeaderH;
    
    self.topContentView.FQ_height = _fqTableViewHeaderH;
//    [self.topContentView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(_fqTableViewHeaderH);
//    }];
    
    _fqTableViewCloseY = FQSCREEN_HEIGHT - _fqTableViewHeaderH - kAppBottomMargin;
    self.containerView.frame = CGRectMake(0, _fqTableViewCloseY, FQSCREEN_WIDTH, FQSCREEN_HEIGHT - _fqTableViewOpenY);
    self.tableView.FQ_y = _fqTableViewHeaderH + kAppBottomMargin + _topTableViewMargin;
    self.tableView.FQ_height = FQSCREEN_HEIGHT - _fqTableViewOpenY - _fqTableViewHeaderH - _topTableViewMargin;
//    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(FQSCREEN_HEIGHT - _fqTableViewOpenY - _fqTableViewHeaderH);
//    }];
}

-(void)setFqTableViewOpenY:(CGFloat)fqTableViewOpenY
{
    _fqTableViewOpenY = fqTableViewOpenY;
    
//    self.containerView.FQ_y = _fqTableViewOpenY;
//    [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.offset(_fqTableViewOpenY);
//    }];
    self.tableView.FQ_height = FQSCREEN_HEIGHT - _fqTableViewOpenY - _fqTableViewHeaderH - _topTableViewMargin;
//    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(FQSCREEN_HEIGHT - _fqTableViewOpenY - _fqTableViewHeaderH);
//    }];
}

-(void)setTopTableViewMargin:(CGFloat)topTableViewMargin
{
    _topTableViewMargin = topTableViewMargin;
    self.tableView.FQ_y = _fqTableViewHeaderH + kAppBottomMargin + _topTableViewMargin;
    self.tableView.FQ_height = FQSCREEN_HEIGHT - _fqTableViewOpenY - _fqTableViewHeaderH - _topTableViewMargin;
}

-(void)setTableViewRowH:(CGFloat)tableViewRowH
{
    _tableViewRowH = tableViewRowH;
    self.tableView.rowHeight = tableViewRowH;
}

-(void)setHasShowCoverBtn:(BOOL)hasShowCoverBtn
{
    _hasShowCoverBtn = hasShowCoverBtn;
    self.coverBtn.hidden = !hasShowCoverBtn;
}

#pragma mark - 事件处理

/// 收起遮罩.下滑tableView
-(void)dismissCoverView{
    
    if (self.containerView.FQ_y == self.fqTableViewCloseY) {
        return;
    }
    [UIView animateWithDuration:0.33 animations:^{
        self.coverBtn.alpha     = 0.0f;
        self.tableView.FQ_y = self.fqTableViewHeaderH + kAppBottomMargin;
        self.containerView.FQ_y = self.fqTableViewCloseY;
    }completion:^(BOOL finished) {
        if (self.clickDismissCoverView) {
            self.clickDismissCoverView();
        }
    }];
}

/// 展示遮罩按钮
-(void)showCoverView{
    if (self.containerView.FQ_y == self.fqTableViewOpenY) {
        return;
    }
    [UIView animateWithDuration:0.33 animations:^{
        self.coverBtn.alpha     = 1.0f;
        self.tableView.FQ_y = self.fqTableViewHeaderH + self.topTableViewMargin;
        self.containerView.FQ_y = self.fqTableViewOpenY;
    }completion:^(BOOL finished) {
        if (self.clickShowCoverView) {
            self.clickShowCoverView();
        }
    }];
}


#pragma mark - tableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [_dataSource numberOfItemsInPagerView:self];;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dataSourceFlags.cellForItemAtIndex) {
        return [_dataSource fqSlidTableView:self cellForItemAtIndex:indexPath.row];
    }
    NSAssert(NO, @"pagerView cellForItemAtIndex: is nil!");
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_dataSourceFlags.viewForHeaderInSection) {
        return [_dataSource fqSlidTableView:self viewForHeaderInSection:section];
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_delegateFlags.didSelectItemAtIndex) {
        [self.delegate fqSlidTableView:self didSelectItemAtIndex:indexPath.row];
    }
}


#pragma mark - Public external methods

- (void)registerClass:(Class)Class forCellWithReuseIdentifier:(NSString *)identifier {
    [_tableView registerClass:Class forCellReuseIdentifier:identifier];
}

- (void)registerNib:(UINib *)nib forCellWithReuseIdentifier:(NSString *)identifier {
    [_tableView registerNib:nib forCellReuseIdentifier:identifier];
}

/**
 register pager view headerView with class
*/
- (void)registerClass:(nullable Class)aClass forHeaderFooterViewReuseIdentifier:(NSString *)identifier{
    [_tableView registerClass:aClass forHeaderFooterViewReuseIdentifier:identifier];
}

/**
 dequeue reusable cell for pagerView
 */
- (__kindof UITableViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndex:(NSInteger)index
{
    UITableViewCell * cell = [_tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    return cell;
}

/**
 dequeue reusable headerView for pagerView
*/
- (nullable __kindof UITableViewHeaderFooterView *)dequeueReusableHeaderFooterViewWithIdentifier:(NSString *)identifier{
    UITableViewHeaderFooterView * headerView = [_tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    return headerView;
}

-(void)reloadData{
    [_tableView reloadData];
}


#pragma mark - 手势相关

/*
 共存.让多手势均响应
 A手势或者B手势 代理方法里shouldRecognizeSimultaneouslyWithGestureRecognizer
 有一个是返回YES，就能共存
 //如果有scrollView方面的手势则可以了解以下方法
 - (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {}
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}


-(void)panGestureRecognizer:(UIPanGestureRecognizer *)pan{
    
    UIView *tempView                      = self.containerView;
    CGPoint transP                        = [pan translationInView:tempView];
    
    //如果手势结束时也需要根据偏移值做调整
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
        {
            //找出最开始的手势在那个视图中.为后续手势做依据
            if (self.hasTableViewEnable) {
                CGPoint locationPoint                 = [pan locationInView:self.containerView];
                self.hasContainsTopContent            = CGRectContainsPoint(self.topContentView.frame, locationPoint);
                //如果是操作在topContentView.则模拟苹果系统.tableView不做滚动.只负责整体视图的上移动或者下移动
                if (self.hasContainsTopContent) {
                    self.hasFirstOption                   = NO;
                    self.hasOptionTable                   = NO;
                    self.tableView.scrollEnabled          = NO;
                    self.tableView.userInteractionEnabled = NO;
                    self.tableView.contentOffset          = CGPointZero;
                }else{
                    //则以tableview的代理scrollViewDidScroll偏移值为判断依据
                }
            }else{
                self.hasContainsTopContent = YES;
                self.tableView.contentOffset          = CGPointZero;
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            //如果是操作tableView.则不作手势处理
            if (self.hasOptionTable && !self.hasContainsTopContent) {
                return;
            }
            
            //手势结束.还原tableView的状态
            self.tableView.scrollEnabled          = self.hasTableViewEnable;
            self.tableView.userInteractionEnabled = YES;
            self.hasFirstOption                   = YES;
            /*
             根据当前的containerView位置做判断动画.如果containerView的偏移操作一半则隐藏.否则就展示
             */
            CGFloat maxOffY                       = (FQSCREEN_HEIGHT - _fqTableViewOpenY)*0.5;
            if (self.containerView.FQ_y > maxOffY + _fqTableViewOpenY) {
                [self dismissCoverView];
            }else{
                [self showCoverView];
            }
        }
            break;
        default:
            break;
    }
    
    //如果是操作tableView.则不作手势处理
    if (self.hasOptionTable && !self.hasContainsTopContent) {
        return;
    }
    
    CGFloat offY                          = self.containerView.FQ_y + transP.y;
    if (offY <= _fqTableViewOpenY) {
        /*
         1.如果最初手势是在topContentView.则视图不做调整
         2.如果最初手势是在tableView上.则视图需要跟随调整
         */
        if (!self.hasContainsTopContent) {
            
            self.containerView.FQ_y               = _fqTableViewOpenY;
            if (self.hasTableViewEnable) {
                self.tableView.contentOffset          = CGPointMake(0, self.tableView.contentOffset.y + _fqTableViewOpenY - offY);
            }
        }
    }else{
        /*
         1.如果tableView有偏移.则让其tableView偏移回到CGPointZero.而后再containerView整体偏移
         2.如果tableView未偏移.则containerView整体偏移
         */
        if (!self.hasContainsTopContent) {
            if (self.tableView.contentOffset.y > 0) {
                self.containerView.FQ_y               = _fqTableViewOpenY;
                if (self.hasTableViewEnable) {
                    self.tableView.contentOffset          = CGPointMake(0, self.tableView.contentOffset.y - transP.y);
                }
            }else{
                self.containerView.FQ_y               = offY;
                if (self.hasTableViewEnable) {
                    self.tableView.contentOffset          = CGPointZero;
                }
            }
        }else{
            if (offY > _fqTableViewOpenY) {
                self.containerView.FQ_y               = offY;
            }else{
                self.containerView.FQ_y               = _fqTableViewOpenY;
            }
        }
    }
    
    // 复位,表示相对上一次
    [pan setTranslation:CGPointZero inView:self.containerView];
    
}

#pragma mark - scrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    /*
     根据hasFirstOption.第一次操作来识别并控制tableView是否可响应并可滚动
     */
    CGFloat offsetY                       = scrollView.contentOffset.y;
    if (self.hasFirstOption) {
        if (offsetY > 0) {
            self.tableView.scrollEnabled          = self.hasTableViewEnable;
            self.tableView.userInteractionEnabled = YES;
            self.hasOptionTable                   = YES;
            
        }else{
            self.hasOptionTable                   = NO;
            self.tableView.scrollEnabled          = NO;
            self.tableView.userInteractionEnabled = NO;
        }
        self.hasFirstOption                   = NO;
    }
    
    if (_delegateFlags.scrollViewDidScroll) {
        [self.delegate fqSlidTableView:self scrollViewDidScroll:scrollView];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.tableView.scrollEnabled          = self.hasTableViewEnable;
    self.tableView.userInteractionEnabled = YES;
    self.hasFirstOption                   = YES;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    self.tableView.scrollEnabled          = self.hasTableViewEnable;
    self.tableView.userInteractionEnabled = YES;
    self.hasFirstOption                   = YES;
}


#pragma mark - set&get

- (void)setDelegate:(id<QRFQSlidTableViewDelegate>)delegate
{
    _delegate = delegate;
    
    _delegateFlags.didSelectItemAtIndex = [delegate respondsToSelector:@selector(fqSlidTableView:didSelectItemAtIndex:)];
    _delegateFlags.scrollViewDidScroll = [delegate respondsToSelector:@selector(fqSlidTableView:scrollViewDidScroll:)];
}


- (void)setDataSource:(id<QRFQSlidTableViewDataSource>)dataSource {
    _dataSource = dataSource;
    _dataSourceFlags.cellForItemAtIndex = [dataSource respondsToSelector:@selector(fqSlidTableView:cellForItemAtIndex:)];
    _dataSourceFlags.viewForHeaderInSection = [dataSource respondsToSelector:@selector(fqSlidTableView:viewForHeaderInSection:)];
    _dataSourceFlags.numberOfItemsInPagerView = [dataSource respondsToSelector:@selector(numberOfItemsInPagerView:)];
}

-(void)setHasTableViewEnable:(BOOL)hasTableViewEnable
{
    _hasTableViewEnable = hasTableViewEnable;
    self.tableView.scrollEnabled = hasTableViewEnable;
}

-(void)setTableHeaderViewH:(CGFloat)tableHeaderViewH
{
    _tableHeaderViewH = tableHeaderViewH;
    self.tableView.sectionHeaderHeight = tableHeaderViewH;
}

-(UIView *)topContentView
{
    if (!_topContentView) {
        _topContentView                     = [[UIView alloc]init];
        _topContentView.backgroundColor     = UIColor.orangeColor;
    }
    return _topContentView;
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView                          = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate                 = self;
        _tableView.dataSource               = self;
        _tableView.backgroundColor          = [UIColor clearColor];
        _tableView.tableFooterView          = [[UIView alloc]initWithFrame:CGRectZero];
        _tableView.sectionFooterHeight      = 15;
        _tableView.rowHeight = _tableViewRowH;
        _tableView.sectionHeaderHeight = _tableHeaderViewH;
        _tableView.separatorStyle           = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor           = UIColor.whiteColor;
        _tableView.separatorInset           = UIEdgeInsetsMake(0, 15, 0, 10);
    }
    return _tableView;
}

-(UIButton *)coverBtn
{
    if (!_coverBtn) {
        _coverBtn                           = [UIButton buttonWithType:UIButtonTypeCustom];
        [_coverBtn addTarget:self action:@selector(dismissCoverView) forControlEvents:UIControlEventTouchUpInside];
        _coverBtn.backgroundColor           = [UIColor.blackColor colorWithAlphaComponent:0.5];
        self.coverBtn.alpha     = 0.0f;
        [self.fq_superView addSubview:_coverBtn];
        _coverBtn.hidden = !self.hasShowCoverBtn;
    }
    return _coverBtn;
}

-(UIView *)containerView
{
    if (!_containerView) {
        _containerView                      = [[UIView alloc]init];
        _containerView.backgroundColor      = UIColor.grayColor;
        //滑动手势
        UIPanGestureRecognizer * panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureRecognizer:)];
        panGesture.delegate                 = self;
        [_containerView addGestureRecognizer:panGesture];
    }
    return _containerView;
}

@end
