//
//  QueueLinearFloodFill.m
//  Coloring
//
//  Created by Macbook on 8/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QueueLinearFloodFill.h"
#import "ImageHelper.h"
#import "MyQueue.h"
#import "MyPoint.h"

struct nodequeue {
    int x;
    int y;
    struct nodequeue * next;
};
typedef struct nodequeue node;
int countQueue = 0;
node * queueFirst = NULL;
node * queueLast = NULL;

node * dequeue()
{
    if (countQueue>0)
    {
        node * bk = queueFirst;
        queueFirst = queueFirst->next;
        countQueue--;
        if (countQueue == 0)
            queueLast = NULL;
        //free(bk);
        return bk;
        
    }
    queueFirst = NULL;
    queueLast = NULL;
    return NULL;
}
void enqueue(node * obj)
{
    obj->next = NULL;
    if (queueLast == NULL)
    {
        queueFirst = obj;
        queueLast = obj;
    }
    else
    {
        queueLast->next = obj;
        queueLast = obj;
    }
    
    countQueue++;
}


unsigned char  tolerance[] = {0, 0, 0, 0};
#define LENGHTCOLOR 4

@implementation QueueLinearFloodFill
@synthesize bitmap;

-(void)prepare:(Context *)context
{
    float r, g, b, a;
    
    [context.colorStart getRed:&r green:&g blue:&b alpha:&a] ;
    startColor = malloc(LENGHTCOLOR * sizeof(unsigned char));
    startColor[0] = r*255;
    startColor[1] = g*255;
    startColor[2] = b*255;
    startColor[3] = a*255;
    
    [context.colorFill getRed:&r green:&g blue:&b alpha:&a] ;
    byteFillColor = malloc(LENGHTCOLOR * sizeof(unsigned char));
    byteFillColor[0] = r*255;
    byteFillColor[1] = g*255;
    byteFillColor[2] = b*255;
    byteFillColor[3] = a*255;
    
    [context.colorBoundary getRed:&r green:&g blue:&b alpha:&a] ;
    byteBoundColor = malloc(LENGHTCOLOR * sizeof(unsigned char));
    byteBoundColor[0] = 0;//r*255;
    byteBoundColor[1] = 0;//g*255;
    byteBoundColor[2] = 0;//b*255;
    byteBoundColor[3] = 255;//a*255;
    
    bitmapWidth = context.img.size.width;
    bitmapHeight = context.img.size.height;
    
    pixelFormatSize = LENGHTCOLOR;//
    bitmapStride = bitmapWidth *pixelFormatSize;
    //padding = bitmapStride % 4;
    //bitmapStride += padding == 0? 0: 4 - padding;
    bitmapPixelFormatSize  = pixelFormatSize;
    
    bits = [ImageHelper convertUIImageToBitmapRGBA8:context.img];
    
    
    countQueue = 0;
    queueFirst = NULL;
    queueLast = NULL;

}
-(bool)CheckPixel:(const int)px
{
    
    return (
            (
             !(bits[px] == byteFillColor[0]  &&
               bits[px + 1] == byteFillColor[1] &&
               bits[px + 2] == byteFillColor[2] &&
               bits[px + 3] == byteFillColor[3] )
             ) &&
            !(bits[px] == byteBoundColor[0]   && bits[px + 1] == byteBoundColor[1] && bits[px + 1] == byteBoundColor[1] &&
              bits[px + 2]== byteBoundColor[2] &&
              bits[px + 3] == byteBoundColor[3] )
            );
}
/*
-(bool)CheckPixel:(const int)px
{
   
    return (
            (
             !((bits[px] >= (byteFillColor[0] - tolerance[0])) && bits[px] <= (byteFillColor[0] + tolerance[0]) &&
               (bits[px + 1] >= (byteFillColor[1] - tolerance[1])) && bits[px + 1] <= (byteFillColor[1] + tolerance[1]) &&
               (bits[px + 2] >= (byteFillColor[2] - tolerance[2])) && bits[px + 2] <= (byteFillColor[2] + tolerance[2]) &&
               (bits[px + 3] >= (byteFillColor[3] - tolerance[3])) && bits[px + 3] <= (byteFillColor[3] + tolerance[3]))
             ) &&
            !((bits[px] >= (byteBoundColor[0] - tolerance[0])) && bits[px] <= (byteBoundColor[0] + tolerance[0]) &&
              (bits[px + 1] >= (byteBoundColor[1] - tolerance[1])) && bits[px + 1] <= (byteBoundColor[1] + tolerance[1]) &&
              (bits[px + 2] >= (byteBoundColor[2] - tolerance[2])) && bits[px + 2] <= (byteBoundColor[2] + tolerance[2]) &&
              (bits[px + 3] >= (byteBoundColor[3] - tolerance[3])) && bits[px + 3] <= (byteBoundColor[3] + tolerance[3]))
            );
}
*/ 
-(int)CoordsToByteIndex:(const  int) _x withY:(const  int) _y
{
    return (bitmapStride * _y) + (_x * bitmapPixelFormatSize);
}

