//
//  ViewController.m
//  CustomTabBar
//
//  Created by ZhouXu on 4/5/16.
//  Copyright © 2016年 sichuangmingyi. All rights reserved.
//

#import "ViewController.h"
#import "TabBarView.h"
#import "ViewController1.h"
#import "ViewController2.h"
#import "ViewController3.h"
#import "ViewController4.h"
@interface ViewController ()<TabBarViewDelegate>

@property (nonatomic, strong) TabBarView* tabView;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) UIView *currentView;


@end

static const NSInteger tabBarHeigh = 50;


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self addChildViewController:[[ViewController1 alloc] init]];
    [self addChildViewController:[[ViewController2 alloc] init]];
    [self addChildViewController:[[ViewController3 alloc] init]];
    [self addChildViewController:[[ViewController4 alloc] init]];
    
    //  创建Tabbar
    [self creatTabbar];
    [self showNewController:0 preIndex:-1];
}

- (void)creatTabbar
{
    self.tabView = [[TabBarView alloc] init];
    self.tabView.delegate = self;
    self.tabView.frame = CGRectMake(0, self.view.frame.size.height - tabBarHeigh, self.view.frame.size.width, tabBarHeigh);
    
    [self.tabView setTitleArray:@[@"首页", @"寻医",@"圈子", @"发现"]
                      iconArray:@[@"tab_chance", @"tab_chance", @"tab_chance", @"tab_chance"]
                    iconHlArray:@[@"tab_chance_pressed", @"tab_chance_pressed", @"tab_chance_pressed",@"tab_chance_pressed"]];
    
    [self.tabView selectIndex:self.currentIndex animated:NO];
    
    [self.view addSubview:self.tabView];
}

#pragma mark - TabBarViewDelegate
- (void)tabBar:(TabBarView*)tabBar didSelectedIndex:(NSInteger)index
{
    if (self.currentIndex ==  index )
        return;
    
    if (index < [self.childViewControllers count]) {
        if (index != self.currentIndex) {
            [self.currentView removeFromSuperview];
        }
        
        [self showNewController:index preIndex:self.currentIndex];
        self.currentIndex = index;
    }
}

- (void)showNewController:(NSInteger)index preIndex:(NSInteger)preIndex
{
    if (index < [self.childViewControllers count]) {
        UIViewController *vc = [self.childViewControllers objectAtIndex:index];
        vc.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - tabBarHeigh);
        [self.view addSubview:vc.view];
        self.currentView = vc.view;
    }
}
@end
