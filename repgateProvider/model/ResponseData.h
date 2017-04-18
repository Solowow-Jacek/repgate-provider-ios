//
//  ResponseData.h
//  repgateProvider
//
//  Created by Helminen Sami on 3/1/17.
//  Copyright © 2017 developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VDictionalConvertTable.h"

@interface ResponseData : NSObject<VDictionalConvertTable>

@property(nonatomic,strong) NSNumber* success;
@property(nonatomic,strong) NSString* error;

@end
