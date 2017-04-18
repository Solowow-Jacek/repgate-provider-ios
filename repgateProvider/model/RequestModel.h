//
//  RequestModel.h
//  repgateProvider
//
//  Created by Helminen Sami on 3/7/17.
//  Copyright © 2017 developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VDictionalConvertTable.h"

@interface RequestModel : NSObject<VDictionalConvertTable>

@property(nonatomic,strong) NSString* date;
@property(nonatomic,strong) NSMutableArray* reqs;

@end
