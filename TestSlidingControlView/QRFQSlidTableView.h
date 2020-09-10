//
//  QRFQSlidingControlView.h
//  TestSlidingControlView
//
//  Created by 星砺达 on 2020/4/22.
//  Copyright © 2020 星砺达. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class QRFQSlidTableView;
@protocol QRFQSlidTableViewDataSource <NSObject>

@required
/**
 Simulates a data source method. Gets the user's current items

 @param pageView pageView
 @return items count
 */
- (NSInteger)numberOfItemsInPagerView:(QRFQSlidTableView *)pageView;

/**
 Analog data source methods. Get UICollectionViewCell Object

 @param fqSlidTableView pageView
 @param index current Index
 @return cell
 */
- (__kindof UITableViewCell *)fqSlidTableView:(QRFQSlidTableView *)fqSlidTableView cellForItemAtIndex:(NSInteger)index;

/**
 custom view for header. will be adjusted to default or specified header height
 */
- (__kindof UIView *)fqSlidTableView:(QRFQSlidTableView *)fqSlidTableView viewForHeaderInSection:(NSInteger)section;

@end

@protocol QRFQSlidTableViewDelegate <NSObject>

@optional

/**
 Click on the image callback

 @param fqSlidTableView pageView
 @param index selectIndex
 */
- (void)fqSlidTableView:(QRFQSlidTableView *)fqSlidTableView didSelectItemAtIndex:(NSInteger)index;

/// scrollViewDidScroll
/// @param fqSlidTableView pageView
/// @param scrollView  scrollview view
-(void)fqSlidTableView:(QRFQSlidTableView *)fqSlidTableView scrollViewDidScroll:(UIScrollView *)scrollView;

@end


@interface QRFQSlidTableView : UIView

/// 父容器
@property (nonatomic, weak) UIView* fq_superView;

/*
 总的容器视图
 */
@property (nonatomic, strong,readonly) UIView* containerView;//容器视图

/*
 顶部内容视图--可在其上编辑内容
 */
@property (nonatomic, strong,readonly) UIView* topContentView;

/**
 从topContent底到tableView顶之间的间距.默认为0
 */
@property (nonatomic, assign) CGFloat topTableViewMargin;

/**
 设置视图展开时.containerView与顶部的距离
 */
@property (nonatomic, assign) CGFloat fqTableViewOpenY;

/**
 设置顶部视图:topContentView的高度
 */
@property (nonatomic, assign) CGFloat fqTableViewHeaderH;

/**
 设置tableView的行高
*/
@property (nonatomic, assign) CGFloat tableViewRowH;

/**
 设置headerView的高度
*/
@property (nonatomic, assign) CGFloat tableHeaderViewH;

/**
 是否可以滚动tableView视图.默认为YES.如果为NO.则不可滚动
 */
@property (nonatomic, assign) BOOL hasTableViewEnable;

/**
 是否展示遮盖按钮.默认为YES.
 */
@property (nonatomic, assign) BOOL hasShowCoverBtn;

/**
 Adhere to and implement the specified delegate method
 */
@property (nonatomic, weak) id<QRFQSlidTableViewDelegate> delegate;

/**
 Adhere to and implement the specified DataSource method (must be implemented)
 */
@property (nonatomic, weak) id<QRFQSlidTableViewDataSource> dataSource;

/**
 showContentView Block
 */
@property (nonatomic, copy) void(^clickShowCoverView)(void);

/**
 dismissContentView Block
 */
@property (nonatomic, copy) void(^clickDismissCoverView)(void);


/// 初始化方法
/// @param superView 父容器视图
-(instancetype)initWithSuperView:(UIView *)superView;

/**
 Dismiss content view
 */
-(void)dismissCoverView;

/**
 Show content view
 */
-(void)showCoverView;

/**
 Overloaded data. Update interface
 */
-(void)reloadData;

/**
 register pager view cell with class
 */
- (void)registerClass:(Class)Class forCellWithReuseIdentifier:(NSString *)identifier;

/**
 register pager view cell with nib
 */
- (void)registerNib:(UINib *)nib forCellWithReuseIdentifier:(NSString *)identifier;

/**
 register pager view headerView with class
*/
- (void)registerClass:(nullable Class)aClass forHeaderFooterViewReuseIdentifier:(NSString *)identifier;
/**
 dequeue reusable cell for pagerView
 */
- (__kindof UITableViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndex:(NSInteger)index;

/**
 dequeue reusable headerView for pagerView
*/
- (nullable __kindof UITableViewHeaderFooterView *)dequeueReusableHeaderFooterViewWithIdentifier:(NSString *)identifier;

@end

NS_ASSUME_NONNULL_END
