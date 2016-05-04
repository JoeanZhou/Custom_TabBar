//
//  TabBarView.h
//  sichuangmingyi
//
//  Created by ZhouXu on 25/4/16.
//  Copyright © 2016年 sichuangmingyi. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface TabBarViewButton : UIButton

//  按钮上的提示红点(目前注释了)

//@property (nonatomic, strong) UILabel* badgeLabel;

//- (void)resetBadgeNumber:(NSInteger)number;

@end


@class TabBarView;

@protocol TabBarViewDelegate <NSObject>

- (void)tabBar:(TabBarView*)tabBar didSelectedIndex:(NSInteger)index;

@end

typedef void (^touchRepeatBlock)(NSInteger index);

@interface TabBarView : UIView

@property (nonatomic, copy) touchRepeatBlock touchRepeatBlock;

@property (nonatomic, weak) id<TabBarViewDelegate> delegate;

- (void)setTitleArray:(NSArray*)titleArray
            iconArray:(NSArray*)iconArray
          iconHlArray:(NSArray*)iconHLArray;

- (void)selectIndex:(NSInteger)index animated:(BOOL)animated;
- (void)resetBadgeCount:(NSInteger)count onIndex:(NSInteger)index;



// 外部调用
- (void)buttonPressedWithTag:(NSInteger)tag;

@end
