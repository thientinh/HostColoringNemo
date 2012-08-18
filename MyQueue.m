//
//  MyQueue.m
//  Coloring
//
//  Created by Macbook on 8/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyQueue.h"
#import "MyPoint.h"
@implementation MyQueue
@synthesize count;

- (id)init
{
	if( self=[super init] )
	{
		m_array = [[NSMutableArray alloc] init];
		count = 0;
	}
	return self;
}

- (void)enqueue:(id)anObject
{
	[m_array addObject:anObject];
	count = m_array.count;
}
- (id)dequeue
{
	id obj = nil;
	if(m_array.count > 0)
	{
		obj = [m_array objectAtIndex:0];
        /*
        int x = ((MyPoint*)obj).x;
        int y = ((MyPoint*)obj).y;
        */ 
		[m_array removeObjectAtIndex:0];
		count = m_array.count;
	}
	return obj;
}

- (void)clear
{
	[m_array removeAllObjects];
	count = 0;
}

@end
