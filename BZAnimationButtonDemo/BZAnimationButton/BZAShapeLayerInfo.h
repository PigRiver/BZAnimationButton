//
//  BZAShapeLayerInfo.h
//  BZAnimationButtonDemo
//
//  Created by Bruce on 14-8-5.
//  Copyright (c) 2014年 com.Bruce.AnimationButtonDemo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BZAShapeLayerInfo : NSObject

@property (strong, nonatomic) CAShapeLayer *shapeLayer;
@property (nonatomic) CGFloat beginAngle;
@property (nonatomic) CGFloat beginLength;
@property (nonatomic) CGFloat lastLength;
@property (nonatomic) CGFloat lastAngle;
@property (nonatomic) CGFloat nextLength;
@property (nonatomic) CGFloat nextAngle;
@property (nonatomic) CGFloat lastOpacity;
@property (nonatomic) CGRect lastPosition;
@property (strong, nonatomic) NSString *keyName;

- (id)initWithKeyName:(NSString *)keyName;

@end
