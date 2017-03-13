//
//  STPoint.h
//  MyAllDemos
//
//  Created by yaochaowen on 2017/3/2.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#ifndef STPoint_h
#define STPoint_h

struct STPoint {
    CGFloat x;
    CGFloat y;
    CGFloat z;
};

typedef struct STPoint STPoint;


STPoint STPointMake(CGFloat x, CGFloat y, CGFloat z) {
    STPoint point;
    point.x = x;
    point.y = y;
    point.z = z;
    return point;
}

#endif /* STPoint_h */
