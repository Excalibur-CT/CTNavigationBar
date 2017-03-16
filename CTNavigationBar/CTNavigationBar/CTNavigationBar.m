//
//  CTNavigationBar.m
//  CTNavigationBar
//
//  Created by Admin on 2016/11/24.
//  Copyright © 2016年 vjwealth. All rights reserved.
//

#import "CTNavigationBar.h"
#import <objc/runtime.h>

#define k_Shadow_Line_Height (1.0/[UIScreen mainScreen].scale)


const CGFloat k_NavigationBar_Height = 64.0f;

@interface UIImage (Color)

+ (UIImage *)ct_imageWithColor:(UIColor *)color size:(CGSize)size;

@end

@implementation UIImage (Color)

+ (UIImage *)ct_imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
@end


@interface CTNavigationBar ()

@property (nonatomic, strong)UINavigationItem * barItem;
@property (nonatomic, strong)CALayer * lineLayer;

@end


@implementation CTNavigationBar

@synthesize backgroundColor = _backgroundColor;

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setDefaultConfig];
}

#pragma mark - init method -
- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithHeight:CGRectGetHeight(frame) title:@""];
}

- (instancetype)initWithTitle:(NSString *)title
{
    return [self initWithHeight:k_NavigationBar_Height title:title];
}

- (instancetype)initWithHeight:(CGFloat)height title:(NSString *)title
{
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    self = [super initWithFrame:CGRectMake(0, 0, screenSize.width, height)];
    if (self) {
        self.title = title;
        [self setDefaultConfig];
    }
    return self;
}

#pragma mark - 

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self adjustBarBackgroundColor];
}

- (void)setTitleColor:(UIColor *)titleColor
{
    if (titleColor != nil)
    {
        NSMutableDictionary * dict = [@{} mutableCopy];
        if (self.titleTextAttributes) {
            [dict addEntriesFromDictionary:self.titleTextAttributes];
        }
        [dict addEntriesFromDictionary:@{NSForegroundColorAttributeName:titleColor}];
        self.titleTextAttributes = dict;
    }
}

#pragma mark - private method -
- (void)setDefaultConfig
{
    self.barItem = [[UINavigationItem alloc] initWithTitle:self.title];
    [self setItems:@[_barItem]];

    self.barAlpha = 1;
    self.isTitleLucid = NO;
    [self setShadowImage:[UIImage new]];
    [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
}

- (void)adjustBarBackgroundColor
{
    if (self.isTitleLucid)
    {
        UIView *titleView = [self valueForKey:@"_titleView"];
        titleView.alpha = self.barAlpha;
    }
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isMemberOfClass:NSClassFromString(@"_UIBarBackground")])
        {
            obj.backgroundColor = [self.backgroundColor colorWithAlphaComponent:self.barAlpha];
        }
    }];
}

- (void)adjustLeftRightViewsWithAlpha:(CGFloat)alpha
{
    [[self valueForKey:@"_leftViews"] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger i, BOOL *stop) {
        view.alpha = alpha;
    }];
    
    [[self valueForKey:@"_rightViews"] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger i, BOOL *stop) {
        view.alpha = alpha;
    }];
}

- (void)adjustFrameOfScrollView:(UIScrollView *)scrollView size:(CGSize)size offsetY:(CGFloat)offsetY
{
    if (scrollView)
    {
        scrollView.frame = CGRectMake(0, 64-offsetY, size.width, size.height+offsetY);
    }
}

- (void)ct_barAlphaDidScroll:(UIScrollView *)scrollView
                  maxOffsetY:(CGFloat)maxY
{
    [self ct_barAlphaDidScroll:scrollView maxOffsetY:maxY progressBlock:nil];
}

- (void)ct_barAlphaDidScroll:(UIScrollView *)scrollView
                  maxOffsetY:(CGFloat)maxY
               progressBlock:(void (^)(CTNavigationBar * bar, CGFloat ratio))block
{
    if (![scrollView isKindOfClass:[UIScrollView class]])
    {
        return;
    }
    maxY = fminf(140,fmaxf(maxY, 84));
    CGFloat offsetY = scrollView.contentOffset.y - 20;
    if (offsetY >= maxY)
    {
        self.barAlpha = 1;
    }
    else if (offsetY > 0 && offsetY < maxY)
    {
        self.barAlpha = offsetY/maxY;
    }
    else
    {
        self.barAlpha = 0;
    }
    if (block) {
        block(self, self.barAlpha);
    }
}

#pragma mark - Translation -

