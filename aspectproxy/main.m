//
//  main.m
//  AspectProxy
//
//  Created by John Malloy on 2/28/16.
//  Copyright © 2016 BigRedINC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AspectProxy.h"
#import "AuditingInvoker.h"
#import "Calculator.h"

int main(int argc, const char * argv[])
{
    @autoreleasepool
    {
        //Create calculator object
        id calculator = [[Calculator alloc] init];
        NSNumber * addend1 = [NSNumber numberWithInteger:-25];
        NSNumber * addend2 = [NSNumber numberWithInteger:10];
        NSNumber * addend3 = [NSNumber numberWithInteger:15];
        
        //Create proxy for object
        NSValue * selValue1 = [NSValue valueWithPointer:@selector(sumAddend1:addend2:)];
        NSArray * selValues = @[selValue1];
        AuditingInvoker * invoker = [[AuditingInvoker alloc] init];
        id calculatorProxy = [[AspectProxy alloc] initWithObject:calculator
                                                       selectors:selValues
                                                      andInvoker:invoker];
        
        //Send message to proxy with given selector
        [calculatorProxy sumAddend1:addend1 addend2:addend2];
        
        //Send message to proxy with different selector, no special processing!
        [calculatorProxy sumAddend1:addend2 :addend3];
        
        //Register another selector for proxy and repeat message
        [calculatorProxy registerSelector:@selector(sumAddend1::)];
        [calculatorProxy sumAddend1:addend1 :addend3];
        
    }
    
    return 0;
}
