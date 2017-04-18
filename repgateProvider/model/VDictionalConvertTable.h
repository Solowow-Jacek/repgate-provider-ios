//
//  VDictionalConvertTable.h
//  repgateProvider
//
//  Created by Helminen Sami on 2/27/17.
//  Copyright © 2017 developer. All rights reserved.
//

#ifndef VDictionalConvertTable_h
#define VDictionalConvertTable_h

@protocol VDictionalConvertTable <NSObject>

- (instancetype)initWithDictionary:(NSDictionary*)dictionary;

- (NSDictionary*)toDictionary;

@end

#endif /* VDictionalConvertTable_h */
