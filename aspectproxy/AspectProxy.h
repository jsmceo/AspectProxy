//
//  AspectProxy.h
//  AspectProxy
//
//  Created by John Malloy on 3/4/16.
//  Copyright © 2016 BigRedINC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Invoker.h"

@interface AspectProxy : NSObject

@property (strong) id proxyTarget;
@property (strong) id<Invoker> invoker;
@property (readonly) NSMutableArray * selectors;

-(id)initWithObject:(id)object andInvoker:(id<Invoker>)invoker;
-(id)initWithObject:(id)object selectors:(NSArray *)selectors andInvoker:(id<Invoker>)invoker;
-(void)registerSelector:(SEL)selector;

@end
