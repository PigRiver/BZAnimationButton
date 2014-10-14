//
//  BZAAnimationButton.m
//  BZAnimationButtonDemo
//
//  Created by Bruce on 14-8-1.
//  Copyright (c) 2014年 com.Bruce.AnimationButtonDemo. All rights reserved.
//

#import "BZAAnimationButton.h"
#import "BZAShapeLayerInfo.h"
#import <POP.h>

#define GOLDEN_RATIO 0.618
#define ANIMATIONDURATION 3.0f
#define ICONLENGTH self.frame.size.width < self.frame.size.height ? self.frame.size.width : self.frame.size.height

@interface BZAAnimationButton()

@property (strong, nonatomic) BZAShapeLayerInfo *circleLayer;
@property (strong, nonatomic) BZAShapeLayerInfo *lineLayer1;
@property (strong, nonatomic) BZAShapeLayerInfo *lineLayer2;
@property (strong, nonatomic) BZAShapeLayerInfo *lineLayer3;
@property (strong, nonatomic) NSArray *layerList;

@end

@implementation BZAAnimationButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initShapeLayer];
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        [self initShapeLayer];
    }
    
    return self;
}

- (void)initShapeLayer {
    self.circleLayer = [[BZAShapeLayerInfo alloc] initWithKeyName:@"circleLayer"];
    self.lineLayer1 = [[BZAShapeLayerInfo alloc] initWithKeyName:@"line1Layer"];
    self.lineLayer2 = [[BZAShapeLayerInfo alloc] initWithKeyName:@"line2Layer"];
    self.lineLayer3 = [[BZAShapeLayerInfo alloc] initWithKeyName:@"line3Layer"];
    
    self.layerList = [NSArray arrayWithObjects:self.circleLayer, self.lineLayer1, self.lineLayer2, self.lineLayer3, nil];
    
    [self.layerList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        CAShapeLayer *layer = [(BZAShapeLayerInfo *)obj shapeLayer];
        layer.fillColor = [UIColor clearColor].CGColor;
        layer.anchorPoint = CGPointMake(0.0, 0.0);
        layer.lineJoin = kCALineJoinRound;
        layer.lineCap = kCALineCapRound;
        layer.contentsScale = self.layer.contentsScale;
        layer.lineWidth = 4.0f;
        layer.strokeColor = [[UIColor greenColor] CGColor];
        [self.layer addSublayer:layer];
    }];
    
    self.lineLength = 0;
}

// offset记录从layer中心点到线的起点所需要的偏移量
- (void)addLineForPathWithLength:(CGFloat)length
                             andAngle:(CGFloat)angle
                  andStartPointOffset:(CGPoint)offset
                    andShapeLayerInfo:(BZAShapeLayerInfo *)layerInfo {
    [self addLineForPathWithLength:length andAngle:angle andOffset:offset andShapeLayerInfo:layerInfo isCenterOffSet:NO];
}

// offset记录从layer中心点到线的中心点所需要的偏移量
- (void)addLineForPathWithLength:(CGFloat)length
                             andAngle:(CGFloat)angle
                      andCenterOffset:(CGPoint)offset
                    andShapeLayerInfo:(BZAShapeLayerInfo *)layerInfo {
    [self addLineForPathWithLength:length andAngle:angle andOffset:offset andShapeLayerInfo:layerInfo isCenterOffSet:YES];
}


- (void)addLineForPathWithLength:(CGFloat)length
                             andAngle:(CGFloat)angle
                            andOffset:(CGPoint)offset
                    andShapeLayerInfo:(BZAShapeLayerInfo *)layerInfo
                       isCenterOffSet:(BOOL)isCenterOffset {
    CGMutablePathRef path = CGPathCreateMutable();
    
    layerInfo.lastLength = layerInfo.nextLength;
    layerInfo.nextLength = length;
    
    CGFloat angleX = cosf(angle);
    CGFloat angleY = sinf(angle);
    layerInfo.lastAngle = layerInfo.nextAngle;
    layerInfo.nextAngle = angle;
    
    layerInfo.lastPosition = layerInfo.shapeLayer.frame;
    CGPoint centerPoint;
    if (isCenterOffset) {
        centerPoint = CGPointMake(self.center.x + offset.x - self.frame.origin.x, self.center.y + offset.y - self.frame.origin.y);
    } else {
        CGPoint startPoint = CGPointMake(self.center.x + offset.x - self.frame.origin.x, self.center.y + offset.y - self.frame.origin.y);
        centerPoint = CGPointMake(startPoint.x + angleX * length / 2, startPoint.y + angleY * length / 2);
    }
    CGRect tempRect = layerInfo.shapeLayer.frame;
    tempRect.origin = centerPoint;
    layerInfo.shapeLayer.frame = tempRect;
    
    
    CGPathMoveToPoint(path, NULL, angleX * length / 2, angleY * length / 2);
    CGPathAddLineToPoint(path, NULL, -angleX * length / 2, -angleY * length / 2);
    
    layerInfo.shapeLayer.path = path;
}

