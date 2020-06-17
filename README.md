# FQSlidTableView
实现苹果系统滑动效果

整体思路:

1.给containerView视图添加手势
2.监听tableView偏移
3.根据偏移做不同的判断

定义相关BOOL属性:
hasContainsTopContent:判断最初的手势落点是否在topContentView上.还是tableView上
hasOptionTable:记录tableView当前的状态.若为YES.则可操作tableView.若为NO.则不可操作tableView.且禁用状态
hasFirstOption:记录是否开始操作.

核心思想:

1.如果是topContentView上.则tableView不做滚动. containerView视图整体的上或者下偏移.即hasOptionTable = NO.

2.如果是操作在tableView上.则依据之前的逻辑.即根据hasFirstOption == YES时.进一步判断
a.如果tableView第一次的偏移值大于0.则是操作tableView.主要控制tableView.即hasOptionTable = YES.
b.如果tableView第一次的偏移值小于0.则禁用tableView的滚动事件.让整体containerView视图偏移.即hasOptionTable = NO.
i.如果计算出的偏移后的y值小于最小值kTableViewOpenY时.则让containerView.y = kTableViewOpenY;并且让tableView做对应的偏移
ii.如果计算出的偏移后的y值大于最小值kTableViewOpenY时.则让containerView.y = 偏移值后的值;并且让tableView的偏移为CGPointZero

详细了解连接:https://www.jianshu.com/p/bc13ee03cadc
