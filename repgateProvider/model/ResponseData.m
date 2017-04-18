//
//  ResponseData.m
//  repgateProvider
//
//  Created by Helminen Sami on 3/1/17.
//  Copyright © 2017 developer. All rights reserved.
//

#import "ResponseData.h"

@implementation ResponseData

- (instancetype)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    
    if (self) {
        _success = dictionary[@"success"];
        _error = dictionary[@"error"];
    }
    
    return self;
}

- (NSDictionary*)toDictionary
{
    NSAssert(NO, @"not implemented");
    
    return nil;
}

@end
