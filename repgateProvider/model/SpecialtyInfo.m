//
//  SpecialtyInfo.m
//  repgateProvider
//
//  Created by Helminen Sami on 3/22/17.
//  Copyright © 2017 developer. All rights reserved.
//

#import "SpecialtyInfo.h"

@implementation SpecialtyInfo

- (instancetype)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    
    if (self) {
        _id = dictionary[@"id"];
        _name = dictionary[@"name"];
        _parent = dictionary[@"parent"];
    }
    
    return self;
}

- (NSDictionary*)toDictionary
{
    NSAssert(NO, @"not implemented");
    
    return nil;
}

@end