- (void)ct_translationDidScroll:(UIScrollView *)scrollView
                   originalSize:(CGSize)size;
{
    if (![scrollView isKindOfClass:[UIScrollView class]])
    {
        return;
    }
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > 0)
    {
        if (offsetY >= 44)
        {
            self.transform = CGAffineTransformMakeTranslation(0, -44);
            [self adjustLeftRightViewsWithAlpha:0];
            ((UIView *)[self valueForKey:@"_titleView"]).alpha = 0;
            [self adjustFrameOfScrollView:scrollView size:size offsetY:44];
        }
        else
        {
            self.transform = CGAffineTransformMakeTranslation(0, (-offsetY));
            CGFloat alpha = (1-offsetY/44.0f);
            [self adjustLeftRightViewsWithAlpha:alpha];
            ((UIView *)[self valueForKey:@"_titleView"]).alpha = alpha;
            [self adjustFrameOfScrollView:scrollView size:size offsetY:offsetY];
        }
    }
    else
    {
        self.transform = CGAffineTransformMakeTranslation(0, 0);
        [self adjustLeftRightViewsWithAlpha:1];
        ((UIView *)[self valueForKey:@"_titleView"]).alpha = 1;
        [self adjustFrameOfScrollView:scrollView size:size offsetY:0];
    }
}

- (void)ct_colorGradDidScroll:(UIScrollView *)scrollView
                      toColor:(UIColor *)color
                   maxOffSetY:(CGFloat)offSetY
{
    [self ct_colorGradDidScroll:scrollView toColor:color maxOffSetY:offSetY progressBlock:nil];
}

- (void)ct_colorGradDidScroll:(UIScrollView *)scrollView
                      toColor:(UIColor *)color
                   maxOffSetY:(CGFloat)offSetY
                progressBlock:(void (^)(CTNavigationBar * bar, CGFloat ratio))block
{
    if (![scrollView isKindOfClass:[UIScrollView class]])
    {
        return;
    }
    CGFloat offY = scrollView.contentOffset.y;
    CGFloat ratio = offY / offSetY;
    UIColor * bckColor = [self colorFrom:self.backgroundColor toColor:color ratio:ratio];
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isMemberOfClass:NSClassFromString(@"_UIBarBackground")])
        {
            obj.backgroundColor = bckColor;
        }
    }];
    if (block) {
        block(self, ratio);
    }
}

- (UIColor *)colorFrom:(UIColor *)fromColor toColor:(UIColor *)toColor ratio:(CGFloat)ratio
{
    if (ratio <= 0)
    {
        return fromColor;
    }
    else if (ratio >=1 )
    {
        return toColor;
    }
    else
    {
        CGFloat o_r, o_g , o_b, o_a;
        CGFloat t_r, t_g , t_b, t_a;
        CGFloat r_r, r_g , r_b, r_a;
        
        [fromColor getRed:&o_r green:&o_g blue:&o_b alpha:&o_a];
        [toColor   getRed:&t_r green:&t_g blue:&t_b alpha:&t_a];
        
        r_r = o_r + (t_r - o_r)*ratio;
        r_g = o_g + (t_g - o_g)*ratio;
        r_b = o_b + (t_b - o_b)*ratio;
        r_a = o_a + (t_a - o_a)*ratio;

        return [UIColor colorWithRed:r_r green:r_g blue:r_b alpha:r_a];
    }
}
#pragma mark - barButtonItem -
- (void)ct_addLeftButtonItem:(UIBarButtonItem *)item
{
    if (self.barItem.leftBarButtonItems == nil ||
        self.barItem.leftBarButtonItems.count == 0)
    {
        self.barItem.leftBarButtonItem = item;
    }
    else
    {
        if (item != nil)
        {
            NSMutableArray * itemAry = [self.barItem.leftBarButtonItems mutableCopy];
            [itemAry addObject:item];
            self.barItem.leftBarButtonItems = itemAry;
        }
    }
}

- (void)ct_addRightButtonItem:(UIBarButtonItem *)item
{
    if (self.barItem.rightBarButtonItems == nil ||
        self.barItem.rightBarButtonItems.count == 0)
    {
        self.barItem.rightBarButtonItem = item;
    }
    else
    {
        if (item != nil)
        {
            NSMutableArray * itemAry = [self.barItem.leftBarButtonItems mutableCopy];
            [itemAry addObject:item];
            self.barItem.rightBarButtonItems = itemAry;
        }
    }
}

- (void)setLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem
{
    self.barItem.leftBarButtonItem = leftBarButtonItem;
}

- (void)setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem
{
    self.barItem.rightBarButtonItem = rightBarButtonItem;
}

- (UIBarButtonItem *)leftBarButtonItem
{
    return self.barItem.leftBarButtonItem;
}

- (UIBarButtonItem *)rightBarButtonItem
{
    return self.barItem.rightBarButtonItem;
}

- (void)ct_setLeftButtonItem:(void (^)(UIBarButtonItem * item))itemBlock
{
    UIBarButtonItem * barItem = [[UIBarButtonItem alloc] init];
    barItem.style = UIBarButtonItemStylePlain;
    if (itemBlock) {
        itemBlock(barItem);
    }
    self.barItem.leftBarButtonItem = barItem;

}

- (void)ct_setRightButtonItem:(void (^)(UIBarButtonItem * item))itemBlock
{
    UIBarButtonItem * barItem = [[UIBarButtonItem alloc] init];
    barItem.style = UIBarButtonItemStylePlain;
    if (itemBlock) {
        itemBlock(barItem);
    }
    self.barItem.rightBarButtonItem = barItem;
}

- (void)ct_setLeftButtonTitle:(NSString *)itemTitle
                       target:(id)target
                       action:(SEL)action
{
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithTitle:itemTitle style:UIBarButtonItemStylePlain target:target action:action];
    self.barItem.leftBarButtonItem = item;
}

