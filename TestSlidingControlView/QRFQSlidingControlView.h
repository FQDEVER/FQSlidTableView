//
//  QRFQSlidingControlView.h
//  TestSlidingControlView
//
//  Created by 星砺达 on 2020/4/22.
//  Copyright © 2020 星砺达. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class QRFQSlidingControlView;
@protocol QRFQSlidTableViewDataSource <NSObject>

@required
/**
 Simulates a data source method. Gets the user's current items

 @param pageView pageView
 @return items count
 */
- (NSInteger)numberOfItemsInPagerView:(QRFQSlidingControlView *)pageView;

/**
 Analog data source methods. Get UICollectionViewCell Object

 @param fqSlidTableView pageView
 @param index current Index
 @return cell
 */
- (__kindof UITableViewCell *)fqSlidTableView:(QRFQSlidingControlView *)fqSlidTableView cellForItemAtIndex:(NSInteger)index;

@end

@protocol QRFQSlidTableViewDelegate <NSObject>

@optional

/**
 Click on the image callback

 @param fqSlidTableView pageView
 @param index selectIndex
 */
- (void)fqSlidTableView:(QRFQSlidingControlView *)fqSlidTableView didSelectItemAtIndex:(NSInteger)index;

/// scrollViewDidScroll
/// @param fqSlidTableView pageView
/// @param scrollView  scrollview view
-(void)fqSlidTableView:(QRFQSlidingControlView *)fqSlidTableView scrollViewDidScroll:(UIScrollView *)scrollView;

@end


@interface QRFQSlidingControlView : UIView

/*
 顶部内容视图--可在其上编辑内容
 */
@property (nonatomic, strong,readonly) UIView* topContentView;

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
 Adhere to and implement the specified delegate method
 */
@property (nonatomic, weak) id<QRFQSlidTableViewDelegate> delegate;

/**
 Adhere to and implement the specified DataSource method (must be implemented)
 */
@property (nonatomic, weak) id<QRFQSlidTableViewDataSource> dataSource;


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
 dequeue reusable cell for pagerView
 */
- (__kindof UITableViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
