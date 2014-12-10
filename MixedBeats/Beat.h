//
//  Beat.h
//  MixedBeats
//
//  Created by Brian Mendez on 12/5/14.
//  Copyright (c) 2014 Brian Mendez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Beat : NSObject

@property (strong, nonatomic) NSString *name;

+ (NSMutableArray *)parseJSONIntoBeats:(NSData *)rawJSONData;

@end
