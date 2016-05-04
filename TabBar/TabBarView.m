//
//  TabBarView.m
//  sichuangmingyi
//
//  Created by ZhouXu on 25/4/16.
//  Copyright © 2016年 sichuangmingyi. All rights reserved.
//

#import "TabBarView.h"
#import "ColorUtility.h"

#define MAIN_ACTIVE_COLOR           [ColorUtility colorWithHexString:@"#00b4c9"]   //  背景颜色额色值
#define RGBCOLOR(r,g,b)             [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0f]
#define CUSTOM_NAVBAR_COLOR         MAIN_ACTIVE_COLOR
#define RGBACOLOR(r,g,b,a)          [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

@implementation TabBarViewButton


- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    UIImage* image = [self imageForState:UIControlStateNormal];
    if (image != nil) {
        CGFloat width = image.size.width;
        CGFloat height = image.size.height;
        
        CGRect rc = CGRectMake((contentRect.size.width - width) / 2.0f, (contentRect.size.height - height - 16.0f) / 2.0f, width, height);
        return rc;
    }
    
    return [super imageRectForContentRect:contentRect];
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGRect rc = CGRectMake(0.0f, contentRect.size.height - 20.0f, contentRect.size.width, 14.0f);
    return rc;
}

//- (void)resetBadgeNumber:(NSInteger)number
//{
//    NSString* badge = [NSString stringWithFormat:@"%ld", (long)number];
//    if (number > 99) {
//        badge = @"99+";
//    }
//    else if (number <= 0) {
//        badge = @"";
//    }
//    if(_badgeLabel == nil){
//        self.badgeLabel = [ViewCreatorHelper createLabelWithTitle:@""
//                                                             font:[UIFont systemFontOfSize:10.0f]
//                                                            frame:CGRectMake(60, 4, 18.0f, 18.0f)
//                                                        textColor:[UIColor whiteColor]
//                                                    textAlignment:NSTextAlignmentCenter];
//        if ([UIScreen mainScreen].bounds.size.width == 320)
//        {
//            self.badgeLabel.frame = CGRectMake(48, 4, 18.0f, 18.0f);
//        }
//        self.badgeLabel.layer.cornerRadius = 9.0f;
//        self.badgeLabel.clipsToBounds = YES;
//        self.badgeLabel.backgroundColor = BADGE_COLOR;
//        self.badgeLabel.hidden = YES;
//        [self addSubview:self.badgeLabel];
//    }
//    _badgeLabel.text = badge;
//    
//    if (badge.length > 0) {
//        if (badge.length == 1) {
//            self.badgeLabel.width = 18.0f;
//        }
//        else if(badge.length == 2) {
//            self.badgeLabel.width = 22.0f;
//        }
//        else if(badge.length == 3) {
//            self.badgeLabel.width = 28.0f;
//        }
//        else {
//            self.badgeLabel.width = 32.0f;
//        }
//        self.badgeLabel.hidden = NO;
//    }
//    else {
//        self.badgeLabel.hidden = YES;
//    }
//
//    if(number < 0)
//    {
////        self.badgeLabel.width = 12.0f;
////        self.badgeLabel.height = 12.0f;
////        self.badgeLabel.layer.cornerRadius = 6.0f;
//        self.badgeLabel.width = 8.0f;
//        self.badgeLabel.height = 8.0f;
//        self.badgeLabel.layer.cornerRadius = 4.0f;
//        self.badgeLabel.hidden = NO;
//    }
//}

@end


@interface TabBarView()

@property (nonatomic, assign) NSInteger buttonCount;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) CGFloat buttonWidth;

@property (nonatomic, strong) NSMutableArray* buttonArray;
@property (nonatomic, strong) UIView* lineView;

@property (nonatomic, strong) NSArray* iconArray;
@property (nonatomic, strong) NSArray* iconHlArray;

@property (nonatomic, weak) UIButton* currentButton;
@property (nonatomic, strong) NSTimer* changeTimer;

@end