- (void)ct_setRightButtonTitle:(NSString *)itemTitle
                        target:(id)target
                        action:(SEL)action
{
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithTitle:itemTitle style:UIBarButtonItemStylePlain target:target action:action];
    self.barItem.rightBarButtonItem = item;
}

- (void)ct_setLeftButtonTitle:(NSString *)itemTitle
                  actionBlock:(void (^)(CTNavigationBar * bar,UIBarButtonItem * item))block
{
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithTitle:itemTitle style:UIBarButtonItemStylePlain target:self action:@selector(ct_leftBarItemAction:)];
    objc_setAssociatedObject(self, @selector(ct_leftBarItemAction:), block, OBJC_ASSOCIATION_COPY);
    self.barItem.leftBarButtonItem = item;
}

- (void)ct_setRightButtonTitle:(NSString *)itemTitle actionBlock:(void (^)(CTNavigationBar * bar,UIBarButtonItem * item))block
{
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithTitle:itemTitle style:UIBarButtonItemStylePlain target:self action:@selector(ct_rightBarItemAction:)];
    objc_setAssociatedObject(self, @selector(ct_rightBarItemAction:), block, OBJC_ASSOCIATION_COPY);
    self.barItem.rightBarButtonItem = item;
}

- (void)ct_setLeftButtonImage:(UIImage *)image target:(id)target action:(SEL)action
{
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:target action:action];
    self.barItem.leftBarButtonItem = item;
}

- (void)ct_setRightButtonImage:(UIImage *)image target:(id)target action:(SEL)action
{
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:target action:action];
    self.barItem.rightBarButtonItem = item;
}

- (void)ct_setLeftButtonImage:(UIImage *)image
                  actionBlock:(void (^)(CTNavigationBar * bar,UIBarButtonItem * item))block
{
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(ct_leftBarItemAction:)];
    objc_setAssociatedObject(self, @selector(ct_leftBarItemAction:), block, OBJC_ASSOCIATION_COPY);
    self.barItem.leftBarButtonItem = item;
}

- (void)ct_setRightButtonImage:(UIImage *)image
                   actionBlock:(void (^)(CTNavigationBar * bar,UIBarButtonItem * item))block
{
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(ct_rightBarItemAction:)];
    objc_setAssociatedObject(self, @selector(ct_rightBarItemAction:), block, OBJC_ASSOCIATION_COPY);
    self.barItem.rightBarButtonItem = item;
}

#pragma mark - custom method -

- (void)ct_leftBarItemAction:(UIBarButtonItem *)item
{
    void (^block)(CTNavigationBar * bar,UIBarButtonItem * item) = objc_getAssociatedObject(self, _cmd);
    if (block) {
        block(self,item);
    }
}

- (void)ct_rightBarItemAction:(UIBarButtonItem *)item
{
    void (^block)(CTNavigationBar * bar,UIBarButtonItem * item) = objc_getAssociatedObject(self, _cmd);
    if (block) {
        block(self,item);
    }
}

#pragma mark - getter -
- (UIColor *)backgroundColor
{
    if (!_backgroundColor) {
        __weak typeof (self) weakSelf = self;
        
        if ([[UINavigationBar appearance] barTintColor])
        {
            _backgroundColor = [[UINavigationBar appearance] barTintColor];
        }
        else
        {
            [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isMemberOfClass:NSClassFromString(@"_UIBarBackground")])
                {
                    weakSelf.backgroundColor = obj.backgroundColor;
                }
            }];
        }
    }
    return _backgroundColor;
}

- (CALayer *)lineLayer
{
    if (_lineLayer == nil)
    {
        _lineLayer = [CALayer layer];
        _lineLayer.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3].CGColor;
        _lineLayer.frame = CGRectMake(0, CGRectGetHeight(self.bounds), CGRectGetWidth(self.frame), k_Shadow_Line_Height);
        [self.layer insertSublayer:_lineLayer atIndex:1];
    }
    return _lineLayer;
}

#pragma mark - setter -
- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    if (_backgroundColor != backgroundColor) {
        _backgroundColor = backgroundColor;
        [self adjustBarBackgroundColor];
    }
}

- (void)setBarAlpha:(CGFloat)barAlpha
{
    if (_barAlpha != barAlpha)
    {
        _barAlpha = barAlpha;
        [self adjustBarBackgroundColor];
    }
}

- (void)setTitle:(NSString *)title
{
    if (![_title isEqualToString:title]) {
        _title = title;
        self.barItem.title = _title;
    }
}

- (void)setIsHiddenShadowImage:(BOOL)isHiddenShadowImage
{
    _isHiddenShadowImage = isHiddenShadowImage;
    self.lineLayer.hidden = isHiddenShadowImage;
}

- (void)setShadowImageColor:(UIColor *)shadowImageColor
{
    if (_shadowImageColor != shadowImageColor)
    {
        _shadowImageColor = shadowImageColor;
        self.lineLayer.backgroundColor = shadowImageColor.CGColor;
    }
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

@end
