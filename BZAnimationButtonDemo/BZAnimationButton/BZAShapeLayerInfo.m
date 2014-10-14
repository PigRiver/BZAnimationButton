//
//  BZAShapeLayerInfo.m
//  BZAnimationButtonDemo
//
//  Created by Bruce on 14-8-5.
//  Copyright (c) 2014年 com.Bruce.AnimationButtonDemo. All rights reserved.
//

#import "BZAShapeLayerInfo.h"

@implementation BZAShapeLayerInfo

- (id)initWithKeyName:(NSString *)keyName {
    self = [super init];
    if (self) {
        self.shapeLayer = [[CAShapeLayer alloc] init];
        self.lastLength = 0.0f;
        self.lastAngle = 0.0f;
        self.nextLength = 0.0f;
        self.nextAngle = 0.0f;
        self.lastOpacity = 1.0f;
        self.lastPosition = CGRectZero;
        self.keyName = keyName;
    }
    return self;
}

@end