@implementation TabBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _currentIndex = -1;
        self.backgroundColor = RGBCOLOR(248.0f, 248.0f, 248.0f);
        _lineView = [self lineWithWidth:frame.size.width];
    
        [self addSubview:_lineView];
    }
    return self;
}

- (UIView*)lineWithWidth:(CGFloat)width
{
    CGFloat screenScale = [UIScreen mainScreen].scale;
    CGFloat h = 1.0f;
    if (screenScale > 0.0f) {
        h = 1.0f / screenScale;
    }
    
    CGRect rc = CGRectMake(0.0f, 0.0f, width, h);
    UIView* lineView = [[UIView alloc] initWithFrame:rc];
    lineView.backgroundColor = [ColorUtility colorWithHexString:@"#DCDCDC"];
    return lineView;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect rc = self.bounds;
    
    NSInteger count = [self.buttonArray count];
    if (count <= 0) {
        return;
    }
    
    self.buttonWidth = self.frame.size.width / count;
    rc.size.width = self.buttonWidth;
    rc.origin.y += 3;
    for (UIButton* button in self.buttonArray) {
        button.frame = rc;
        rc.origin.x += self.buttonWidth;
    }
}

- (void)setTitleArray:(NSArray*)titleArray
            iconArray:(NSArray*)iconArray
          iconHlArray:(NSArray*)iconHLArray
{
    if ([titleArray count] != [iconArray count] || [titleArray count] != [iconHLArray count]) {
//        DDLogInfo(@"ARRAY COUNT ERROR !!!");
        return;
    }
    if ([self.buttonArray count] > 0) {
        return;
    }
    
    self.iconArray = [NSArray arrayWithArray:iconArray];
    self.iconHlArray = [NSArray arrayWithArray:iconHLArray];
    
    NSInteger count = [titleArray count];
    CGRect rc = CGRectMake(0.0f, 0.0f, 100.f, 30.0f);
    NSInteger tag = 0;
    self.buttonArray = [NSMutableArray arrayWithCapacity:count];
    for (NSString* title in titleArray) {
        TabBarViewButton* button = [TabBarViewButton buttonWithType:UIButtonTypeCustom];
        button.frame = rc;
        
        NSString* icon = [iconArray objectAtIndex:tag];
        UIImage* buttonImg = [UIImage imageNamed:icon];
        [button setImage:buttonImg forState:UIControlStateNormal];
        [button setImage:buttonImg forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(buttonStart:) forControlEvents:UIControlEventTouchDown];
        [button addTarget:self action:@selector(toucheRepeat:) forControlEvents:UIControlEventTouchDownRepeat];//双击按钮
        [button addTarget:self action:@selector(buttonEnd:) forControlEvents:UIControlEventTouchDownRepeat];

        [button addTarget:self action:@selector(buttonEnd:) forControlEvents:UIControlEventTouchDragInside];
        [button addTarget:self action:@selector(buttonEnd:) forControlEvents:UIControlEventTouchDragOutside];
        [button addTarget:self action:@selector(buttonEnd:) forControlEvents:UIControlEventTouchDragEnter];
        [button addTarget:self action:@selector(buttonEnd:) forControlEvents:UIControlEventTouchDragExit];
        [button addTarget:self action:@selector(buttonEnd:) forControlEvents:UIControlEventTouchUpOutside];
        [button addTarget:self action:@selector(buttonEnd:) forControlEvents:UIControlEventTouchCancel];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:RGBCOLOR(138, 138, 138) forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:10.0f];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.tag = tag;
        tag++;
        
        [self.buttonArray addObject:button];
        [self addSubview:button];
    }
    
    [self setNeedsLayout];
}

/**
 *  双击按钮
 *
 *  @param sender 按钮
 */
- (void)toucheRepeat:(id)sender
{
    __block UILabel *tipLable = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    tipLable.text = @"双击了";
    tipLable.textColor = [UIColor blackColor];
    [[UIApplication sharedApplication].keyWindow addSubview:tipLable];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tipLable removeFromSuperview];
    });
    
