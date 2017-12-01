//
//  UIView+DUACategory.m
//  OCWithJS
//
//  Created by mengminduan on 2017/11/30.
//  Copyright © 2017年 mengminduan. All rights reserved.
//

#import "UIView+DUACategory.h"

@implementation UIView (DUACategory)

- (void)setDua_x:(CGFloat)dua_x
{
    CGRect frame = self.frame;
    frame.origin.x = dua_x;
    self.frame = frame;
}


- (void)setDua_y:(CGFloat)dua_y
{
    CGRect frame = self.frame;
    frame.origin.y = dua_y;
    self.frame = frame;
}

- (CGFloat)dua_x
{
    return self.frame.origin.x;
}

- (CGFloat)dua_y
{
    return self.frame.origin.y;
}

- (void)setDua_centerX:(CGFloat)dua_centerX
{
    CGPoint center = self.center;
    center.x = dua_centerX;
    self.center = center;
}

- (CGFloat)dua_centerX
{
    return self.center.x;
}

- (void)setDua_centerY:(CGFloat)dua_centerY
{
    CGPoint center = self.center;
    center.y = dua_centerY;
    self.center = center;
}

- (CGFloat)dua_centerY
{
    return self.center.y;
}

- (void)setDua_width:(CGFloat)dua_width
{
    CGRect frame = self.frame;
    frame.size.width = dua_width;
    self.frame = frame;
}


- (void)setDua_height:(CGFloat)dua_height
{
    CGRect frame = self.frame;
    frame.size.height = dua_height;
    self.frame = frame;
}

- (CGFloat)dua_height
{
    return self.frame.size.height;
}

- (CGFloat)dua_width
{
    
    return self.frame.size.width;
}

- (void)setDua_size:(CGSize)dua_size
{
    CGRect frame = self.frame;
    frame.size = dua_size;
    self.frame = frame;
}

- (CGSize)dua_size
{
    return self.frame.size;
}

- (void)setDua_origin:(CGPoint)dua_origin
{
    
    CGRect frame = self.frame;
    frame.origin = dua_origin;
    self.frame = frame;
}

- (CGPoint)dua_origin
{
    return self.frame.origin;
}
@end
