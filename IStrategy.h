//
//  IStrategy.h
//  Coloring
//
//  Created by Macbook on 8/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Context.h"
@class Context;
@interface IStrategy : NSObject
{
    
}
-(int)fill:(Context *)_context;

@end