//    DDLogInfo(@"++++++repeat");
    if (self.changeTimer != nil) {
        [self.changeTimer invalidate];
        self.changeTimer = nil;
    }
    if (![sender isKindOfClass:[UIButton class]]) {
        return;
    }
    UIButton* button = (UIButton*)sender;
    NSInteger index = button.tag;
    
    if (index == 0)
    {
        if (_touchRepeatBlock)
        {
            _touchRepeatBlock(index);
        }
    }
}

- (void)selectIndex:(NSInteger)index animated:(BOOL)animated
{
    if (index >= [self.buttonArray count]) {
        return;
    }
    
    if (self.currentIndex == index) {
        return;
    }
    
    if (self.currentButton != nil) {
        [self.currentButton setTitleColor:RGBCOLOR(138, 138, 138) forState:UIControlStateNormal];
        if (self.currentIndex < [self.iconArray count]) {
            NSString* iconName = [self.iconArray objectAtIndex:self.currentIndex];
            UIImage* buttonImg = [UIImage imageNamed:iconName];
            [self.currentButton setImage:buttonImg forState:UIControlStateNormal];
            [self.currentButton setImage:buttonImg forState:UIControlStateHighlighted];
        }
    }
    
    self.currentIndex = index;
    if (self.currentIndex < [self.buttonArray count]) {
        self.currentButton = [self.buttonArray objectAtIndex:index];
        [self.currentButton setTitleColor:MAIN_ACTIVE_COLOR forState:UIControlStateNormal];
        if (self.currentIndex < [self.iconHlArray count]) {
            NSString* iconName = [self.iconHlArray objectAtIndex:self.currentIndex];
            UIImage* buttonImg = [UIImage imageNamed:iconName];
            [self.currentButton setImage:buttonImg forState:UIControlStateNormal];
            [self.currentButton setImage:buttonImg forState:UIControlStateHighlighted];
        }
    }
}

- (void)resetBadgeCount:(NSInteger)count onIndex:(NSInteger)index
{
    if (index >= [self.buttonArray count]) {
        return;
    }
    
    TabBarViewButton* button = [self.buttonArray objectAtIndex:index];
    if ([button isKindOfClass:[TabBarViewButton class]]) {
//        [button resetBadgeNumber:count];
    }
}

- (void)buttonEnd:(id)sender
{
    if (self.changeTimer != nil) {
        [self.changeTimer invalidate];
        self.changeTimer = nil;
    }
}

- (void)buttonStart:(id)sender
{
    if (self.changeTimer != nil) {
        [self.changeTimer invalidate];
    }
    if (![sender isKindOfClass:[UIButton class]]) {
        return;
    }
    UIButton* button = (UIButton*)sender;
    NSInteger index = button.tag;
    self.changeTimer = [NSTimer scheduledTimerWithTimeInterval:0.8f
                                                        target:self
                                                      selector:@selector(changeTimerAction:)
                                                      userInfo:@(index)
                                                       repeats:NO];
}

- (void)buttonPressed:(id)sender
{
    if (self.changeTimer != nil) {
        [self.changeTimer invalidate];
        self.changeTimer = nil;
    }
    if (![sender isKindOfClass:[UIButton class]]) {
        return;
    }
    UIButton* button = (UIButton*)sender;
    NSInteger index = button.tag;
    
    [self buttonPressedWithTag:index];
}

- (void)changeTimerAction:(NSTimer*)timer
{
    if ([timer.userInfo isKindOfClass:[NSNumber class]]) {
        NSNumber* tag = (NSNumber*)timer.userInfo;
        [self buttonPressedWithTag:tag.integerValue];
    }
    self.changeTimer = nil;
}

- (void)buttonPressedWithTag:(NSInteger)tag
{
    [self selectIndex:tag animated:YES];
    
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectedIndex:)]) {
        [self.delegate tabBar:self didSelectedIndex:tag];
    }
}

@end
