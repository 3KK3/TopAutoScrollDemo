//
//  ViewController.m
//  TopAutoScrollDemo
//
//  Created by YZY on 2018/12/13.
//  Copyright © 2018 https://github.com/3KK3. All rights reserved.
//

#import "ViewController.h"
#import "UIView+YYAdd.h"

static CGFloat const FloatingViewInitilTop = 50;     /// 浮动view顶部初始距离
static CGFloat const FloatingViewMaxOffsetY = 30;   /// 浮动view顶部最大便宜距离

static CGFloat const FloatingViewMinH = 40;         /// 浮动view最小高度

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
{
    CGSize _floatingViewInitialSize; /// 浮动view初始size
}
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _floatingViewInitialSize = self.topView.bounds.size;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue1 reuseIdentifier: @"cell"];
        cell.backgroundColor = [self randomColor];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}


- (UIColor *)randomColor {
    
    return [UIColor colorWithRed: arc4random() % 255 / 255.0 green: arc4random() % 255 / 255.0 blue: arc4random() % 255 / 255.0 alpha: 0.3];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView != self.tableView) {
        return;
    }
    
    [self handleScrollAnim];
    
}

- (void)handleScrollAnim {
    
    CGFloat offsetY = self.tableView.contentOffset.y;
    
    /// 如果偏移量小于0  catch下拉刷新样式情况
    if (offsetY < 0) {
        /// 此时如果控件没有复原 强制复原位置
        if (self.topView.top != FloatingViewInitilTop) {
            
            self.topView.top = FloatingViewInitilTop ;
            self.topView.size = _floatingViewInitialSize;
        }
        return;
    }
    
    /// 如果偏移量大于最大偏移量  catch快速向下滑动情况
    if (offsetY > FloatingViewMaxOffsetY) {
        /// 把控件置于最大改变位置
        
        self.topView.top = FloatingViewInitilTop - FloatingViewMaxOffsetY;
        self.topView.size = [self floatingViewMinSize];
        return;
    }
    /// 计算控件top位置
    CGFloat yChange = FloatingViewInitilTop - offsetY;
    self.topView.top = yChange;
    
    /// 控件宽度最大改变量
    CGFloat widthTotalChange = _floatingViewInitialSize.width - [self floatingViewMinSize].width;
    /// 控件高度最大改变量
    CGFloat heightTotalChange = _floatingViewInitialSize.height - [self floatingViewMinSize].height;
    
    /// 计算滑动offsetY距离时，控件宽度改变量
    CGFloat widthChangeValue = widthTotalChange * offsetY / FloatingViewMaxOffsetY;
    
    /// 计算滑动offsetY距离时，控件高度改变量
    CGFloat heightChangeValue = heightTotalChange * offsetY / FloatingViewMaxOffsetY;
    
    /// 计算控件应该展示的size
    self.topView.size = CGSizeMake(_floatingViewInitialSize.width - widthChangeValue,
                                   _floatingViewInitialSize.height - heightChangeValue);
}

- (CGSize)floatingViewMinSize {
    CGFloat imgMinW = _floatingViewInitialSize.width  * FloatingViewMinH / _floatingViewInitialSize.height;
    return CGSizeMake(imgMinW, FloatingViewMinH);
}

@end