- (void)addCircleForPathWithRadius:(CGFloat)radius
                        andOpacity:(CGFloat)opacity
                 andShapeLayerInfo:(BZAShapeLayerInfo *)layerInfo {
    layerInfo.lastLength = layerInfo.nextLength;
    layerInfo.nextLength = radius;
    layerInfo.lastOpacity = layerInfo.shapeLayer.opacity;
    layerInfo.shapeLayer.opacity = opacity;
    
    CGRect tempRect = layerInfo.shapeLayer.frame;
    tempRect.origin = CGPointMake(self.center.x - self.frame.origin.x, self.center.y - self.frame.origin.y);
    layerInfo.shapeLayer.frame = tempRect;
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, radius, 0);
    CGPathAddArc(path, NULL, 0, 0, radius, 0, M_PI * 2, NO);
    
    layerInfo.shapeLayer.path = path;
}

/*
 Description: 执行动画
 */
- (void)doAnimation:(BZAShapeLayerInfo *)layerInfo {
    CAShapeLayer *shapeLayer = layerInfo.shapeLayer;
    if (layerInfo.lastOpacity == 0.0f) {
    } else {
        // 位置变化动画
        POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPosition];
        opacityAnimation.fromValue = [NSValue valueWithCGPoint:layerInfo.lastPosition.origin];
        opacityAnimation.toValue = [NSValue valueWithCGPoint:shapeLayer.frame.origin];
        [shapeLayer pop_addAnimation:opacityAnimation forKey:[NSString stringWithFormat:@"positionAnimation_%@", layerInfo.keyName]];
        
        // 避免不必要的大角度旋转。
        CGFloat diff = layerInfo.nextAngle - layerInfo.lastAngle;
        if (diff > M_PI_2) {
            layerInfo.nextAngle -= M_PI;
        } else if (diff < - M_PI_2) {
            layerInfo.nextAngle += M_PI;
        }
        if (layerInfo.lastAngle - layerInfo.nextAngle > 0.0001 || layerInfo.lastAngle - layerInfo.nextAngle < -0.0001) {
            // 角度变化动画
            POPSpringAnimation *angleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
            angleAnimation.fromValue = @(layerInfo.lastAngle - layerInfo.nextAngle);
            angleAnimation.toValue = @(0);
            angleAnimation.springBounciness = 20; // 0 - 20区间调整
            angleAnimation.springSpeed = 20.0;
            [shapeLayer pop_addAnimation:angleAnimation forKey:[NSString stringWithFormat:@"angleAnimation_%@", layerInfo.keyName]];
        }
    }
    
    // 透明度变化动画
    if (layerInfo.lastOpacity != shapeLayer.opacity) {
        POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
        opacityAnimation.fromValue = @(layerInfo.lastOpacity);
        opacityAnimation.toValue = @(shapeLayer.opacity);
        [shapeLayer pop_addAnimation:opacityAnimation forKey:[NSString stringWithFormat:@"opacityAnimation_%@", layerInfo.keyName]];
        layerInfo.lastOpacity = shapeLayer.opacity;
    }
    
}

- (void)doAnimationForCircle:(BZAShapeLayerInfo *)layerInfo {
    CAShapeLayer *shapeLayer = layerInfo.shapeLayer;
    
    POPSpringAnimation *sizeAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    sizeAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(layerInfo.lastLength / layerInfo.nextLength, 1.0f)];
    sizeAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0f, 1.0f)];
    sizeAnimation.springBounciness = 20; // 0 - 20区间调整
    sizeAnimation.springSpeed = 20.0;
    [shapeLayer pop_addAnimation:sizeAnimation forKey:[NSString stringWithFormat:@"sizeAnimation_%@",layerInfo.keyName]];
}

