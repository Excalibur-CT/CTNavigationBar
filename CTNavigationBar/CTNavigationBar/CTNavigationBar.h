//
//  CTNavigationBar.h
//  CTNavigationBar
//
//  Created by Admin on 2016/11/24.
//  Copyright © 2016年 vjwealth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTNavigationBar : UINavigationBar

/*
 *  set the bar backgroundColor, default is project UINavigationBar backgroundColor
 */
@property (nonatomic, strong)UIColor * backgroundColor;

/*
 *  set the bar backgroundColor alpha, default is 1.0
 */
@property (nonatomic, assign)CGFloat barAlpha;

/*
 *  set the titleView is lucid, default is NO
 */
@property (nonatomic, assign)BOOL isTitleLucid;

/*
 *  set the bar title
 */
@property (nonatomic, copy) NSString * title;

/*
 *  set the bar title color
 */
@property (nonatomic, copy) UIColor * titleColor;

/*
 *  set the left Navigationbar button item
 */
@property (nonatomic, readwrite)UIBarButtonItem * leftBarButtonItem;

/*
 *  set the right Navigationbar button item
 */
@property (nonatomic, readwrite)UIBarButtonItem * rightBarButtonItem;

/*
 *  是否显示导航条下面的横线默认 隐藏
 */
@property (nonatomic, assign)BOOL isHiddenShadowImage;

/*
 *  导航条下面横线的颜色
 */
@property (nonatomic, copy)UIColor * shadowImageColor;

/*
 *  instancetype with title
 */
- (instancetype)initWithTitle:(NSString *)title;

/*
 *  instancetype with  height and title
 */
- (instancetype)initWithHeight:(CGFloat)height
                         title:(NSString *)title;

/*
 *  改变导航条透明度
 *  param maxOffseY  导航条透明度变为1 时, scrollview (或者其子类) 最大偏移量 (contentOffSet.y)
 */
- (void)ct_barAlphaDidScroll:(UIScrollView *)scrollView
                  maxOffsetY:(CGFloat)offSetY;

- (void)ct_barAlphaDidScroll:(UIScrollView *)scrollView
                  maxOffsetY:(CGFloat)offSetY
               progressBlock:(void (^)(CTNavigationBar * bar, CGFloat ratio))block;

/*
 *  改变导航条高度, 最终变为0
 *  param originalSize  scrollview (或者其子类)初始化时的高度
 */
- (void)ct_translationDidScroll:(UIScrollView *)scrollView
                   originalSize:(CGSize)size;

/*
 *  改变颜色, 实现从一个颜色渐变过渡到另一个颜色
 *  param  toColor  导航条最终显示颜色
 *  param  offSetY  导航条渐变到ToColor时, scrollview (或者其子类) 最大偏移量 (contentOffSet.y)
 */
- (void)ct_colorGradDidScroll:(UIScrollView *)scrollView
                      toColor:(UIColor *)color
                   maxOffSetY:(CGFloat)offSetY;

/*
 *  改变颜色, 实现从一个颜色渐变过渡到另一个颜色
 *  param  toColor  导航条最终显示颜色
 *  param  offSetY  导航条渐变到ToColor时, scrollview (或者其子类) 最大偏移量 (contentOffSet.y)
 *  param  block     进度Block
 *
 */
- (void)ct_colorGradDidScroll:(UIScrollView *)scrollView
                      toColor:(UIColor *)color
                   maxOffSetY:(CGFloat)offSetY
                progressBlock:(void (^)(CTNavigationBar * bar, CGFloat ratio))block;


- (void)ct_addLeftButtonItem:(UIBarButtonItem *)item;

- (void)ct_addRightButtonItem:(UIBarButtonItem *)item;



- (void)ct_setLeftButtonItem:(void (^)(UIBarButtonItem * item))itemBlock

- (void)ct_setRightButtonItem:(void (^)(UIBarButtonItem * item))itemBlock




- (void)ct_setLeftButtonTitle:(NSString *)itemTitle
                       target:(id)target
                       action:(SEL)action;

- (void)ct_setRightButtonTitle:(NSString *)itemTitle
                        target:(id)target
                        action:(SEL)action;



- (void)ct_setLeftButtonTitle:(NSString *)itemTitle
                  actionBlock:(void (^)(CTNavigationBar * bar, UIBarButtonItem * item))block;

- (void)ct_setRightButtonTitle:(NSString *)itemTitle
                   actionBlock:(void (^)(CTNavigationBar * bar, UIBarButtonItem * item))block;;



- (void)ct_setLeftButtonImage:(UIImage *)itemImage
                       target:(id)target
                       action:(SEL)action;

- (void)ct_setRightButtonImage:(UIImage *)itemImage
                        target:(id)target
                        action:(SEL)action;



- (void)ct_setLeftButtonImage:(UIImage *)itemImage
                  actionBlock:(void (^)(CTNavigationBar * bar, UIBarButtonItem * item))block;

- (void)ct_setRightButtonImage:(UIImage *)itemImage
                   actionBlock:(void (^)(CTNavigationBar * bar, UIBarButtonItem * item))block;

@end