-(int)CoordsToPixelIndex:(const int) _x withY:(const int) _y
{
    return (bitmapWidth * _y) + _x;
}
-(bool)checkSeed:(const int) _px withY: (const int) _py 
{
   
    int x , y;
    x = _px; y = _py;
    //int idx = CoordsToByteIndex(ref x, ref y);
    int idx = [self CoordsToByteIndex:x withY:y];
    //if (!CheckPixel( idx))
    if (![self CheckPixel:idx] )
    {
        return false;
    }
    
    int h = 0;
    int x2, y2;
    x2 = _px - h;
    y2 = _py;
    //int idx2 = CoordsToByteIndex(ref x2, ref y2);
    int idx2 = [self CoordsToByteIndex:x2 withY:y2];
    //while (CheckPixel(ref idx2))
    while ([self CheckPixel:idx2])
    {
        if (_px - h == 0)
        {
            //_queue.Enqueue(new Point(0, _p.Y));
            //[_queue enqueue:[[MyPoint alloc] initWithX:0 withY:_p.y]];
            node *obj = malloc(sizeof(node));
            obj->x = 0;
            obj->y = _py;
            enqueue(obj);
            return true;
        }
        h++;
        x2 = _px - h;
        y2 = _py;
        //idx2 = CoordsToByteIndex(ref x2, ref y2);
        idx2 = [self CoordsToByteIndex:x2 withY:y2];
    }
    //_queue.Enqueue(new Point(_p.X - h + 1, _p.Y));
    //[_queue enqueue:[[MyPoint alloc] initWithX:_p.x - h + 1 withY:_p.y]];
    node *newnode = malloc(sizeof(node));
    newnode->x = _px - h + 1;
    newnode->y = _py;
    enqueue(newnode);
    
    return true;
}


-(void)process:(const int)_x withY: (const int)_y
{
    //MyQueue *queue = [[MyQueue alloc]init];
    //MyPoint *point = [[MyPoint alloc]initWithX:_x withY:_y];
    //[queue enqueue:point];
    node *obj = malloc(sizeof(node));
    obj->x = _x;
    obj->y = _y;
    enqueue(obj);
    
    while (countQueue > 0)
    {
        node *k = dequeue();
        node P = *k;
        
        int increaseX = 0;
        bool havePointUpQueue = false;
        bool havePointDownQueue = false;
        int x, y;
        x = P.x; y = P.y;
        
        //int idx = CoordsToByteIndex(ref x, ref y);
        int idx = [self CoordsToByteIndex:x withY:y];
        /*while (P.X < bitmapWidth - increaseX
               && P.Y > 0 && P.Y < bitmapHeight - 1
               && CheckPixel(ref idx))
        */ 
        
      
        while (P.x < bitmapWidth - increaseX
               && P.y > 0 && P.y < bitmapHeight - 1
               && [self CheckPixel:idx])
        {
            
            bits[idx] = byteFillColor[0];
            bits[idx + 1] = byteFillColor[1];
            bits[idx + 2] = byteFillColor[2];
            bits[idx + 3] = byteFillColor[3];
            
            
            if (!havePointUpQueue)
                //if (checkSeed(new Point(P.X + increaseX, P.Y + 1), queue)) 
                    if ([self checkSeed:P.x + increaseX withY:P.y + 1])   
                        havePointUpQueue = true;
            if (!havePointDownQueue)
                //if (checkSeed(new Point(P.X + increaseX, P.Y - 1), queue)) 
                if ([self checkSeed:P.x + increaseX withY:P.y - 1] )
                    havePointDownQueue = true;
            
            int idxUp2;
            int idxDown2;
            int x3;
            int y3;
            x3 = P.x + increaseX;
            y3 = P.y + 1;
            //idxUp2 = CoordsToByteIndex(ref x3, ref y3);
            idxUp2 = [self CoordsToByteIndex:x3 withY:y3];
            //if (!CheckPixel(ref idxUp2))
            if (![self CheckPixel:idxUp2])
                havePointUpQueue = false;
            
            int x4;
            int y4;
            x4 = P.x + increaseX;
            y4 = P.y - 1;
            //idxDown2 = CoordsToByteIndex(ref x4, ref y4);
            idxDown2 = [self CoordsToByteIndex:x4 withY:y4];
            //if (!CheckPixel(ref idxDown2))
            if (![self CheckPixel:idxDown2])
                havePointDownQueue = false;
            
            increaseX++;
            
            x = P.x + increaseX;
            y = P.y;
            //idx = CoordsToByteIndex(ref x, ref y);
            idx = [self CoordsToByteIndex:x withY:y];
            
        }

        
    }
}

-(int)fill:(Context *)context
{
    NSLog(@"Fill Queue") ;
    NSLog(@"Position: x = %d, y = %d", context.x, context.y);
    [self prepare:context];
    [self process:context.x withY:context.y];
    bitmap = [ImageHelper convertBitmapRGBA8ToUIImage:bits withWidth:bitmapWidth withHeight:bitmapHeight];
    [context setBitmap:bitmap];
    return 1;
}

@end
