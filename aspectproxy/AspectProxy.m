//
//  AspectProxy.m
//  AspectProxy
//
//  Created by John Malloy on 3/4/16.
//  Copyright © 2016 BigRedINC. All rights reserved.
//

#import "AspectProxy.h"



@implementation AspectProxy


-(id)initWithObject:(id)object selectors:(NSArray *)selectors andInvoker:(id<Invoker>)invoker
{
    _proxyTarget = object;
    _invoker = invoker;
    _selectors = [selectors mutableCopy];
    return self;
}

-(id)initWithObject:(id)object andInvoker:(id<Invoker>)invoker
{
    return [self initWithObject:object selectors:nil andInvoker:invoker];
}

-(NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
    return [self.proxyTarget methodSignatureForSelector:sel];
}

-(void)forwardInvocation:(NSInvocation *)inv
{
    //perform functionality before invoking method on target
    if ([self.invoker respondsToSelector:@selector(preInvoke:withTarget:)])
    {
        if (self.selectors != nil)
        {
            SEL methodSel = [inv selector];
            for (NSValue *selValue in self.selectors)
            {
                if (methodSel == [selValue pointerValue])
                {
                    [[self invoker] preInvoke:inv withTarget:self.proxyTarget];
                    break;
                }
            }
        }
        else
        {
            [[self invoker] preInvoke:inv withTarget:self.proxyTarget];
        }
    }
    //Invoke method on target
    [inv invokeWithTarget:self.proxyTarget];
    
    //Perform functionality after invoking method on target
    if ([self.invoker respondsToSelector:@selector(postInvoke:withTarget:)])
    {
        if (self.selectors != nil)
        {
            SEL methodSel = [inv selector];
            for (NSValue *selValue in self.selectors)
            {
                if (methodSel == [selValue pointerValue])
                {
                    [[self invoker] postInvoke:inv withTarget:self.proxyTarget];
                    break;
                }
            }
        }
        else
        {
            [[self invoker] postInvoke:inv withTarget:self.proxyTarget];
        }
    }
}

-(void)registerSelector:(SEL)selector
{
    NSValue * selValue = [NSValue valueWithPointer:selector];
    [self.selectors addObject:selValue];
}
            
@end
