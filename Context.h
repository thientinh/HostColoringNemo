//
//  Context.h
//  Coloring
//
//  Created by Macbook on 8/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IStrategy.h"
@class IStrategy;
@interface Context : NSObject
{
  
    
}
@property (nonatomic, retain) UIImage *img;
@property (nonatomic, retain) UIColor * colorStart;
@property (nonatomic, retain) UIColor *  colorFill;
@property (nonatomic, retain) UIColor *  colorBoundary;
@property int x;
@property int y;

@property (nonatomic, retain) IStrategy * strategy ;
@property (nonatomic, retain) IStrategy * strategy1,  *strategy2;
@property (nonatomic, retain)  UIImage * bitmap;
+(Context * )getInstance;
- (int) AlgorithmFillX:(int) _x withY: (int) _y;
@end
