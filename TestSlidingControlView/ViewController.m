//
//  ViewController.m
//  TestSlidingControlView
//
//  Created by 星砺达 on 2020/4/22.
//  Copyright © 2020 星砺达. All rights reserved.
//

#import "ViewController.h"
#import <Masonry/Masonry.h>
#import "QRFQSlidingControlView.h"
@interface ViewController ()<QRFQSlidTableViewDataSource,QRFQSlidTableViewDelegate>

@property (nonatomic, strong) QRFQSlidingControlView* slidingControlView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.slidingControlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
}

-(NSInteger)numberOfItemsInPagerView:(QRFQSlidingControlView *)pageView
{
    return 50;
}

-(__kindof UITableViewCell *)fqSlidTableView:(QRFQSlidingControlView *)fqSlidTableView cellForItemAtIndex:(NSInteger)index
{
    UITableViewCell *cell = [fqSlidTableView dequeueReusableCellWithReuseIdentifier:@"UITableViewCellID" forIndex:index];
    cell.textLabel.text = @(index).stringValue;
    return cell;
}

-(void)fqSlidTableView:(QRFQSlidingControlView *)fqSlidTableView scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"-------------滚动偏移-%f",scrollView.contentOffset.y);
}

-(void)fqSlidTableView:(QRFQSlidingControlView *)fqSlidTableView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"-------------点击索引-%zd",index);
}

-(QRFQSlidingControlView *)slidingControlView
{
    if (!_slidingControlView) {
        _slidingControlView = [[QRFQSlidingControlView alloc]init];
        _slidingControlView.delegate = self;
        _slidingControlView.dataSource = self;
        _slidingControlView.fqTableViewHeaderH = 60;
        _slidingControlView.fqTableViewOpenY = 125;
        _slidingControlView.tableViewRowH = 80;
        [_slidingControlView registerClass:[UITableViewCell class] forCellWithReuseIdentifier:@"UITableViewCellID"];
        [self.view addSubview:_slidingControlView];
    }
    return _slidingControlView;
}

@end