#pragma mark Public Method

- (void)setStyle:(AnimationButtonStyle)buttonStyle withAnimation:(BOOL)animate {
    self.buttonStyle = buttonStyle;
    if (self.lineLength == 0) {
        self.lineLength = ICONLENGTH;
    }
    
    switch(buttonStyle) {
            // offset记录从layer中心点到线的起点所需要的偏移量
        case AnimationButtonStyleThreeLines:
            [self addLineForPathWithLength:self.lineLength
                                              andAngle:0
                                   andStartPointOffset:CGPointMake(-self.lineLength / 2.0f, -self.lineLength / 2.0f * GOLDEN_RATIO)
                         andShapeLayerInfo:self.lineLayer1];
            
            [self addLineForPathWithLength:self.lineLength
                                              andAngle:0
                                   andStartPointOffset:CGPointMake(-self.lineLength / 2.0f, 0)
                                     andShapeLayerInfo:self.lineLayer2];
            self.lineLayer2.shapeLayer.opacity = 1.f;
            
            [self addLineForPathWithLength:self.lineLength
                                              andAngle:0
                                   andStartPointOffset:CGPointMake(-self.lineLength / 2.0f, self.lineLength / 2.0f *GOLDEN_RATIO)
                                     andShapeLayerInfo:self.lineLayer3];
            
            [self addCircleForPathWithRadius:self.lineLength / 6
                                  andOpacity:0
                           andShapeLayerInfo:self.circleLayer];
            break;
            
        case AnimationButtonStyleArrowRight:
            [self addLineForPathWithLength:self.lineLength / 2.0f
                                              andAngle:M_PI_4 * 3
                                   andStartPointOffset:CGPointMake(self.lineLength / 2.0f, 0)
                                     andShapeLayerInfo:self.lineLayer1];
            
            [self addLineForPathWithLength:self.lineLength andAngle:0
                                   andStartPointOffset:CGPointMake(-self.lineLength / 2.0f, 0)
                                     andShapeLayerInfo:self.lineLayer2];
            self.lineLayer2.shapeLayer.opacity = 1.f;
            
            [self addLineForPathWithLength:self.lineLength / 2.0f
                                              andAngle:M_PI_4 * 5
                                   andStartPointOffset:CGPointMake(self.lineLength / 2.0f, 0)
                         andShapeLayerInfo:self.lineLayer3];
            
            [self addCircleForPathWithRadius:self.lineLength / 6
                                  andOpacity:0
                           andShapeLayerInfo:self.circleLayer];
            break;
            
        case AnimationButtonStyleArrowLeft:
            [self addLineForPathWithLength:self.lineLength / 2.0f
                                  andAngle:M_PI_4 * -1
                       andStartPointOffset:CGPointMake(-self.lineLength / 2.0f, 0)
                         andShapeLayerInfo:self.lineLayer1];
            
            [self addLineForPathWithLength:self.lineLength andAngle:0
                       andStartPointOffset:CGPointMake(-self.lineLength / 2.0f, 0)
                         andShapeLayerInfo:self.lineLayer2];
            self.lineLayer2.shapeLayer.opacity = 1.f;
            
            [self addLineForPathWithLength:self.lineLength / 2.0f
                                  andAngle:M_PI_4 * 1
                       andStartPointOffset:CGPointMake(-self.lineLength / 2.0f, 0)
                         andShapeLayerInfo:self.lineLayer3];
            
            [self addCircleForPathWithRadius:self.lineLength / 6
                                  andOpacity:0
                           andShapeLayerInfo:self.circleLayer];
            break;
            
        case AnimationButtonStyleX:
            [self addLineForPathWithLength:self.lineLength
                                              andAngle:M_PI_4
                                       andCenterOffset:CGPointMake(0, 0)
                                     andShapeLayerInfo:self.lineLayer1];
            
            [self addLineForPathWithLength:self.lineLength
                                              andAngle:0
                                       andCenterOffset:CGPointMake(0, 0)
                                     andShapeLayerInfo:self.lineLayer2];
            self.lineLayer2.shapeLayer.opacity = 0.f;
            
            [self addLineForPathWithLength:self.lineLength
                                              andAngle:M_PI_4 * 3
                                       andCenterOffset:CGPointMake(0, 0)
                         andShapeLayerInfo:self.lineLayer3];
            
            [self addCircleForPathWithRadius:self.lineLength / 6
                                  andOpacity:0
                           andShapeLayerInfo:self.circleLayer];
            break;
            
        case AnimationButtonStyleAdd:
            [self addLineForPathWithLength:self.lineLength
                                              andAngle:0
                                       andCenterOffset:CGPointMake(0, 0)
                                     andShapeLayerInfo:self.lineLayer1];
            
            [self addLineForPathWithLength:self.lineLength
                                              andAngle:0
                                       andCenterOffset:CGPointMake(0, 0)
                                     andShapeLayerInfo:self.lineLayer2];
            self.lineLayer2.shapeLayer.opacity = 0.f;
            
            [self addLineForPathWithLength:self.lineLength
                                              andAngle:M_PI_2
                                       andCenterOffset:CGPointMake(0, 0)
                         andShapeLayerInfo:self.lineLayer3];
            
            [self addCircleForPathWithRadius:self.lineLength / 6
                                  andOpacity:0
                           andShapeLayerInfo:self.circleLayer];
            break;
            
        case AnimationButtonStyleDown:
            [self addLineForPathWithLength:self.lineLength / 2.0f
                                              andAngle:M_PI_4 *5
                                       andStartPointOffset:CGPointMake(0, self.lineLength / 5.7f)
                                     andShapeLayerInfo:self.lineLayer1];
            
            [self addLineForPathWithLength:self.lineLength
                                              andAngle:0
                                       andStartPointOffset:CGPointMake(0, 0)
                                     andShapeLayerInfo:self.lineLayer2];
            self.lineLayer2.shapeLayer.opacity = 0.f;
            
            [self addLineForPathWithLength:self.lineLength / 2.0f
                                              andAngle:M_PI_4 * 7
                                       andStartPointOffset:CGPointMake(0, self.lineLength / 5.7f)
                         andShapeLayerInfo:self.lineLayer3];
            
            [self addCircleForPathWithRadius:self.lineLength / 6
                                  andOpacity:0
                           andShapeLayerInfo:self.circleLayer];
            break;
            
        case AnimationButtonStyleUp:
            [self addLineForPathWithLength:self.lineLength / 2.0f
                                  andAngle:M_PI_4 * 1
                       andStartPointOffset:CGPointMake(0, -self.lineLength / 5.7f)
                         andShapeLayerInfo:self.lineLayer1];
            
            [self addLineForPathWithLength:self.lineLength
                                  andAngle:0
                       andStartPointOffset:CGPointMake(0, 0)
                         andShapeLayerInfo:self.lineLayer2];
            self.lineLayer2.shapeLayer.opacity = 0.f;
            
            [self addLineForPathWithLength:self.lineLength / 2.0f
                                  andAngle:M_PI_4 * 3
                       andStartPointOffset:CGPointMake(0, -self.lineLength / 5.7f)
                         andShapeLayerInfo:self.lineLayer3];
            
            [self addCircleForPathWithRadius:self.lineLength / 6
                                  andOpacity:0
                           andShapeLayerInfo:self.circleLayer];
            break;
            
        case AnimationButtonStyleLeft:
            [self addLineForPathWithLength:self.lineLength / 2.0f
                                  andAngle:M_PI_4 * -1
                       andStartPointOffset:CGPointMake(-self.lineLength / 5.7f, 0)
                         andShapeLayerInfo:self.lineLayer1];
            
            [self addLineForPathWithLength:self.lineLength
                                  andAngle:0
                       andStartPointOffset:CGPointMake(0, 0)
                         andShapeLayerInfo:self.lineLayer2];
            self.lineLayer2.shapeLayer.opacity = 0.f;
            
            [self addLineForPathWithLength:self.lineLength / 2.0f
                                  andAngle:M_PI_4 * 1
                       andStartPointOffset:CGPointMake(-self.lineLength / 5.7f, 0)
                         andShapeLayerInfo:self.lineLayer3];
            
            [self addCircleForPathWithRadius:self.lineLength / 6
                                  andOpacity:0
                           andShapeLayerInfo:self.circleLayer];
            break;
            
        case AnimationButtonStyleRight:
            [self addLineForPathWithLength:self.lineLength / 2.0f
                                  andAngle:M_PI_4 * 3
                       andStartPointOffset:CGPointMake(self.lineLength / 5.7f, 0)
                         andShapeLayerInfo:self.lineLayer1];
            
            [self addLineForPathWithLength:self.lineLength
                                  andAngle:0
                       andStartPointOffset:CGPointMake(0, 0)
                         andShapeLayerInfo:self.lineLayer2];
            self.lineLayer2.shapeLayer.opacity = 0.f;
            
            [self addLineForPathWithLength:self.lineLength / 2.0f
                                  andAngle:M_PI_4 * 5
                       andStartPointOffset:CGPointMake(self.lineLength / 5.7f, 0)
                         andShapeLayerInfo:self.lineLayer3];
            
            [self addCircleForPathWithRadius:self.lineLength / 6
                                  andOpacity:0
                           andShapeLayerInfo:self.circleLayer];
            break;
            
        case AnimationButtonStyleAddWithCircle:
            [self addLineForPathWithLength:self.lineLength
                                  andAngle:0
                           andCenterOffset:CGPointMake(0, 0)
                         andShapeLayerInfo:self.lineLayer1];
            
            [self addLineForPathWithLength:self.lineLength
                                  andAngle:0
                           andCenterOffset:CGPointMake(0, 0)
                         andShapeLayerInfo:self.lineLayer2];
            self.lineLayer2.shapeLayer.opacity = 0.f;
            
            [self addLineForPathWithLength:self.lineLength
                                  andAngle:M_PI_2
                           andCenterOffset:CGPointMake(0, 0)
                         andShapeLayerInfo:self.lineLayer3];
            
            [self addCircleForPathWithRadius:self.lineLength / 2
                                  andOpacity:1
                           andShapeLayerInfo:self.circleLayer];
            break;
            
        case AnimationButtonStyleXWithCircle:
            [self addLineForPathWithLength:self.lineLength
                                  andAngle:M_PI_4
                           andCenterOffset:CGPointMake(0, 0)
                         andShapeLayerInfo:self.lineLayer1];
            
            [self addLineForPathWithLength:self.lineLength
                                  andAngle:0
                           andCenterOffset:CGPointMake(0, 0)
                         andShapeLayerInfo:self.lineLayer2];
            self.lineLayer2.shapeLayer.opacity = 0.f;
            
            [self addLineForPathWithLength:self.lineLength
                                  andAngle:M_PI_4 * 3
                           andCenterOffset:CGPointMake(0, 0)
                         andShapeLayerInfo:self.lineLayer3];
            
            [self addCircleForPathWithRadius:self.lineLength / 2
                                  andOpacity:1
                           andShapeLayerInfo:self.circleLayer];
            break;
            
        default:
            break;
    }
    if (animate) {
        [self doAnimation:self.lineLayer1];
        [self doAnimation:self.lineLayer2];
        [self doAnimation:self.lineLayer3];
        [self doAnimationForCircle:self.circleLayer];
    } else {
        self.lineLayer1.beginAngle = self.lineLayer1.nextAngle;
        self.lineLayer1.beginLength = self.lineLayer1.nextLength;
        self.lineLayer1.lastOpacity = self.lineLayer1.shapeLayer.opacity;
        
        self.lineLayer2.beginAngle = self.lineLayer2.nextAngle;
        self.lineLayer2.beginLength = self.lineLayer2.nextLength;
        self.lineLayer2.lastOpacity = self.lineLayer2.shapeLayer.opacity;
        
        self.lineLayer3.beginAngle = self.lineLayer3.nextAngle;
        self.lineLayer3.beginLength = self.lineLayer3.nextLength;
        self.lineLayer3.lastOpacity = self.lineLayer3.shapeLayer.opacity;
    }
}

- (void)setLineColor:(UIColor *)color {
    [self.layerList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        CAShapeLayer *layer = [(BZAShapeLayerInfo *)obj shapeLayer];
    layer.fillColor = color.CGColor;
    }];
}

- (void)setLineWidth:(CGFloat)width {
    [self.layerList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        CAShapeLayer *layer = [(BZAShapeLayerInfo *)obj shapeLayer];
        layer.lineWidth = width;
    }];
}

- (void)setLayerLineLength:(CGFloat)length {
    self.lineLength = length;
}

@end
