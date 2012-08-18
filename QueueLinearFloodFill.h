//
//  QueueLinearFloodFill.h
//  Coloring
//
//  Created by Macbook on 8/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IStrategy.h"

@interface QueueLinearFloodFill : IStrategy
{
    unsigned char * bits;
    unsigned char * byteFillColor;
    unsigned char * byteBoundColor;
    unsigned char * startColor;
    
    int bitmapWidth;
    int bitmapHeight;
    int pixelFormatSize;
    int bitmapStride;
    int padding;
    int bitmapPixelFormatSize;
    
       
}
@property (nonatomic, retain)  UIImage * bitmap;

@end
