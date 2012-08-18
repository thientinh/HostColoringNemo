//
//  MyQueue.h
//  Coloring
//
//  Created by Macbook on 8/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyQueue : NSObject
{
	NSMutableArray* m_array;
}

- (void)enqueue:(id)anObject;
- (id)dequeue;
- (void)clear;

@property (nonatomic, readonly) int count;

@end
