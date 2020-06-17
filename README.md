# FQSlidTableView
实现苹果系统滑动效果

苹果iOS 11.0版本开始.系统模态跳转的效果自动发生变化.并且很多App开始参考实现.但是体验总是有所欠缺.刚好项目中有类似需求.基本实现这个效果

首先看一下苹果系统的效果
https://upload-images.jianshu.io/upload_images/2100495-0e3be7c5fc55202f.gif?imageMogr2/auto-orient/strip

我们谈一下实现过程

####结构如下:

      {
          containerView-
                                    coverBtn-
                                    topContentView-
                                    tableView-
       }

####整体思路:

1.给containerView视图添加手势
2.监听tableView偏移
3.根据偏移做不同的判断

定义相关BOOL属性:
`hasContainsTopContent`:判断最初的手势落点是否在`topContentView`上.还是`tableView`上
`hasOptionTable`:记录`tableView`当前的状态.若为YES.则可操作`tableView`.若为NO.则不可操作`tableView`.且禁用状态
`hasFirstOption`:记录是否开始操作.

####核心思想:

1.如果是`topContentView`上.则`tableView`不做滚动. `containerView`视图整体的上或者下偏移.即`hasOptionTable = NO`.

 2.如果是操作在`tableView`上.则依据之前的逻辑.即根据`hasFirstOption == YES`时.进一步判断
     a.如果`tableView`第一次的偏移值大于0.则是操作`tableView`.主要控制`tableView`.即`hasOptionTable = YES`.
     b.如果`tableView`第一次的偏移值小于0.则禁用tableView的滚动事件.让整体`containerView`视图偏移.即`hasOptionTable = NO`.
            i.如果计算出的偏移后的y值小于最小值`kTableViewOpenY`时.则让`containerView.y = kTableViewOpenY`;并且让`tableView`做对应的偏移
            ii.如果计算出的偏移后的y值大于最小值`kTableViewOpenY`时.则让`containerView.y = 偏移值后的值`;并且让`tableView`的偏移为`CGPointZero`


######核心代码分享:

手势开始.找出最开始的手势在那个视图中.为后续手势做依据

    CGPoint locationPoint = [pan locationInView:self.containerView];
        self.hasContainsTopContent = CGRectContainsPoint(self.topContentView.frame, locationPoint);
        //如果是操作在topContentView.则模拟苹果系统.tableView不做滚动.只负责整体视图的上移动或者下移动
        if (self.hasContainsTopContent) {
            self.hasFirstOption = NO;
            self.hasOptionTable = NO;
            self.tableView.scrollEnabled = NO;
            self.tableView.userInteractionEnabled = NO;
            self.tableView.contentOffset = CGPointZero;
        }else{
            //则以tableview的代理scrollViewDidScroll偏移值为判断依据
        }
手势结束.还原tableView的状态
         
        self.tableView.scrollEnabled = YES;
        self.tableView.userInteractionEnabled = YES;
        self.hasFirstOption = YES;
        /*
        根据当前的containerView位置做判断动画.如果containerView的偏移操作一半则隐藏.否则就展示
        */
        CGFloat maxOffY = (FQSCREEN_HEIGHT - kTableViewOpenY)*0.5;
        if (self.containerView.FQ_y > maxOffY + kTableViewOpenY) {
             [self clickCoverBtn];
        }else{
             [self showCoverBtn];
        }
根据手势偏移值判断相关视图的偏移量

        CGFloat offY = self.containerView.FQ_y + transP.y;
        if (offY <= kTableViewOpenY) {
            /*
             1.如果最初手势是在topContentView.则视图不做调整
             2.如果最初手势是在tableView上.则视图需要跟随调整
             */
            if (!self.hasContainsTopContent) {
                
                self.containerView.FQ_y = kTableViewOpenY;
                self.tableView.contentOffset = CGPointMake(0, self.tableView.contentOffset.y + kTableViewOpenY - offY);
            }
        }else{
            /*
            1.如果tableView有偏移.则让其tableView偏移回到CGPointZero.而后再containerView整体偏移
            2.如果tableView未偏移.则containerView整体偏移
            */
            if (self.tableView.contentOffset.y > 0) {
                self.containerView.FQ_y = kTableViewOpenY;
                self.tableView.contentOffset = CGPointMake(0, self.tableView.contentOffset.y - transP.y);
            }else{
                
                self.tableView.contentOffset = CGPointZero;
                self.containerView.FQ_y = offY;
            }
        }

如果手势落点最初在tableView上.则以代理方法的偏移方法作参考
        
      -(void)scrollViewDidScroll:(UIScrollView *)scrollView
        {
            /*
             根据hasFirstOption.第一次操作来识别并控制tableView是否可响应并可滚动
             */
            CGFloat offsetY = scrollView.contentOffset.y;
            if (self.hasFirstOption) {
                if (offsetY > 0) {
                    self.tableView.scrollEnabled = YES;
                    self.tableView.userInteractionEnabled = YES;
                    self.hasOptionTable = YES;
                    
                }else{
                    self.hasOptionTable = NO;
                    self.tableView.scrollEnabled = NO;
                    self.tableView.userInteractionEnabled = NO;
                }
                self.hasFirstOption = NO;
            }
        }

滚动结束时还原tableVeiw的状态

        -(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
        {
            self.tableView.scrollEnabled = YES;
            self.tableView.userInteractionEnabled = YES;
            self.hasFirstOption = YES;
        }
         -(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
        {
            self.tableView.scrollEnabled = YES;
            self.tableView.userInteractionEnabled = YES;
            self.hasFirstOption = YES;
        }

随后看一下实现的效果:
https://upload-images.jianshu.io/upload_images/2100495-e4aefefee15c43e4.gif?imageMogr2/auto-orient/strip

说明地址:https://www.jianshu.com/p/bc13ee03cadc
