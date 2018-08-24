//
//  ViewController.m
//  SegmentPage
//
//  Created by 吴丹 on 2018/8/24.
//  Copyright © 2018 forever.love. All rights reserved.
//

#import "ViewController.h"
// 示例Controller
#import "TestViewController.h"
#import "TestTableViewController.h"

#define SEG_SCREEN_WIDTH UIScreen.mainScreen.bounds.size.width

@interface ViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSMutableArray *vcArray;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation ViewController

#pragma mark =============== Getter && Setter ===============
- (UISegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:self.titleArray];
        // 默认选择第一个
        _segmentedControl.selectedSegmentIndex = 0;
        // 隐藏自带的边框
        _segmentedControl.tintColor = UIColor.clearColor;
        NSDictionary *selectedDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor redColor], NSForegroundColorAttributeName,[UIFont systemFontOfSize:20],NSFontAttributeName,nil];
        [_segmentedControl setTitleTextAttributes:selectedDic forState:UIControlStateSelected];
        NSDictionary *normalDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:15],NSFontAttributeName,nil];
        [_segmentedControl setTitleTextAttributes:normalDic forState:UIControlStateNormal];
        // 添加点击事件
        [_segmentedControl addTarget:self action:@selector(segmentedControlChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControl;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.frame = self.view.frame;
        _scrollView.pagingEnabled = true;
        _scrollView.showsHorizontalScrollIndicator = false;
        _scrollView.contentSize = CGSizeMake(SEG_SCREEN_WIDTH * self.titleArray.count, 0);
        // 默认加载第一个VC视图
        UIViewController *vc = self.vcArray[0];
        [self.scrollView addSubview:vc.view];
    }
    return _scrollView;
}

#pragma mark =============== LifeCycle ===============
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self.navigationItem setTitleView:self.segmentedControl];
    [self.view addSubview:self.scrollView];
}

#pragma mark =============== 加载默认数据 ===============
- (void)initData {
    self.titleArray = @[@"我的",@"音乐馆",@"发现"];
    
    NSArray *vArray = @[@"TestViewController",@"TestTableViewController",@"TestViewController"];
    
    self.vcArray = [NSMutableArray array];
    for (int i = 0; i < vArray.count; i++) {
        Class class = NSClassFromString(vArray[i]);
        UIViewController *vc = [[class alloc] init];
        vc.view.frame = CGRectMake(SEG_SCREEN_WIDTH * i, 0, SEG_SCREEN_WIDTH, self.view.frame.size.height);
        [self.vcArray addObject:vc];
    }
}

#pragma mark =============== UISegmentedControl点击事件 ===============
- (void)segmentedControlChange:(UISegmentedControl *)sgementControl {    
    UIViewController *vc = self.vcArray[sgementControl.selectedSegmentIndex];
    [self.scrollView addSubview:vc.view];
    self.scrollView.contentOffset = CGPointMake(SEG_SCREEN_WIDTH * sgementControl.selectedSegmentIndex, 0);
}

#pragma mark =============== UIScrollViewDelegate ===============
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat contentOffsetX = scrollView.contentOffset.x;
    NSInteger index = contentOffsetX/SEG_SCREEN_WIDTH;
    UIViewController *vc = self.vcArray[index];
    [self.scrollView addSubview:vc.view];
    self.segmentedControl.selectedSegmentIndex = index;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
