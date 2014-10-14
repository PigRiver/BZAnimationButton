//
//  BZAAnimationButton.h
//  BZAnimationButtonDemo
//
//  Created by Bruce on 14-8-1.
//  Copyright (c) 2014年 com.Bruce.AnimationButtonDemo. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum  {
    AnimationButtonStyleArrowRight = 0,
    AnimationButtonStyleArrowLeft,
    AnimationButtonStyleThreeLines,
    AnimationButtonStyleX,
    AnimationButtonStyleAdd,
    AnimationButtonStyleDown,
    AnimationButtonStyleUp,
    AnimationButtonStyleLeft,
    AnimationButtonStyleRight,
    AnimationButtonStyleAddWithCircle,
    AnimationButtonStyleXWithCircle,
} AnimationButtonStyle;

@interface BZAAnimationButton : UIButton

@property (nonatomic) AnimationButtonStyle buttonStyle;
@property (nonatomic) CGFloat lineLength;

- (void)setStyle:(AnimationButtonStyle)buttonStyle withAnimation:(BOOL)animate;
- (void)setLineColor:(UIColor *)color;
- (void)setLineWidth:(CGFloat)width;
- (void)setLayerLineLength:(CGFloat)length;

@end
