//
//  SpecialtyInfo.h
//  repgateProvider
//
//  Created by Helminen Sami on 3/22/17.
//  Copyright © 2017 developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VDictionalConvertTable.h"

@interface SpecialtyInfo : NSObject<VDictionalConvertTable>

@property(nonatomic,strong) NSString* id;
@property(nonatomic,strong) NSString* name;
@property(nonatomic,strong) NSString* parent;

@end
