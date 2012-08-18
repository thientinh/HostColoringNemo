//
//  Context.m
//  Coloring
//
//  Created by Macbook on 8/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Context.h"
#import "QueueLinearFloodFill.h"

@implementation Context
@synthesize x, y, img, strategy, strategy1, strategy2, colorBoundary, colorFill, colorStart, bitmap;
static Context * instance;
+(Context * )getInstance
{
    if (instance == nil)
    {
        instance = [[Context alloc]init];
    }
    return instance;
}
-(id)init
{
    self = [super init];
    if (self)
    {
        strategy1 =  [[QueueLinearFloodFill alloc]init];
        strategy = strategy1;
    }
    return self;
}
- (int) AlgorithmFillX:(int) _x withY: (int) _y
{
    x = _x;
    y = _y;
    return [strategy fill:self];
}
@end
