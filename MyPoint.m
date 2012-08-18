//
//  MyPoint.m
//  Coloring
//
//  Created by Macbook on 8/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyPoint.h"

@implementation MyPoint
@synthesize x,y;
-(id)initWithX: (int)_x withY: (int ) _y
{
    self = [super init];
    if (self)
    {
        x = _x;
        y = _y;
    }
    return self;
}
@end
