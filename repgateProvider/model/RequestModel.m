//
//  RequestModel.m
//  repgateProvider
//
//  Created by Helminen Sami on 3/7/17.
//  Copyright © 2017 developer. All rights reserved.
//

#import "RequestModel.h"
#import "RequestItem.h"

@implementation RequestModel

- (instancetype)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    
    if (self) {
        _date = dictionary[@"date"];
        NSMutableArray *array = dictionary[@"reqs"];
        
        if (_reqs == nil) {
            _reqs = [[NSMutableArray alloc] init];
        } else {
            [_reqs removeAllObjects];
        }
        
        for (int i=0; i < array.count; i++) {
            NSDictionary *dic = [array objectAtIndex:i];
            
            RequestItem *req = [[RequestItem alloc] initWithDictionary:dic];
            [_reqs addObject:req];
        }
    }
    
    return self;
}

- (NSDictionary*)toDictionary
{
    NSAssert(NO, @"not implemented");
    
    return nil;
}

@end
